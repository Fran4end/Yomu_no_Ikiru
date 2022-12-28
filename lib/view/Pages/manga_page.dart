import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:manga_app/costants.dart';
import 'package:manga_app/model/manga.dart';
import 'package:manga_app/model/manga_builder.dart';
import 'package:manga_app/mangaworld.dart';
import 'package:manga_app/view/Pages/reader_page.dart';
import '../../model/utils.dart';

class MangaPage extends StatefulWidget {
  MangaPage({
    required this.mangaBuilder,
    super.key,
  });
  MangaBuilder mangaBuilder;

  @override
  State<StatefulWidget> createState() => _MangaPageState();
}

class _MangaPageState extends State<MangaPage> {
  late Image mangaImage;
  late Manga manga;
  Widget genres = const Center();
  Map fileContent = {};
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    manga = widget.mangaBuilder.build();
    mangaImage = Image.network(manga.image.toString());
    MangaWorld().getAllInfo(widget.mangaBuilder).then((value) {
      widget.mangaBuilder = value;
      manga = widget.mangaBuilder.build();
      genres = GenresWrap(manga: manga);
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    Utils().writeFile(manga.title!, user).then((file) => Utils().uploadJson(file, user));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) => CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              delegate: CustomSliverAppBarDelegate(
                manga: manga,
                mangaImage: mangaImage,
                screen: screen,
                expandedHeight: (screen.height / 2) + 55,
                genres: genres,
              ),
              pinned: true,
            ),
            buildChapters(),
          ],
        ),
      ),
    );
  }

  Widget buildChapters() => SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return manga.chapters.isEmpty
                ? null
                : Card(
                    elevation: 5,
                    color: Colors.grey[900],
                    child: ListTile(
                      title: Text(
                        manga.chapters[index].title,
                        style: subtitleStyle(),
                      ),
                      subtitle: Text(
                        manga.chapters[index].date.toString(),
                        style: miniStyle(),
                      ),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Reader(
                            index: index,
                            chapters: manga.chapters,
                            chapter: manga.chapters[index],
                            pageIndex: manga.pageIndex, //TODO Implement bookmark
                          ),
                        ),
                      ),
                    ),
                  );
          },
          childCount: manga.chapters.length,
        ),
      );
}

class CustomSliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final Manga manga;
  final Image mangaImage;
  final Size screen;
  final double expandedHeight;
  final Widget genres;
  CustomSliverAppBarDelegate({
    required this.manga,
    required this.mangaImage,
    required this.screen,
    required this.expandedHeight,
    required this.genres,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    const size = 140;
    final top = expandedHeight - shrinkOffset - ((size / 2) + 60);
    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: [
        buildBackground(shrinkOffset, screen, mangaImage),
        builAppBar(shrinkOffset, context),
        Positioned(
          top: top,
          child: buildDetail(screen, shrinkOffset),
        ),
      ],
    );
  }

  Widget buildDetail(Size screen, double shrinkOffset) {
    return Opacity(
      opacity: disappear(shrinkOffset),
      child: SizedBox(
        height: 140,
        width: screen.width - 20,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            genres,
            Container(
              padding: const EdgeInsets.all(defaultPadding),
              width: (screen.width - 20) / 2,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.orange,
                        size: 22.0,
                      ),
                      const SizedBox(width: defaultPadding / 2),
                      Text(
                        manga.vote == null ? '0' : manga.vote.toString(),
                        style: subtitleStyle(),
                      ),
                      const SizedBox(width: defaultPadding / 2),
                      Text(
                        manga.readings == null ? '(0)' : '(${manga.readings})',
                        style: miniStyle(),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget builAppBar(double shrinkOffset, BuildContext context) => Opacity(
        opacity: 0.8,
        child: AppBar(
          centerTitle: true,
          titleTextStyle: titleStyle(),
          leading: const Padding(
            padding: EdgeInsets.all(defaultPadding / 2),
            child: TopButtonsFunctions(ic: Icon(Icons.arrow_back_ios_new_rounded)),
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.all(defaultPadding / 2),
              child: TopButtonsFunctions(ic: Icon(Icons.favorite_rounded)),
            ),
            SizedBox(
              width: defaultPadding / 2,
            ),
          ],
          title: FittedBox(
            fit: BoxFit.contain,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      manga.title == null ? 'Title' : manga.title.toString(),
                      style: titleStyle(),
                      textAlign: TextAlign.center,
                    ),
                    Wrap(
                      direction: Axis.horizontal,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          manga.author == null ? 'author' : manga.author.toString(),
                          style: subtitleStyle(),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
                          child: CircleAvatar(
                            radius: 3,
                            backgroundColor: Colors.black,
                          ),
                        ),
                        Text(
                          manga.artist == null ? 'artist' : manga.artist.toString(),
                          style: subtitleStyle(),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  Widget buildBackground(double shrinkOffset, Size screen, Image image) => Hero(
        tag: manga.title.toString(),
        child: Container(
          width: screen.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: image.image,
              fit: BoxFit.cover,
            ),
          ),
        ),
      );

  double disappear(double shrinkOffset) => 1 - shrinkOffset / expandedHeight;

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight + 30;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}

class GenresWrap extends StatelessWidget {
  const GenresWrap({
    Key? key,
    required this.manga,
  }) : super(key: key);

  final Manga manga;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
      child: Wrap(
        alignment: WrapAlignment.center,
        direction: Axis.horizontal,
        children: manga.genres.map((e) {
          return Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(defaultPadding / 2),
                child: Text(e),
              ));
        }).toList(),
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
