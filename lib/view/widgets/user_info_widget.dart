import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:manga_app/view/widgets/top_buttons.dart';

import '../../constants.dart';

class UserInfoWidget extends StatefulWidget {
  const UserInfoWidget({super.key});

  @override
  State<StatefulWidget> createState() => _UserInfoWidgetState();
}

class _UserInfoWidgetState extends State<UserInfoWidget> {
  final double profileHeight = 144;
  final double coverHeight = 280;
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    final top = coverHeight - (profileHeight / 2);
    final bottom = profileHeight / 2;
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          buildTop(top, bottom, context),
          buildContent(),
        ],
      ),
    );
  }

  Stack buildTop(double top, double bottom, BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(margin: EdgeInsets.only(bottom: bottom), child: buildCoverImage()),
        Positioned(
            top: top / 5,
            child: Container(
              margin: EdgeInsets.only(left: MediaQuery.of(context).size.width - 50),
              child: TopButtonsFunctions(
                ic: const Icon(Icons.logout_rounded),
                function: () => FirebaseAuth.instance.signOut(),
                color: purpleColor,
              ),
            )),
        Positioned(
          top: top,
          child: buildProfileImage(),
        ),
      ],
    );
  }

  Widget buildCoverImage() => Container(
        color: Colors.grey,
        child: Image.asset(
          'assets/icon.png',
          width: double.infinity,
          height: coverHeight,
          fit: BoxFit.cover,
        ),
      );

  Widget buildProfileImage() => CircleAvatar(
        radius: profileHeight / 2,
        backgroundColor: Colors.grey.shade800,
        backgroundImage: user.photoURL != null
            ? Image.network(user.photoURL!).image
            : Image.asset('assets/user.jpg').image,
      );

  Widget buildContent() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding * 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              (user.displayName!).toString(),
              style: titleStyle(fontSize: 26),
            ),
            const SizedBox(height: defaultPadding / 2),
            Text(
              (user.email!).toString(),
              style: subtitleStyle(fontSize: 20),
            ),
          ],
        ),
      );
}
