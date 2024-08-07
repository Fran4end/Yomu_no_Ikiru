import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ReaderPageWidget extends StatelessWidget {
  final Axis axis;
  final bool reverse;
  final PageController? pageController;
  final Function(int) onPageChanged;
  final List<String> imageUrls;
  final Function(BuildContext, TapUpDetails, PhotoViewControllerValue)? onTapUp;

  const ReaderPageWidget({
    super.key,
    required this.axis,
    required this.reverse,
    required this.pageController,
    required this.onPageChanged,
    required this.imageUrls,
    required this.onTapUp,
  });

  @override
  Widget build(BuildContext context) {
    return PhotoViewGallery.builder(
      pageController: pageController,
      scrollDirection: axis,
      reverse: reverse,
      onPageChanged: onPageChanged,
      builder: (context, index) => PhotoViewGalleryPageOptions(
        imageProvider: CachedNetworkImageProvider(imageUrls[index]),
        minScale: PhotoViewComputedScale.contained,
        tightMode: false,
        onTapUp: onTapUp,
      ),
      itemCount: imageUrls.length,
    );
  }
}
