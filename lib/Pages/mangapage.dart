import 'package:flutter/material.dart';
import 'package:manga_app/costants.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';

class MangaPage extends StatefulWidget {
  const MangaPage({
    required this.title,
    required this.link,
    super.key,
  });
  final String title, link;

  @override
  State<StatefulWidget> createState() => _MangaPageState();
}

class _MangaPageState extends State<MangaPage> {
  late final Size screen;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screen = MediaQuery.of(context).size;
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0.0,
      //   centerTitle: true,
      //   titleTextStyle: titleGreenStyle(),
      //   title: Text(widget.title),
      // ),
      body: Stack(
        children: [
          Container(
            height: screen.height,
            width: screen.width,
            color: Colors.black,
          ),
          Hero(
            tag: widget.title,
            child: Container(
              height: (screen.height / 2) + 70.0,
              width: screen.width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  // TODO: take image from manga
                  image: NetworkImage(
                      'https://cdn.mangaworld.so/mangas/5fa455670febb5685c5ce6e5.png?1671393423505'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            top: 35.0,
            left: 10.0,
            child: Container(
              color: Colors.transparent,
              height: 50.0,
              width: screen.width - 20.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  TopButtonsFunctions(
                      ic: Icon(Icons.arrow_back_ios_new_rounded)),
                  TopButtonsFunctions(ic: Icon(Icons.favorite_rounded)),
                ],
              ),
            ),
          ),
          Positioned(
            top: (screen.height / 2) + 90,
            child: Column(
              children: [
                SizedBox(
                  height: (screen.height / 2) - 150,
                  width: screen.width,
                  //TODO: get all chapters
                  child: ListView.builder(
                    //itemCount: , Number of chapters
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 5,
                        color: Colors.grey[900],
                        child: Text(
                          'Capitolo',
                          style: subtitleStyle(),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: screen.width - 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('bookmark', style: miniStyle()),
                            Text(
                              'cap ragg',
                              style: subtitleStyle(),
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 50.0,
                          width: (screen.width / 2) - 50,
                          decoration: BoxDecoration(
                              color: secondaryColor,
                              borderRadius: BorderRadius.circular(20.0)),
                          child: Center(
                            child: Text('Resume', style: titleStyle()),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: (screen.height / 2) - 30,
            child: GlassContainer(
              height: 150,
              width: screen.width,
              blur: 4,
              border: const Border.fromBorderSide(BorderSide.none),
              borderRadius: BorderRadius.circular(30),
              color: Colors.black.withOpacity(0.6),
              child: SizedBox(
                height: 140,
                width: screen.width - 20,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: defaultPadding),
                      height: 140,
                      width: (screen.width - 20) / 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Titolo', style: titleStyle()),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('auture', style: subtitleStyle()),
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: defaultPadding),
                                child: CircleAvatar(
                                  radius: 3,
                                  backgroundColor: Colors.black,
                                ),
                              ),
                              Text('artista', style: subtitleStyle()),
                            ],
                          ),
                          const SizedBox(height: defaultPadding),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.orange,
                                size: 22.0,
                              ),
                              const SizedBox(width: defaultPadding / 2),
                              Text('voto', style: subtitleStyle()),
                              const SizedBox(width: defaultPadding / 2),
                              Text('(N)', style: miniStyle())
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: defaultPadding / 2),
                      height: 140,
                      width: (screen.width - 20) / 2,
                      child: Column(
                          //TODO: Mettere il generi
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TopButtonsFunctions extends StatelessWidget {
  const TopButtonsFunctions({
    Key? key,
    required this.ic,
  }) : super(key: key);

  final Icon ic;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
          color: primaryColor,
          border: Border.all(
            color: primaryColor,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(
          ic.icon,
          color: secondaryColor,
          size: 17,
        ),
      ),
    );
  }
}
