import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewer extends StatelessWidget {
  const ImageViewer({
    required this.imageProvider,
    required this.downloadHandler,
    required this.shareHandler,
  });

  final ImageProvider<Object> imageProvider;
  final Function() downloadHandler;
  final Function() shareHandler;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: BackButton(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(
              FeatherIcons.download,
              color: Colors.white,
            ),
            onPressed: downloadHandler,
          ),
          IconButton(
            icon: Icon(
              FeatherIcons.share2,
              color: Colors.white,
            ),
            onPressed: shareHandler,
          ),
        ],
      ),
      body: Container(
        child: PhotoView(
          imageProvider: imageProvider,
          initialScale: PhotoViewComputedScale.contained,
          minScale: PhotoViewComputedScale.contained,
          maxScale: 8.0,
          loadingBuilder: (context, event) => Padding(
            padding: EdgeInsets.all(12.0),
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
