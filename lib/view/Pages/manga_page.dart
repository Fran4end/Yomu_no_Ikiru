import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:manga_app/costants.dart';
import 'package:manga_app/model/manga.dart';
import 'package:manga_app/model/manga_builder.dart';
import 'package:manga_app/mangaworld.dart';
import 'package:manga_app/view/Pages/reader_page.dart';
import '../../model/file_manag.dart';
import '../../model/utils.dart';

class MangaPage extends StatefulWidget {
  const MangaPage({
    required this.mangaBuilder,
    required this.save,
    super.key,
  });
  final MangaBuilder mangaBuilder;
  final bool save;

  @override
  State<StatefulWidget> createState() => _MangaPageState();
}

class _MangaPageState extends State<MangaPage> {
  late Image mangaImage;
  late Manga manga;
  late MangaBuilder mangaBuilder = widget.mangaBuilder;
  Widget genres = const Center();
  Map fileContent = {};
  final User? user = FirebaseAuth.instance.currentUser;
  late bool save = widget.save;

  @override
  void initState() {
    super.initState();
    manga = mangaBuilder.build();
    mangaImage = Image.network(manga.image.toString());
    MangaWorld().getAllInfo(mangaBuilder).then((value) {
      mangaBuilder = value;
      manga = mangaBuilder.build();
      genres = GenresWrap(manga: manga);
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    if (save) {
      FileManag.writeFile(manga.title!).then((file) => Utils.uploadJson(file, manga.title!));
    } else {
      FileManag.deleteFile(manga.title!);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) => Stack(
          fit: StackFit.expand,
          children: [
            CustomScrollView(
              slivers: [
                SliverPersistentHeader(
                  delegate: CustomSliverAppBarDelegate(
                    manga: manga,
                    mangaImage: mangaImage,
                    screen: screen,
                    expandedHeight: (screen.height / 2) + 55,
                    genres: genres,
                    save: save,
                    function: () {
                      if (user != null) {
                        setState(() => save = !save);
                      } else {
                        Utils.showSnackBar('You need to login before save a manga');
                      }
                    },
                  ),
                  pinned: true,
                ),
                buildChapters(),
              ],
            ),
            Positioned(
              bottom: 30,
              child: buildBottomBar(screen, manga),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBottomBar(Size screen, Manga manga) {
    return SizedBox(
      width: screen.width - 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding * 2),
            child: Container(
              height: 30,
              width: 100,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                manga.status == null ? 'Status' : manga.status.toString(),
                style: titleGreenStyle(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (manga.chapters.isNotEmpty) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Reader(
                      index: (manga.chapters.length - manga.index) - 1,
                      chapters: manga.chapters,
                      chapter: manga.chapters[(manga.chapters.length - manga.index) - 1],
                      pageIndex: manga.pageIndex,
                    ),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              fixedSize: Size((screen.width / 2) - 50, 45),
              elevation: 10,
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            ),
            child: Center(
              child: Text('Resume', style: titleStyle()),
            ),
          ),
        ],
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
                      onTap: () {
                        int pIndex = 0;
                        if (manga.index == index) pIndex = manga.pageIndex;
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Reader(
                              index: index,
                              chapters: manga.chapters,
                              chapter: manga.chapters[index],
                              pageIndex: pIndex,
                            ),
                          ),
                        );
                      },
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
  final bool save;
  final Function()? function;
  CustomSliverAppBarDelegate({
    required this.manga,
    required this.mangaImage,
    required this.screen,
    required this.expandedHeight,
    required this.genres,
    required this.save,
    required this.function,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    const double size = 130;
    final top = expandedHeight - shrinkOffset - size;
    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: [
        buildBackground(shrinkOffset, screen, mangaImage),
        builAppBar(shrinkOffset, context, function),
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

  Widget builAppBar(double shrinkOffset, BuildContext context, Function()? function) => Opacity(
        opacity: 0.8,
        child: AppBar(
          centerTitle: true,
          titleTextStyle: titleStyle(),
          leading: Padding(
            padding: const EdgeInsets.all(defaultPadding / 2),
            child: TopButtonsFunctions(
              ic: const Icon(Icons.arrow_back_ios_new_rounded),
              function: () => Navigator.of(context).pop(),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(defaultPadding / 2),
              child: TopButtonsFunctions(
                ic: save
                    ? const Icon(Icons.favorite_rounded)
                    : const Icon(Icons.favorite_outline_rounded),
                function: function,
              ),
            ),
            const SizedBox(
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
    required this.function,
  }) : super(key: key);

  final Icon ic;
  final Function()? function;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
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
