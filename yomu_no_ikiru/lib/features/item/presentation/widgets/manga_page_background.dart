import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:yomu_no_ikiru/core/common/widgets/skeleton.dart';
import 'package:yomu_no_ikiru/core/common/entities/manga/manga.dart';

/// Widget that displays the background of the manga page.
///
/// This widget is a [ShaderMask] that displays a gradient on top of the manga's cover image.
/// The gradient is used to make the manga's title and author more readable.
/// The cover image is fetched from the internet using the [CachedNetworkImage] widget.
class MangaPageBackground extends StatelessWidget {
  const MangaPageBackground({
    super.key,
    required this.manga,
  });

  final Manga manga;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (rect) {
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black54, Colors.transparent],
        ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
      },
      blendMode: BlendMode.dstIn,
      child: CachedNetworkImage(
        imageUrl: manga.coverUrl,
        fit: BoxFit.cover,
        alignment: Alignment.center,
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            const Center(child: Skeleton(color: Colors.white)),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }
}
