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
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return Center(
      child: Container(
        width: screen.width / 2,
        height: screen.height / 4.5,
        alignment: Alignment.bottomCenter,
        child: Stack(
          alignment: Alignment.bottomCenter,
          fit: StackFit.expand,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          children: [
            SizedBox(
              height: (screen.height / 2) - 10,
              child: Card(
                elevation: 10,
                margin: const EdgeInsets.all(defaultPadding),
                color: backgroundColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            Positioned(
              top: screen.height - (screen.height * 1.005),
              child: Container(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Skeleton(
                  color: Colors.white,
                  height: screen.height / 6.5,
                  width: screen.width / 3,
                ),
              ),
            ),
            Positioned(
              bottom: (screen.height / 4) - 200,
              child: Skeleton(
                color: Colors.white,
                height: defaultPadding,
                width: (screen.width / 2) - 60,
              ),
            ),
          ],
        ),
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
                mainAxisExtent: 200,
                crossAxisCount: 2,
                childAspectRatio: orientation == Orientation.portrait
                    ? MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 2)
                    : (MediaQuery.of(context).size.width / 2) / MediaQuery.of(context).size.height,
                crossAxisSpacing: defaultPadding * 1.5,
                mainAxisSpacing: orientation == Orientation.portrait ? defaultPadding / 2 : 2,
              ),
              itemBuilder: (context, index) => const CardSkelton(),
            ));
  }
}
