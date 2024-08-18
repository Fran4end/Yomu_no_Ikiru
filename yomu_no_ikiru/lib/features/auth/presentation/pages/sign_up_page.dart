import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yomu_no_ikiru/core/common/widgets/loader.dart';
import 'package:yomu_no_ikiru/core/utils/show_snackbar.dart';
import 'package:yomu_no_ikiru/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:yomu_no_ikiru/features/auth/presentation/pages/login_page.dart';
import 'package:yomu_no_ikiru/features/auth/presentation/widgets/field.dart';
import 'package:yomu_no_ikiru/features/auth/presentation/widgets/gradient_button.dart';

class SignUpPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const SignUpPage(),
      );
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/backgrounds/sign_up_background.png"),
            fit: BoxFit.fill,
          ),
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
                        "Create Account",
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(flex: 2),
                      //TODO: implement avatar upload

                      // Container(
                      //   height: 50,
                      //   width: 50,
                      //   decoration: BoxDecoration(
                      //     image: DecorationImage(
                      //       image: AssetImage("assets/backgrounds/sign_up_background.png"),
                      //       fit: BoxFit.fill,
                      //     ),
                      //   ),
                      // ),
                      // Spacer(flex: 1),

                      Field(
                        hintText: "Username",
                        controller: usernameController,
                      ),
                      Field(
                        hintText: "Email",
                        controller: emailController,
                      ),
                      Field(
                        hintText: "Password",
                        controller: passwordController,
                        isObscureText: true,
                      ),
                      const Spacer(flex: 1),
                      GradientButton(
                        "Sign Up",
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(
                                  AuthSignUp(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                    username: usernameController.text.trim(),
                                    avatarUrl: '',
                                  ),
                                );
                          }
                        },
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, LoginPage.route());
                        },
                        child: RichText(
                          text: TextSpan(
                            text: "Already have an account? ",
                            style: Theme.of(context).textTheme.titleMedium,
                            children: [
                              TextSpan(
                                text: "Sign in",
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: Theme.of(context).colorScheme.outline,
                                    ),
                                onEnter: (event) {},
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
