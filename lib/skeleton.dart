import 'package:flutter/material.dart';
import 'package:manga_app/costants.dart';
import 'package:shimmer/shimmer.dart';

class Skeleton extends StatelessWidget {
  const Skeleton({
    Key? key,
    this.height,
    this.width,
    //this.child = const Text(''),
  }) : super(key: key);

  final double? height, width;
  //final Widget child;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[100]!,
      highlightColor: Colors.grey[400]!,
      child: Container(
        height: height,
        width: width,
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        //child: child,
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
    return Container(
      width: screen.width / 2,
      height: screen.height / 4.5,
      alignment: Alignment.bottomCenter,
      child: Stack(
        alignment: Alignment.bottomCenter,
        fit: StackFit.expand,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        children: [
          Card(
            elevation: 10,
            color: ThemeData.dark().primaryColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: const Skeleton(),
          ),
          Positioned(
            bottom: screen.height / 15.5,
            child: Card(
              elevation: 10,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Skeleton(
                  height: screen.height / 6.5,
                  width: screen.width / 3,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: screen.height / 60,
            child: Card(
              elevation: 10,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: Skeleton(
                  height: defaultPadding,
                  width: screen.width / 3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
