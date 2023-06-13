import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../controller/utils.dart';
import '../widgets/user_info_widget.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<StatefulWidget> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  bool canResent = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerified) {
      sendVerificationEmail();
      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) {
      timer?.cancel();
    }
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      setState(() => canResent = false);
      await Future.delayed(const Duration(seconds: 5));
      setState(() => canResent = true);
    } on FirebaseAuthException catch (e) {
      print(e);
      Utils.showSnackBar(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isEmailVerified
        ? const UserInfoWidget()
        : Scaffold(
            appBar: AppBar(
              title: const Text('Verify Email'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "A verification email has been sent to your mail.\nIf you haven't received it, check your spam",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: defaultPadding),
                  ElevatedButton.icon(
                    onPressed: canResent ? sendVerificationEmail : null,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    icon: const Icon(Icons.email),
                    label: const Text(
                      'Resent Email',
                    ),
                  ),
                  TextButton(
                    onPressed: () => FirebaseAuth.instance.signOut(),
                    child: const Text(
                      'Cancel',
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
