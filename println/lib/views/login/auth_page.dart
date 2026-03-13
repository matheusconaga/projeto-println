import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:println/core/theme/app_colors.dart';
import 'package:println/core/theme/app_text_styles.dart';
import 'package:println/core/theme/app_spacing.dart';
import 'package:println/core/utils/responsive.dart';
import 'package:println/core/validators/validators.dart';
import 'package:println/widgets/app_button.dart';
import 'package:println/widgets/app_link.dart';
import 'package:println/widgets/form_input.dart';
import '../../view_models/auth/auth_store.dart';

class AuthPage extends StatefulWidget {
  final AuthStore authStore;
  const AuthPage({super.key, required this.authStore});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late final AuthStore authStore;
  final _formKey = GlobalKey<FormState>();

  bool emailChecked = false;
  bool userExists = false;
  File? selectedImage;
  Uint8List? webImage;

  final ImagePicker picker = ImagePicker();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    authStore = widget.authStore;
  }

  Future<void> _checkEmail() async {
    final exists = await authStore.checkEmail(emailController.text);
    setState(() {
      emailChecked = true;
      userExists = exists;
    });
  }

  Future<void> _pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    if (kIsWeb) {
      final bytes = await image.readAsBytes();
      setState(() => webImage = bytes);
    } else {
      setState(() => selectedImage = File(image.path));
    }
  }

  Future<void> _authenticate() async {
    if (!_formKey.currentState!.validate()) return;

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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final double maxWidth = 500;
    final double width = Responsive.isMobile(context)
        ? Responsive.width(context) * 0.8
        : maxWidth;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: width),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  // Logo redonda
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: isDark ? DarkColors.background : LightColors.background,
                    child: Image.asset("assets/logo.png")
                  ),

                  SizedBox(height: AppSpacing.lg),

                  Text(
                    "Bem-vindo ao PrintLn",
                    style: AppTextStyles.heading1.copyWith(
                      color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    "Entrar ou Cadastrar-se",
                    style: AppTextStyles.heading2.copyWith(
                      color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
                    ),
                  ),

                  SizedBox(height: AppSpacing.lg),

                  Text(
                    "Rede social para postar fotos, textos, curtir e interagir. Insira seu e-mail para continuar para login ou cadastro.",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body2.copyWith(
                      color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
                    ),
                  ),

                  SizedBox(height: AppSpacing.xl),

                  FormInput(
                    controller: emailController,
                    hint: "Digite seu email",
                    title: "Email",
                    validator: Validators.validarEmail,
                  ),

                  SizedBox(height: AppSpacing.lg),

                  if (!emailChecked)
                    AppButton(
                      title: "Continuar",
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _checkEmail();
                        }
                      },
                    ),

                  if (emailChecked) ...[
                    SizedBox(height: AppSpacing.lg),

                    if (!userExists) ...[
                      GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage: kIsWeb
                              ? (webImage != null ? MemoryImage(webImage!) : null)
                              : (selectedImage != null ? FileImage(selectedImage!) : null) as ImageProvider?,
                          child: webImage == null && selectedImage == null
                              ? const Icon(Icons.camera_alt, size: 32)
                              : null,
                        ),
                      ),

                      if (webImage != null || selectedImage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.sm),
                          child: AppLink(
                            title: "Remover imagem",
                            func: () {
                              setState(() {
                                selectedImage = null;
                                webImage = null;
                              });
                            },
                          ),
                        ),

                      SizedBox(height: AppSpacing.lg),

                      FormInput(
                        controller: usernameController,
                        hint: "Escolha um username",
                        title: "Username",
                        validator: Validators.validarUsername,
                      ),

                      SizedBox(height: AppSpacing.lg),

                      FormInput(
                        controller: passwordController,
                        hint: "Digite sua senha",
                        title: "Senha",
                        obscure: true,
                        validator: Validators.validarSenha,
                      ),

                      SizedBox(height: AppSpacing.lg),

                      FormInput(
                        controller: confirmPasswordController,
                        hint: "Confirme sua senha",
                        title: "Confirmar Senha",
                        obscure: true,
                        validator: (value) => Validators.validarConfirmacaoSenha(
                          passwordController.text,
                          value,
                        ),
                      ),
                    ] else ...[
                      SizedBox(height: AppSpacing.lg),

                      Align(
                        alignment: Alignment.centerRight,
                        child: AppLink(
                          title: "Recuperar senha?",
                          func: () {
                            print("Funcionalidade ainda não implementada");
                          },
                        ),
                      ),

                      SizedBox(height: AppSpacing.md),

                      FormInput(
                        controller: passwordController,
                        hint: "Digite sua senha",
                        title: "Senha",
                        obscure: true,
                        validator: Validators.validarSenha,
                      ),
                    ],

                    SizedBox(height: AppSpacing.xl),

                    Observer(
                      builder: (_) => authStore.loading
                          ? const CircularProgressIndicator()
                          : AppButton(
                        title: userExists ? "Entrar" : "Cadastrar-se",
                        onPressed: _authenticate,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}