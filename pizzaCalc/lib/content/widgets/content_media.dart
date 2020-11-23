import 'package:flutter/material.dart';
import 'package:pizzaCalc/app/module.dart';

import '../models.dart';

class ContentMediaWidget extends StatelessWidget {
  const ContentMediaWidget(this.contentId, this.media)
      : assert(contentId != null),
        assert(media != null);

  final Id<Content> contentId;
  final ContentMedia media;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: ContentMedia.aspectRatio,
      child: Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
        clipBehavior: Clip.antiAlias,
        child: _buildBackground(),
      ),
    );
  }

  Widget _buildBackground() {
    return media.background.when(
      image: () {
        return FutureBuilder<String>(
          future: MediaBackground.getImageDownloadUrl(contentId),
          builder: (context, snapshot) {
            if (snapshot.hasNoData) {
              return Center(
                child: snapshot.hasError
                    ? Text('Es ist ein Fehler aufgetreten:\n${snapshot.error}')
                    : CircularProgressIndicator(),
              );
            }

            final url = snapshot.data;
            return Image.network(url, fit: BoxFit.cover);
          },
        );
      },
      gradient: (colors) {
        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SizedBox.expand(),
        );
      },
    );
  }
}
