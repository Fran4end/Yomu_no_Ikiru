import 'package:flutter/material.dart';
import 'package:manga_app/costants.dart';
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
      loop: 3,
      child: Card(
        margin: const EdgeInsets.all(defaultPadding / 2),
        elevation: 10,
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
      ),
    );
  }
}

class CardSkelton extends StatelessWidget {
  const CardSkelton({
    this.maxLineText = 1,
    this.iHeight = 180,
    this.iWidth = 140,
    Key? key,
  }) : super(key: key);

  final double maxLineText, iHeight, iWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: iHeight * 1.5,
      width: iWidth * 1.5,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SizedBox(
            height: iHeight * 1.5,
            width: iWidth * 1.5,
            child: Card(
              elevation: 10,
              margin: const EdgeInsets.all(defaultPadding),
              color: backgroundColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          Positioned(
            top: -5,
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Container(
                height: iHeight / 1.2,
                width: iWidth,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Skeleton(
                  color: Colors.white,
                  height: iHeight,
                  width: iWidth,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            child: Center(
              child: Skeleton(
                color: Colors.white,
                width: iWidth,
              ),
            ),
          ),
        ],
      ),
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
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: defaultPadding * 1.5,
              ),
              itemBuilder: (context, index) => const CardSkelton(),
            ));
  }
}
