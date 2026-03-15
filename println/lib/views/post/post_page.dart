import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:println/core/services/post_service.dart';

import 'package:println/core/theme/app_spacing.dart';
import 'package:println/core/theme/app_text_styles.dart';
import 'package:println/core/theme/app_colors.dart';
import 'package:println/core/validators/validators.dart';

import 'package:println/view_models/post/post_store.dart';
import 'package:println/core/services/api_service.dart';
import 'package:println/widgets/form_input.dart';

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
  void initState() {
    super.initState();

    postStore = PostStore(
      PostService(ApiService()),
    );

    contentController.text = widget.initialContent ?? "";
    locationController.text = widget.initialLocation ?? "";
    imageUrl = widget.initialImageUrl;
  }

  Future<void> pickImage() async {

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image == null) return;

    if (kIsWeb) {

      final bytes = await image.readAsBytes();

      setState(() {
        webImage = bytes;
        imageUrl = null;
        selectedImage = null;

      });

    } else {

      setState(() {
        selectedImage = File(image.path);
        imageUrl = null;
        webImage = null;
      });

    }

  }

  Future<void> submit() async {

    if (!_formKey.currentState!.validate()) return;

    bool created = false;

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

    if (created && mounted) {
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

      appBar: AppBar(
        title: Text(widget.isEditing ? "Editar Post" : "Criar Post"),
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
                    child: Text("Remover imagem"),
                  ),
                ),

              const SizedBox(height: AppSpacing.lg),

              FormInput(
                controller: contentController,
                hint: "Escreva algo...",
                title: "Conteúdo",
                maxLines: 4,
                validator: Validators.validarConteudo,
              ),

              const SizedBox(height: AppSpacing.lg),

              FormInput(
                controller: locationController,
                hint: "Localização opcional",
                title: "Localização",
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