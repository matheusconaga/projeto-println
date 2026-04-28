import 'dart:io';
import 'dart:typed_data';
import 'package:println/core/ui/app_loading.dart';
import 'package:println/core/ui/app_snack_bar.dart';
import 'package:println/view_models/auth/auth_store.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';
import 'package:println/core/theme/app_colors.dart';
import 'package:println/core/theme/app_spacing.dart';
import 'package:println/core/theme/app_text_styles.dart';
import 'package:println/core/utils/responsive.dart';
import 'package:println/core/validators/validators.dart';
import 'package:println/widgets/app_button.dart';
import 'package:println/widgets/app_link.dart';
import 'package:println/widgets/form_input.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  late AuthStore authStore;
  bool _initialized = false;
  late ReactionDisposer _snackReaction;

  final _formKey = GlobalKey<FormState>();

  bool emailChecked = false;
  bool userExists = false;
  bool checkingEmail = false;
  bool authenticating = false;

  File? selectedImage;
  Uint8List? webImage;

  final ImagePicker picker = ImagePicker();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      authStore = context.read<AuthStore>();
      _resetFormState();
      _initialized = true;
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final store = context.read<AuthStore>();

      _snackReaction = reaction<String?>(
            (_) => store.message,
            (msg) {
          if (msg == null) return;

          switch (store.messageType) {
            case "success":
              AppSnackbar.success(msg);
              break;
            case "error":
              AppSnackbar.error(msg);
              break;
            default:
              AppSnackbar.info(msg);
          }

          store.message = null;
        },
      );
    });
  }


  void _resetFormState() {
    emailChecked = false;
    userExists = false;
    checkingEmail = false;
    authenticating = false;
    selectedImage = null;
    webImage = null;
    usernameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  void _goBackToEmail() {
    setState(() {
      emailChecked = false;
      userExists = false;
      checkingEmail = false;
      authenticating = false;

      passwordController.clear();
      confirmPasswordController.clear();
      usernameController.clear();
      emailController.clear();
      selectedImage = null;
      webImage = null;
    });
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    _snackReaction();
    super.dispose();
  }

  Future<void> _checkEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => checkingEmail = true);

    AppLoading.show(context, message: "Verificando e-mail...");

    try {
      final exists = await authStore.checkEmail(
        emailController.text.trim().toLowerCase(),
      );

      if (!mounted) return;

      setState(() {
        emailChecked = true;
        userExists = exists;
      });

    } catch (e) {
      authStore.setMessage("Erro ao verificar e-mail", "error");
    } finally {
      if (mounted) {
        setState(() => checkingEmail = false);
        AppLoading.hide(context);
      }
    }
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

    final email = emailController.text.trim().toLowerCase();
    final password = passwordController.text.trim();

    setState(() => authenticating = true);

    AppLoading.show(
      context,
      message: userExists ? "Entrando..." : "Criando conta...",
    );

    try {
      if (userExists) {
        await authStore.login(email, password);
      } else {
        await authStore.register(
          email,
          password,
          usernameController.text.trim(),
          selectedImage,
          webImage,
        );
      }

      if (!mounted) return;

      AppLoading.hide(context);

      if (authStore.user != null) {
        await Future.delayed(
          const Duration(milliseconds: 300),
        );

        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home',
              (route) => false,
        );
      } else {
        authStore.setMessage(
          "Erro ao carregar perfil",
          "error",
        );
      }
    } catch (_) {
      if (!mounted) return;

      AppLoading.hide(context);

      authStore.setMessage(
        userExists
            ? "Erro ao fazer login"
            : "Erro ao criar conta",
        "error",
      );
    } finally {
      if (mounted) {
        setState(() => authenticating = false);
      }
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
    final bool isCheckingDone = emailChecked;

    final String title = !isCheckingDone
        ? "Bem-vindo ao PrintLn"
        : userExists
        ? "Bem-vindo de volta!"
        : "Criar nova conta!";

    final String subtitle = !isCheckingDone
        ? "Entrar ou Cadastrar-se"
        : userExists
        ? "Digite sua senha para continuar"
        : "Complete seu cadastro";

    final String description = !isCheckingDone
        ? "Rede social para postar fotos, textos, curtir e interagir. Insira seu e-mail para continuar para login ou cadastro."
        : userExists
        ? "Que bom te ver novamente!"
        : "Preencha os dados abaixo para criar sua conta.";


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
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: isDark ? DarkColors.background : LightColors.background,
                    child: Image.asset("assets/logo.png"),
                  ),
                  SizedBox(height: AppSpacing.lg),

                  Text(
                    title,
                    style: AppTextStyles.heading1.copyWith(
                      color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
                    ),
                  ),

                  SizedBox(height: AppSpacing.xs),

                  Text(
                    subtitle,
                    style: AppTextStyles.heading2.copyWith(
                      color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
                    ),
                  ),

                  SizedBox(height: AppSpacing.lg),

                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body2.copyWith(
                      color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
                    ),
                  ),

                  SizedBox(height: AppSpacing.xl),

                  if(emailChecked)...[
                    Align(
                      alignment: Alignment.topLeft,
                      child: TextButton.icon(
                        onPressed: _goBackToEmail,
                        icon: const Icon(Icons.arrow_back),
                        label: const Text("Trocar e-mail"),
                      ),
                    ),
                  ],

                  FormInput(
                    controller: emailController,
                    hint: "Digite seu email",
                    title: "Email",
                    validator: Validators.validarEmail,
                    onChanged: (value) {
                      if (emailChecked) {
                        setState(() {
                          emailChecked = false;
                          userExists = false;
                          passwordController.clear();
                          confirmPasswordController.clear();
                          usernameController.clear();
                          selectedImage = null;
                          webImage = null;
                        });
                      }
                    },
                  ),

                  SizedBox(height: AppSpacing.lg),

                  if (!emailChecked)

                    AppButton(
                      title: checkingEmail ? "Verificando..." : "Continuar",
                      onPressed: checkingEmail ? null : () {
                        _checkEmail();
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
                              : (selectedImage != null
                              ? FileImage(selectedImage!)
                              : null)
                          as ImageProvider?,
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
                      SizedBox(height: AppSpacing.xs),

                      Align(
                        alignment: Alignment.centerRight,
                        child: AppLink(
                          title: "Recuperar senha?",
                          func: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Atenção"),
                                  content: const Text("Funcionalidade ainda não implementada."),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: const Text("OK"),
                                    ),
                                  ],
                                );
                              },
                            );
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

                    AppButton(
                      title: authenticating
                          ? (userExists ? "Entrando..." : "Criando conta...")
                          : (userExists ? "Entrar" : "Criar conta"),
                      onPressed: authenticating ? null : _authenticate,
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