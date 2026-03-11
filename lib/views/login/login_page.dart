import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:println/view_models/auth/auth_store.dart';

class LoginPage extends StatefulWidget {
  final AuthStore authStore;
  const LoginPage({super.key, required this.authStore});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final AuthStore authStore;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    authStore = widget.authStore;
  }

  void _login() async {
    await authStore.login(emailController.text, passwordController.text);
    if (authStore.isLogged) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Falha ao logar!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: "Senha"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            Observer(
              builder: (_) => authStore.loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _login,
                child: const Text("Login"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}