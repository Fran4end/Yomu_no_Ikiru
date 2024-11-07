import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:yomu_no_ikiru/core/common/widgets/skeleton.dart';
import 'package:yomu_no_ikiru/features/manga/common/domain/entities/manga.dart';

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
