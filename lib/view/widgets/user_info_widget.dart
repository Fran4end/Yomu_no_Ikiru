import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../costants.dart';

class UserInfoWidget extends StatelessWidget {
  UserInfoWidget({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          'User',
          style: titleStyle(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(defaultPadding * 2),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Signed In as '),
            const SizedBox(height: defaultPadding / 2),
            Text((user.email!).toString()),
            const SizedBox(height: defaultPadding / 2),
            Text((user.displayName!).toString()),
            const SizedBox(height: defaultPadding * 2),
            ElevatedButton.icon(
              onPressed: () => FirebaseAuth.instance.signOut(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Sign Out'),
            )
          ],
        ),
      ),
    );
  }
}
