import 'package:firebase_core/firebase_core.dart';
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
      home: const NavigationBarWidget(),
    );
  }
}

class NavigationBarWidget extends StatefulWidget {
  const NavigationBarWidget({super.key});

  @override
  State<NavigationBarWidget> createState() => _NavigationBarWidgetState();
}

class _NavigationBarWidgetState extends State<NavigationBarWidget> {
  int _selectPage = 0;

  RiveAsset selectedButton = bottomNavigators.first;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: Scaffold(
        bottomNavigationBar: SafeArea(
          child: NavigationBarTheme(
            data: NavigationBarThemeData(
                labelTextStyle: MaterialStateProperty.all(
              const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            )),
            child: NavigationBar(
              selectedIndex: _selectPage,
              height: 60,
              animationDuration: const Duration(milliseconds: 400),
              labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
              onDestinationSelected: (value) {
                bottomNavigators[value].input!.change(true);
                Future.delayed(
                  const Duration(seconds: 1),
                  () {
                    bottomNavigators[value].input!.change(false);
                  },
                );
                setState(() {
                  selectedButton = bottomNavigators[value];
                  _selectPage = value;
                });
              },
              destinations: [
                ...List.generate(
                  bottomNavigators.length,
                  (index) => NavigationDestination(
                    icon: SizedBox(
                      height: 36,
                      width: 36,
                      child: Opacity(
                        opacity: bottomNavigators[index] == selectedButton ? 1 : .5,
                        child: RiveAnimation.asset(
                          bottomNavigators.first.src,
                          artboard: bottomNavigators[index].artboard,
                          onInit: (artboard) {
                            StateMachineController controller = Utils.getRiveController(artboard,
                                stateMachineName: bottomNavigators[index].stateMachineName);
                            bottomNavigators[index].input = controller.findSMI("active");
                          },
                        ),
                      ),
                    ),
                    label: bottomNavigators[index].title,
                  ),
                ),
              ],
            ),
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
