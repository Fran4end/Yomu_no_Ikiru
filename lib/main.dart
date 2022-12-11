import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manga_app/Pages/searchPage.dart';
import 'package:manga_app/costants.dart';
import 'package:manga_app/mangaworld.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manga!',
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorScheme: colorScheme,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const MyHomePage(title: 'Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectpage = 1;

  @override
  Widget build(BuildContext context) {
    MangaWorld().getArchive();
    return Scaffold(
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
            //indicatorColor: const Color.fromRGBO(40, 137, 153, 0.60),
            labelTextStyle: MaterialStateProperty.all(
          const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        )),
        child: NavigationBar(
          //backgroundColor: const Color.fromRGBO(114, 192, 204, 0.80),
          selectedIndex: _selectpage,
          height: 60,
          animationDuration: const Duration(milliseconds: 400),
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          onDestinationSelected: (value) => setState(() {
            _selectpage = value;
          }),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
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
          ],
        ),
      ),
      body:
          _getPage(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _getPage() {
    switch (_selectpage) {
      case 0:
        return Center(
          child: Text('A'),
        );
      case 1:
        return const SearchPage();
      default:
        return Center(
          child: Text('A'),
        );
    }
  }
}
