import 'package:flutter/material.dart';
import 'package:manga_app/costants.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:manga_app/manga.dart';
import 'package:manga_app/mangaBuilder.dart';
import 'package:manga_app/mangaworld.dart';

class MangaPage extends StatefulWidget {
  MangaPage({
    required this.manga,
    required this.mangaBuilder,
    super.key,
  });
  Manga manga;
  MangaBuilder mangaBuilder;

  @override
  State<StatefulWidget> createState() => _MangaPageState();
}

class _MangaPageState extends State<MangaPage> {
  @override
  void initState() {
    MangaWorld().getAllInfo(widget.mangaBuilder).then((value) {
      widget.mangaBuilder = value;
      widget.manga = widget.mangaBuilder.build();
      if (mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: screen.height,
            width: screen.width,
            color: Colors.black,
          ),
          Hero(
            tag: widget.manga.title.toString(),
            child: Container(
              height: (screen.height / 2) + 70.0,
              width: screen.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: widget.manga.image == null
                      ? Image.asset('assets/blank.jpg').image
                      : NetworkImage(widget.manga.image.toString()),
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
            top: (screen.height / 2) + 70,
            child: Column(
              children: [
                SizedBox(
                  height: (screen.height / 2) - 130,
                  width: screen.width,
                  //TODO: get all chapters
                  child: ListView.builder(
                    //itemCount: , Number of chapters
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 5,
                        color: Colors.grey[900],
                        child: Container(
                          height: 50,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: defaultPadding),
                          child: Text(
                            'Capitolo',
                            style: subtitleStyle(),
                          ),
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
                      Container(
                        height: 30,
                        width: (screen.width / 2) - 120,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          widget.manga.status == null
                              ? 'Status'
                              : widget.manga.status.toString(),
                          style: titleGreenStyle(),
                        ),
                      ),
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
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size((screen.width / 2) - 50, 45),
                          elevation: 10,
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                        ),
                        child: Center(
                          child: Text('Resume', style: titleStyle()),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: (screen.height / 2) - 45,
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
                          Text(
                            widget.manga.title == null
                                ? 'Title'
                                : widget.manga.title.toString(),
                            style: titleStyle(),
                          ),
                          Wrap(
                            direction: Axis.horizontal,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                widget.manga.author == null
                                    ? 'author'
                                    : widget.manga.author.toString(),
                                style: subtitleStyle(),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: defaultPadding / 2),
                                child: CircleAvatar(
                                  radius: 3,
                                  backgroundColor: Colors.black,
                                ),
                              ),
                              Text(
                                widget.manga.artist == null
                                    ? 'artist'
                                    : widget.manga.artist.toString(),
                                style: subtitleStyle(),
                              ),
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
                              Text(
                                widget.manga.vote == null
                                    ? 'vote'
                                    : widget.manga.vote.toString(),
                                style: subtitleStyle(),
                              ),
                              const SizedBox(width: defaultPadding / 2),
                              Text(
                                widget.manga.readings == null
                                    ? '(readings)'
                                    : '(${widget.manga.readings})',
                                style: miniStyle(),
                              )
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
                          //TODO: Mettere i generi
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
