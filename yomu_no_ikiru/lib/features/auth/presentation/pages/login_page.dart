import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yomu_no_ikiru/core/common/widgets/loader.dart';
import 'package:yomu_no_ikiru/core/utils/show_snackbar.dart';
import 'package:yomu_no_ikiru/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:yomu_no_ikiru/features/auth/presentation/pages/sign_up_page.dart';

import '../widgets/field.dart';
import '../widgets/gradient_button.dart';

class LoginPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const LoginPage(),
      );
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/backgrounds/sign_up_background.png"),
              fit: BoxFit.fill),
        ),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthFailure) {
                showSnackBar(context, state.message);
              }
            },
            builder: (context, state) {
              if (state is AuthLoading) {
                return const Loader();
              }
              return Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(flex: 3),
                      const Text(
                        "Welcome back",
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(flex: 2),
                      Field(
                        hintText: "Email",
                        controller: emailController,
                      ),
                      Field(
                        hintText: "Password",
                        controller: passwordController,
                        isObscureText: true,
                      ),
                      const Spacer(flex: 2),
                      GradientButton(
                        "Login",
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(
                                  AuthLogin(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  ),
                                );
                          }
                        },
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          showSnackBar(context, "Not implemented");
                        },
                        child: RichText(
                          text: TextSpan(
                            text: "Forgot password? ",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                          ),
                        ),
                      ),
                      const Spacer(flex: 3),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, SignUpPage.route());
                        },
                        child: RichText(
                          text: TextSpan(
                            text: "Don't have an account? ",
                            style: Theme.of(context).textTheme.titleMedium,
                            children: [
                              TextSpan(
                                text: "Sign up",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color:
                                          Theme.of(context).colorScheme.outline,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
