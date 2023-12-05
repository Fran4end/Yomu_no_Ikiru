import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ReaderPageWidget extends StatelessWidget {
  final Axis axis;
  final bool reverse;
  final PageController? pageController;
  final Function(int) onPageChanged;
  final PhotoViewGalleryPageOptions Function(BuildContext, int) builder;
  final List<PhotoViewGalleryPageOptions> pages;

  const ReaderPageWidget({
    super.key,
    required this.axis,
    required this.reverse,
    required this.pageController,
    required this.onPageChanged,
    required this.pages,
    required,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: ClipRect(
        child: PhotoViewGallery.builder(
          pageController: pageController,
          scrollDirection: axis,
          reverse: reverse,
          onPageChanged: onPageChanged,
          builder: builder,
          itemCount: pages.length,
        ),
      ),
    );
  }
}
