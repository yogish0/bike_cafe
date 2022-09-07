import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';

class GalleryWidget extends StatefulWidget {
  const GalleryWidget({Key? key, required this.urlImages}) : super(key: key);

  final List<dynamic> urlImages;

  @override
  State<GalleryWidget> createState() => _GalleryWidgetState();
}

class _GalleryWidgetState extends State<GalleryWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PhotoViewGallery.builder(
        itemCount: widget.urlImages.length,
        builder: (context, index) {
          final urlImage = widget.urlImages[index];
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(urlImage!),
          );
        },
      ),
    );
  }
}

class GalleryWidget2 extends StatefulWidget {
  GalleryWidget2({Key? key, required this.urlImages,this.index = 0}) : pageController = PageController(initialPage: index);

  final PageController pageController;
  final List<dynamic> urlImages;
  final int index;

  @override
  State<GalleryWidget2> createState() => _GalleryWidget2State();
}

class _GalleryWidget2State extends State<GalleryWidget2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PhotoViewGallery.builder(
        pageController: widget.pageController,
        itemCount: widget.urlImages.length,
        builder: (context, index) {
          final urlImage = widget.urlImages[index];
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(urlImage!),
          );
        },
      ),
    );
  }
}
