import 'package:flutter/material.dart';
import 'package:manga_app/constants.dart';
import 'package:shimmer/shimmer.dart';

class Skeleton extends StatelessWidget {
  const Skeleton({
    Key? key,
    this.height,
    this.width,
    required this.color,
  }) : super(key: key);

  final double? height, width;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Center(
        child: Container(
          height: height,
          width: width,
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            color: Colors.transparent,
          ),
          //child: child,
        ),
      ),
    );
  }
}

class CardSkelton extends StatelessWidget {
  const CardSkelton({
    this.maxLineText = 1,
    Key? key,
  }) : super(key: key);

  final double maxLineText;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          elevation: 10,
          margin: const EdgeInsets.all(defaultPadding),
          color: backgroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        Positioned(
          top: -5,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: const Skeleton(
                  color: Colors.white,
                ),
              ),
              const Skeleton(
                color: Colors.white,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SkeletonGrid extends StatelessWidget {
  const SkeletonGrid({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
        builder: (context, orientation) => GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: defaultPadding * 1.5,
              ),
              itemBuilder: (context, index) => const CardSkelton(),
            ));
  }
}
