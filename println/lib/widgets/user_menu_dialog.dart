import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';

import 'package:println/view_models/auth/auth_store.dart';
import 'package:println/view_models/theme/theme_store.dart';
import 'package:println/view_models/feed/feed_store.dart';

class UserMenuDialog extends StatelessWidget {
  final ThemeStore themeStore;
  final AuthStore authStore;
  final FeedStore feedStore;
  final VoidCallback onEditProfile;
  final VoidCallback onLogout;

  const UserMenuDialog({
    super.key,
    required this.onEditProfile,
    required this.onLogout,
    required this.themeStore,
    required this.authStore,
    required this.feedStore,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(16),
      children: [
        Observer(
          builder: (_) {
            final user = authStore.user;
            if (user == null) return const SizedBox.shrink();

            return Column(
              children: [
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
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text("Editar Perfil"),
                  onTap: () {
                    Navigator.pop(context);
                    _showEditProfileDialog(context, user);
                  },
                ),
                Observer(
                  builder: (_) => SwitchListTile(
                    title: const Text("Modo Escuro"),
                    value: themeStore.isDarkMode,
                    onChanged: (value) async {
                      await themeStore.toggleTheme(value);
                    },
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text("Sair",
                      style: TextStyle(color: Colors.red)),
                  onTap: onLogout,
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  void _showEditProfileDialog(BuildContext context, user) {
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
                    child: const Text("Remover imagem"),
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
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            Observer(
              builder: (_) {
                return TextButton(
                  onPressed: authStore.loading
                      ? null
                      : () async {
                    File? finalImage = removeImage ? null : selectedImage;
                    Uint8List? finalWebImage = removeImage ? null : webImage;

                    await authStore.updateUser(
                      userId: user.id,
                      username: usernameController.text,
                      photo: finalImage,
                      webPhoto: finalWebImage,
                      removePhoto: removeImage,
                    );

                    await feedStore.loadFeed();
                    Navigator.pop(context);
                  },
                  child: authStore.loading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
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