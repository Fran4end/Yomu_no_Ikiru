import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ReaderPageWidget extends StatelessWidget {
  final Axis axis;
  final bool reverse;
  final PageController? pageController;
  final Function(int) onPageChanged;
  final List<PhotoViewGalleryPageOptions> pages;

  const ReaderPageWidget({
    super.key,
    required this.axis,
    required this.reverse,
    required this.pageController,
    required this.onPageChanged,
    required this.pages,
  });

  @override
  Widget build(BuildContext context) {
    return PhotoViewGallery.builder(
      pageController: pageController,
      scrollDirection: axis,
      reverse: reverse,
      onPageChanged: onPageChanged,
      builder: (context, index) => pages[index],
      itemCount: pages.length,
    );
  }
}
