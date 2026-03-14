import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:println/view_models/auth/auth_store.dart';
import 'package:println/view_models/theme/theme_store.dart';

class UserMenuDialog extends StatelessWidget {
  final VoidCallback onEditProfile;
  final VoidCallback onLogout;
  final ThemeStore themeStore;
  final AuthStore authStore;

  const UserMenuDialog({
    super.key,
    required this.onEditProfile,
    required this.onLogout,
    required this.themeStore,
    required this.authStore,
  });



  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text("Perfil"),
      children: [
        ListTile(
          leading: const Icon(Icons.edit),
          title: const Text("Editar Perfil"),
          onTap: onEditProfile,
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
          title: const Text("Sair", style: TextStyle(color: Colors.red)),
          onTap: () async {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Confirmar Logout"),
                content: const Text("Tem certeza que deseja sair?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text("Cancelar"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text("Sair"),
                  ),
                ],
              ),
            );

            if (confirmed == true) {
              await authStore.logout();

              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                    (route) => false,
              );
            }
          },
        ),
      ],
    );
  }
}