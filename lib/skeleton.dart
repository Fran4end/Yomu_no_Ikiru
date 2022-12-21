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
      child: OrientationBuilder(
        builder: (context, orientation) {
          return Container(
            width: orientation == Orientation.portrait ? screen.width / 2 : screen.width / 2,
            height: orientation == Orientation.portrait ? screen.height / 4.5 : screen.height / 2,
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
                      height: orientation == Orientation.portrait
                          ? screen.height / 6.5
                          : screen.height / 3,
                      width: orientation == Orientation.portrait
                          ? screen.width / 3
                          : screen.width / 6.1,
                    ),
                  ),
                ),
                Positioned(
                  bottom: orientation == Orientation.portrait
                      ? (screen.height / 4) - 200
                      : (screen.height / 3) - 120,
                  child: Skeleton(
                    color: Colors.white,
                    height: defaultPadding,
                    width: orientation == Orientation.portrait
                        ? (screen.width / 2) - 60
                        : (screen.width / 4) - 60,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
