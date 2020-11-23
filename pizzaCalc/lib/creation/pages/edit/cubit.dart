import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image/image.dart' as img;
import 'package:pizzaCalc/app/module.dart';
import 'package:pizzaCalc/auth/module.dart';
import 'package:pizzaCalc/content/module.dart';

part 'cubit.freezed.dart';

class EditCubit extends Cubit<EditState> {
  factory EditCubit(String backgroundType, String picturePath) {
    assert(backgroundType != null);
    switch (backgroundType) {
      case 'image':
        return EditCubit._(Background.image(File(picturePath)));
      case 'gradient':
        return EditCubit._(Background.gradient());
      default:
        throw ArgumentError('Invalid background type: `$backgroundType`.');
    }
  }
  EditCubit._(this.background)
      : assert(background != null),
        super(EditState.initial());

  final Background background;

  bool get canPost => !_isPosting;
  bool _isPosting = false;
  bool get isPosting => _isPosting;
  double _postingProgress;
  double get postingProgress => _postingProgress;
  Future<bool> post() async {
    if (!canPost) return false;
    _isPosting = true;
    emit(EditState.posting());

    final contentRef = Content.collection.doc();
    final id = Id<Content>(contentRef.id);

    final backgroundUploadSuccess = await background.when(
      image: (file) => _uploadImage(id, file),
      gradient: (_) => Future<bool>.value(true),
    );
    if (!backgroundUploadSuccess) return false;

    await contentRef.set(_createContent().toJson());

    // We intentionally don't clear `isPosting` to avoid flickering when
    // navigating away.
    return true;
  }

  Future<bool> _uploadImage(Id<Content> contentId, File file) async {
    final task = MediaBackground.getImageStorageRef(contentId).putData(
      await _prepareImage(file),
      StorageMetadata(contentType: 'image/jpeg'),
    );
    task.events.listen((event) {
      final transferred = event.snapshot.bytesTransferred;
      final total = event.snapshot.totalByteCount;
      if (transferred != null && transferred > 0 && total != null) {
        emit(EditState.posting(_postingProgress = transferred / total));
      }
    });

    final result = await task.onComplete;
    if (result.error != null) {
      logger.w(
        'Firebase Storage error while uploading post image: ${result.error}.',
      );
      _isPosting = false;
      _postingProgress = null;
      emit(EditState.unknownError());
      return false;
    }

    try {
      // Try to delete the temporary folder that got generated.
      await file.parent.delete(recursive: true);
    } catch (_) {}

    return true;
  }

  Future<Uint8List> _prepareImage(File file) async {
    var image = img.decodeJpg(await file.readAsBytes());

    var width = image.width;
    var height = width ~/ ContentMedia.aspectRatio;
    if (height > image.height) {
      height = image.height;
      width = (height * ContentMedia.aspectRatio).toInt();
    }
    assert(width <= image.width);
    assert(height <= image.height);
    image = img.copyCrop(
      image,
      (image.width - width) ~/ 2,
      (image.height - height) ~/ 2,
      width,
      height,
    );

    return Uint8List.fromList(img.encodeJpg(image));
  }

  Content _createContent() {
    return Content(
      authorId: services.auth.userId,
      media: ContentMedia(
        background: background.when(
          image: (_) => MediaBackground.image(),
          gradient: (colors) => MediaBackground.gradient(colors),
        ),
      ),
    );
  }
}

@freezed
abstract class EditState with _$EditState {
  const factory EditState.initial() = _InitialState;
  const factory EditState.posting([double progress]) = _PostingState;
  const factory EditState.unknownError() = _UnknownErrorState;
}

@freezed
abstract class Background with _$Background {
  const factory Background.image(File file) = ImageBackground;

  /// Must contain at least one color.
  const factory Background.gradient([
    @Default(Background.defaultGradientColors) List<Color> colors,
  ]) = GradientBackground;

  static const defaultGradientColors = [Color(0xffd72e8b), Color(0xffa32b82)];
}
