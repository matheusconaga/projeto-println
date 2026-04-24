import 'dart:io';
import 'package:println/core/ui/app_loading.dart';
import 'package:println/view_models/post/post_store.dart';
import 'package:println/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:println/core/theme/app_spacing.dart';
import 'package:println/core/theme/app_text_styles.dart';
import 'package:println/core/theme/app_colors.dart';
import 'package:println/core/validators/validators.dart';

import 'package:println/widgets/form_input.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class PostPage extends StatefulWidget {

  final String? postId;
  final String? initialContent;
  final String? initialLocation;
  final String? initialImageUrl;

  const PostPage({
    super.key,
    this.postId,
    this.initialContent,
    this.initialLocation,
    this.initialImageUrl,
  });

  bool get isEditing => postId != null;

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {

  final _formKey = GlobalKey<FormState>();

  final contentController = TextEditingController();
  final locationController = TextEditingController();

  File? selectedImage;
  Uint8List? webImage;
  String? imageUrl;
  bool removeImage = false;

  final ImagePicker picker = ImagePicker();

  late PostStore postStore;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    postStore = context.read<PostStore>();
  }

  @override
  void initState() {
    super.initState();

    contentController.text = widget.initialContent ?? "";
    locationController.text = widget.initialLocation ?? "";
    imageUrl = widget.initialImageUrl;
  }

  Future<void> pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Galeria"),
              onTap: () async {
                Navigator.of(context).pop();
                await _pickImageFromSource(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Câmera"),
              onTap: () async {
                Navigator.of(context).pop();
                await _pickImageFromSource(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImageFromSource(ImageSource source) async {
    final XFile? image = await picker.pickImage(source: source);
    if (image == null) return;

    if (kIsWeb) {
      final bytes = await image.readAsBytes();
      setState(() {
        webImage = bytes;
        selectedImage = null;
        imageUrl = null;
      });
    } else {
      setState(() {
        selectedImage = File(image.path);
        webImage = null;
        imageUrl = null;
      });
    }
  }

  Future<void> getCurrentLocation(
      BuildContext context, TextEditingController locationController) async {
    try {
      final useLocation = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text("Usar localização?"),
          content: const Text("Deseja adicionar sua localização atual ao post?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text("Não"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text("Sim"),
            ),
          ],
        ),
      );

      if (useLocation != true) return;

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("O GPS está desativado. Por favor, ative-o.")),
          );
        }
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Permissão de localização negada.")),
            );
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Permissão negada permanentemente. Altere nas configurações.")),
          );
        }
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;

        const stateAbbreviations = {
          "Acre": "AC", "Alagoas": "AL", "Amapá": "AP", "Amazonas": "AM",
          "Bahia": "BA", "Ceará": "CE", "Distrito Federal": "DF",
          "Espírito Santo": "ES", "Goiás": "GO", "Maranhão": "MA",
          "Mato Grosso": "MT", "Mato Grosso do Sul": "MS", "Minas Gerais": "MG",
          "Pará": "PA", "Paraíba": "PB", "Paraná": "PR", "Pernambuco": "PE",
          "Piauí": "PI", "Rio de Janeiro": "RJ", "Rio Grande do Norte": "RN",
          "Rio Grande do Sul": "RS", "Rondônia": "RO", "Roraima": "RR",
          "Santa Catarina": "SC", "São Paulo": "SP", "Sergipe": "SE", "Tocantins": "TO",
        };

        String city = place.subAdministrativeArea ??
            place.locality ??
            place.subLocality ??
            "Cidade Desconhecida";

        String stateRaw = place.administrativeArea ?? "";
        String uf = "";

        if (stateRaw.length == 2) {
          uf = stateRaw.toUpperCase();
        } else {
          uf = stateAbbreviations[stateRaw] ?? stateRaw;
        }

        locationController.text = "$city - $uf";
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao obter localização: $e")),
        );
      }
    }
  }

  Future<void> submit() async {

    if (!_formKey.currentState!.validate()) return;

    AppLoading.show(
      context,
      message: widget.isEditing
          ? "Atualizando postagem..."
          : "Publicando...",
    );

    await Future.delayed(Duration.zero);

    bool created = false;

    try {

      if (widget.isEditing) {

        await postStore.editPost(
          postId: widget.postId!,
          content: contentController.text,
          location: locationController.text,
          selectedImage: selectedImage,
          webImage: webImage,
          removeImage: removeImage,
        );

        created = true;

      } else {

        created = await postStore.createPost(
          content: contentController.text,
          location: locationController.text,
          selectedImage: selectedImage,
          webImage: webImage,
        );

      }

    } finally {

      if (mounted) {
        AppLoading.hide(context);
      }

    }

    if (!mounted) return;

    if (created) {
      Navigator.pop(context, true);
    } else if (postStore.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(postStore.error!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(

      appBar: CustomAppBar(
        title: widget.isEditing ? "Editar Post" : "Criar Post",
        onBackTap: () {
          Navigator.pop(context, true);
        },
        showNotifications: false,
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(AppSpacing.lg),

        child: Form(

          key: _formKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              GestureDetector(

                onTap: pickImage,

                child: Container(

                  height: 200,
                  width: double.infinity,

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: isDark
                        ? DarkColors.surface
                        : LightColors.surface,
                  ),

                  child: webImage != null
                      ? Image.memory(webImage!, fit: BoxFit.cover)
                      : selectedImage != null
                      ? Image.file(selectedImage!, fit: BoxFit.cover)
                      : imageUrl != null
                      ? Image.network(imageUrl!, fit: BoxFit.cover)
                      : const Center(
                    child: Icon(Icons.add_a_photo, size: 40),
                  ),

                ),

              ),

              if (webImage != null || selectedImage != null || imageUrl != null)
                TextButton(
                  onPressed: () {
                    setState(() {
                      webImage = null;
                      selectedImage = null;
                      imageUrl = null;
                      removeImage = true;
                    });

                  },
                  child: const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.delete_forever, color: AppColors.danger,size: 25,),
                        Text("Remover imagem", style: TextStyle(color: AppColors.danger),),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: AppSpacing.lg),

              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  GestureDetector(
                    onTap: () async {
                      await getCurrentLocation(context, locationController);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.md,
                        horizontal: AppSpacing.lg,
                      ),
                      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? DarkColors.surface.withOpacity(0.5)
                            : LightColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.primaryDark
                              : AppColors.primaryLight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.my_location,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            "Usar localização atual",
                            style: AppTextStyles.button.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  FormInput(
                    controller: locationController,
                    hint: "Localização opcional",
                    title: "Localização",
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.lg),

              FormInput(
                controller: contentController,
                hint: "Escreva algo...",
                title: "Conteúdo",
                maxLines: 4,
                validator: Validators.validarConteudo,
              ),

              const SizedBox(height: AppSpacing.xl),

              SizedBox(

                width: double.infinity,

                child: Observer(

                  builder: (_) {

                    return ElevatedButton(

                      onPressed: postStore.loading ? null : submit,

                      child: postStore.loading
                          ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ))
                          : Text(
                        widget.isEditing
                            ? "Atualizar Post"
                            : "Publicar",
                        style: AppTextStyles.button,
                      ),

                    );

                  },

                ),

              )

            ],
          ),

        ),

      ),

    );

  }

}