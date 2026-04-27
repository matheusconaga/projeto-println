import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:println/core/theme/app_colors.dart';
import 'package:println/core/ui/app_dialog.dart';
import 'package:println/core/ui/app_snack_bar.dart';
import 'package:println/view_models/auth/auth_store.dart';
import 'package:println/view_models/feed/feed_store.dart';
import 'package:println/view_models/theme/theme_store.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:provider/provider.dart';

class UserMenuDialog extends StatelessWidget {
  final VoidCallback onEditProfile;
  final VoidCallback onLogout;

  const UserMenuDialog({
    super.key,
    required this.onEditProfile,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final authStore = context.read<AuthStore>();
    final themeStore = context.read<ThemeStore>();
    final feedStore = context.read<FeedStore>();

    return SimpleDialog(
      contentPadding: const EdgeInsets.all(16),
      children: [
        Observer(
          builder: (_) {
            final user = authStore.user;
            if (user == null) return const SizedBox.shrink();

            return Column(
              children: [

                /// USER INFO
                CircleAvatar(
                  radius: 40,
                  backgroundImage: user.photo != null
                      ? NetworkImage(user.photo!)
                      : null,
                  child: user.photo == null
                      ? const Icon(Icons.person, size: 40)
                      : null,
                ),

                const SizedBox(height: 12),

                Text(
                  user.username,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 4),

                Text(
                  user.email ?? "",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),

                const Divider(height: 32),

                /// 🌗 THEME SWITCH
                Observer(
                  builder: (_) {
                    final isDark = themeStore.isDark(context);

                    return ListTile(
                      leading: Icon(
                        isDark ? Icons.dark_mode : Icons.light_mode,
                      ),
                      title: Text(
                        isDark ? "Modo escuro ativado" : "Modo claro ativado",
                      ),
                      trailing: Switch(
                        value: isDark,
                        onChanged: (value) {
                          themeStore.setTheme(
                            value ? ThemeMode.dark : ThemeMode.light,
                          );

                          AppSnackbar.info(
                            value
                                ? "Modo escuro ativado"
                                : "Modo claro ativado",
                          );
                        },
                      ),
                    );
                  },
                ),

                /// EDIT PROFILE
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text("Editar Perfil"),
                  onTap: () {
                    _showEditProfileDialog(
                      context,
                      user,
                      authStore,
                      feedStore,
                    );
                  },
                ),

                /// LOGOUT
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text("Sair", style: TextStyle(color: Colors.red)),
                  onTap: () async {
                    final confirmed = await AppDialog.confirm(
                      context: context,
                      title: "Confirmar logout",
                      description: "Tem certeza que deseja sair?",
                      confirmText: "Sair",
                      cancelText: "Cancelar",
                      confirmColor: Colors.red,
                      icon: Icons.logout,
                      iconColor: Colors.red,
                    );

                    if (confirmed ?? false) {
                      Navigator.pop(context);

                      AppSnackbar.info("Saindo da conta...");

                      Future.delayed(const Duration(milliseconds: 400), () {
                        onLogout();
                        AppSnackbar.success("Você saiu da conta!");
                      });
                    }

                  },
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  void _showEditProfileDialog(
      BuildContext context,
      user,
      AuthStore authStore,
      FeedStore feedStore,
      ) {
    final usernameController = TextEditingController(text: user.username);

    File? selectedImage;
    Uint8List? webImage;
    bool removeImage = false;
    final picker = ImagePicker();

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text("Editar Perfil"),
          content: SingleChildScrollView(
            child: Column(
              children: [

                /// IMAGE
                GestureDetector(
                  onTap: () async {
                    final image = await picker.pickImage(source: ImageSource.gallery);
                    if (image == null) return;

                    if (kIsWeb) {
                      final bytes = await image.readAsBytes();
                      setState(() {
                        webImage = bytes;
                        selectedImage = null;
                        removeImage = false;
                      });
                    } else {
                      setState(() {
                        selectedImage = File(image.path);
                        webImage = null;
                        removeImage = false;
                      });
                    }
                  },
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: webImage != null
                        ? MemoryImage(webImage!)
                        : selectedImage != null
                        ? FileImage(selectedImage!) as ImageProvider
                        : user.photo != null && !removeImage
                        ? NetworkImage(user.photo!)
                        : null,
                    child: user.photo == null &&
                        selectedImage == null &&
                        webImage == null
                        ? const Icon(Icons.person, size: 40)
                        : null,
                  ),
                ),

                const SizedBox(height: 8),

                if ((user.photo != null && !removeImage) ||
                    selectedImage != null ||
                    webImage != null)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        selectedImage = null;
                        webImage = null;
                        removeImage = true;
                      });
                    },
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Icon(Icons.delete_forever, color: AppColors.danger,size: 25,),
                    Text("Remover imagem", style: TextStyle(color: AppColors.danger),),
                    ],
                    ),
                  ),

                const SizedBox(height: 12),

                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(labelText: "Username"),
                ),
              ],
            ),
          ),
          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context);

                showDialog(
                  context: context,
                  builder: (_) => UserMenuDialog(
                    onEditProfile: onEditProfile,
                    onLogout: onLogout,
                  ),
                );
              },
              child: const Text("Cancelar"),
            ),

            Observer(
              builder: (_) {
                return TextButton(
                  onPressed: authStore.loading
                      ? null
                      : () async {
                    File? finalImage =
                    removeImage ? null : selectedImage;

                    Uint8List? finalWebImage =
                    removeImage ? null : webImage;

                    await authStore.updateUser(
                      userId: user.id,
                      username: usernameController.text,
                      photo: finalImage,
                      webPhoto: finalWebImage,
                      removePhoto: removeImage,
                    );

                    await feedStore.loadFeed();

                    Navigator.pop(context);

                    AppSnackbar.success("Perfil atualizado com sucesso");
                  },
                  child: authStore.loading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child:
                    CircularProgressIndicator(strokeWidth: 2),
                  )
                      : const Text("Salvar"),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}