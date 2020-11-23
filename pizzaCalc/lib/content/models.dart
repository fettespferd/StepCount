import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pizzaCalc/app/module.dart';

import 'user/models.dart';

part 'models.freezed.dart';

@freezed
abstract class Content extends Entity implements _$Content {
  const factory Content({
    // This is only `null` before the first upload.
    Instant createdAt,
    @required Id<User> authorId,
    @required ContentMedia media,
    // @required Company company,
    // @required Job job,
  }) = _Content;
  const Content._();

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      createdAt: (json['createdAt'] as Timestamp).asInstant,
      authorId: Id<User>(json['authorId'] as String),
      media: ContentMedia.fromJson(json['media'] as Map<String, dynamic>),
    );
  }

  static final collection = services.firebaseFirestore.collection('contents');

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'createdAt': createdAt?.asTimestamp ?? FieldValue.serverTimestamp(),
      'authorId': authorId.value,
      'media': media.toJson(),
    };
  }
}

@freezed
abstract class ContentMedia implements _$ContentMedia {
  const factory ContentMedia({
    @required MediaBackground background,
    // @Default(<Overlay>[]) List<Overlay> overlays,
  }) = _ContentMedia;
  const ContentMedia._();

  factory ContentMedia.fromJson(Map<String, dynamic> json) {
    return ContentMedia(
      background:
          MediaBackground.fromJson(json['background'] as Map<String, dynamic>),
    );
  }

  static const aspectRatio = 9 / 16;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'background': background.toJson(),
      };
}

@freezed
abstract class MediaBackground implements _$MediaBackground {
  /// The actual image is stored in Firebase Cloud Storage.
  ///
  /// See also: [getImageStorageRef], [getImageDownloadUrl]
  const factory MediaBackground.image() = ImageMediaBackground;

  /// Must contain at least one color.
  const factory MediaBackground.gradient(List<Color> colors) =
      GradientMediaBackground;
  const MediaBackground._();

  factory MediaBackground.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;
    switch (type) {
      case 'image':
        return MediaBackground.image();
      case 'gradient':
        return MediaBackground.gradient(
          (json['colors'] as List<dynamic>)
              .cast<String>()
              .map(_colorFromHexString)
              .toList(),
        );
      default:
        throw FormatException('Unknown MediaBackground type: $type.');
    }
  }

  static final storageBase = services.firebaseStorage.ref().child('content');

  static StorageReference getImageStorageRef(Id<Content> contentId) =>
      storageBase.child(contentId.value).child('background.jpg');
  static Future<String> getImageDownloadUrl(Id<Content> contentId) async =>
      await getImageStorageRef(contentId).getDownloadURL() as String;

  Map<String, dynamic> toJson() {
    return when(
      image: () => <String, dynamic>{'type': 'image'},
      gradient: (colors) => <String, dynamic>{
        'type': 'gradient',
        'colors': colors.map(_colorToHexString).toList(),
      },
    );
  }

  static String _colorToHexString(Color color) {
    String convertChannel(int channel) =>
        channel.toRadixString(16).padLeft(2, '0');

    return '0x${convertChannel(color.red)}'
        '${convertChannel(color.green)}'
        '${convertChannel(color.blue)}';
  }

  static Color _colorFromHexString(String color) =>
      Color(int.parse(color.withoutPrefix('0x').padLeft(8, 'f'), radix: 16));
}

// TODO(JonasWanke): Overlay (text, sticker, etc.)
