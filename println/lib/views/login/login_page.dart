import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:println/view_models/auth/auth_store.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

class LoginPage extends StatefulWidget {
  final AuthStore authStore;
  const LoginPage({super.key, required this.authStore});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final AuthStore authStore;
  bool emailChecked = false;
  bool userExists = false;
  File? selectedImage;
  Uint8List? webImage;

  final ImagePicker picker = ImagePicker();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    authStore = widget.authStore;
  }

  Future<void> _checkEmail () async{

    final exists = await authStore.checkEmail(emailController.text);

    setState(() {
      emailChecked=true;
      userExists = exists;
    });

  }

  Future<void> _pickImage() async {

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image == null) return;

    if (kIsWeb) {

      final bytes = await image.readAsBytes();
      setState(() {
        webImage = bytes;
      });

    } else {

      setState(() {
        selectedImage = File(image.path);
      });

    }

  }

  Future<void> _authenticate()async{

    final email = emailController.text;
    final password = passwordController.text;

    if (userExists) {

      await authStore.login(email, password);

    } else {

      await authStore.register(
        email,
        password,
        usernameController.text,
        selectedImage,
        webImage,
      );

    }

    if (authStore.isLogged) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro de autenticação")),
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

            const SizedBox(height: 20),

            if (!emailChecked)
              ElevatedButton(
                onPressed: _checkEmail,
                child: const Text("Continuar"),
              ),

            if (emailChecked) ...[

              if (!userExists) ...[

                if (webImage != null || selectedImage != null)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        webImage = null;
                        selectedImage = null;
                      });
                    },
                    child: const Text("Remover imagem"),
                  ),

                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: kIsWeb
                        ? (webImage != null ? MemoryImage(webImage!) : null)
                        : (selectedImage != null ? FileImage(selectedImage!) : null) as ImageProvider?,
                    child: webImage == null && selectedImage == null
                        ? const Icon(Icons.camera_alt)
                        : null,
                  ),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText: "Username",
                  ),
                ),

              ],

              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: "Senha",
                ),
                obscureText: true,
              ),

              const SizedBox(height: 20),

              Observer(
                builder: (_) => authStore.loading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: _authenticate,
                  child: Text(
                    userExists ? "Entrar" : "Criar Conta",
                  ),
                ),
              ),
            ]

          ],
        ),
      ),
    );
  }
}