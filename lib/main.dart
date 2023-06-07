import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manga_app/constants.dart';
import 'package:manga_app/model/google_sign_in_provider.dart';
import 'package:manga_app/model/utils.dart';
import 'package:manga_app/view/Pages/home_page.dart';
import 'package:manga_app/view/Pages/library_page.dart';
import 'package:manga_app/view/Pages/user_page.dart';
import 'package:manga_app/view/Pages/search_page.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:rive/rive.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: Utils.messengerKey,
      title: 'Manga!',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectPage = 0;

  late SMIBool homeTrigger;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: Scaffold(
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
              labelTextStyle: MaterialStateProperty.all(
            const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          )),
          child: NavigationBar(
            selectedIndex: _selectPage,
            height: 60,
            animationDuration: const Duration(milliseconds: 400),
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            onDestinationSelected: (value) => setState(() {
              _selectPage = value;
            }),
            destinations: [
              GestureDetector(
                onTap: () {
                  homeTrigger.change(true);
                  Future.delayed(
                    const Duration(seconds: 1),
                    () {
                      homeTrigger.change(false);
                    },
                  );
                },
                child: RiveAnimation.asset(
                  "assets/RiveAssets/icons.riv",
                  artboard: "HOME",
                  onInit: (artboard) {
                    StateMachineController controller = RiveUtils.getRiveController(artboard,
                        stateMachineName: "HOME_interactivity");
                    homeTrigger = controller.findSMI("active") as SMIBool;
                  },
                ),
              ),
              // NavigationDestination(
              //   icon: Icon(Icons.home_outlined),
              //   selectedIcon: Icon(Icons.home),
              //   label: 'Home',
              // ),
              NavigationDestination(
                icon: Icon(CupertinoIcons.compass),
                selectedIcon: Icon(Icons.search_outlined),
                label: 'Search',
              ),
              NavigationDestination(
                icon: Icon(Icons.my_library_books_outlined),
                selectedIcon: Icon(Icons.my_library_books),
                label: 'Library',
              ),
              NavigationDestination(
                icon: Icon(Icons.account_box_outlined),
                selectedIcon: Icon(Icons.account_box),
                label: 'Account',
              ),
            ],
          ),
        ),
        body: IndexedStack(
          index: _selectPage,
          children: const [
            HomePage(),
            SearchPage(),
            LibraryPage(),
            UserPage(),
          ],
        ),
      ),
    );
  }
}
