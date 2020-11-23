import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:pizzaCalc/app/module.dart';

import '../edit/cubit.dart';
import 'cropped_camera_preview.dart';
import 'cubit.dart';

class CameraPage extends StatefulWidget {
  const CameraPage();

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage>
    with StateWithCubit<CameraCubit, CameraState, CameraPage> {
  @override
  CameraCubit cubit = CameraCubit();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void onCubitData(CameraState state) {
    state.maybeWhen(
      error: _showCameraException,
      orElse: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final brightness = context.theme.brightness;

    return Theme(
      data: AppTheme.secondary(brightness),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.black,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(child: _buildPreview()),
            Positioned.fill(child: SafeArea(child: _buildControls())),
          ],
        ),
      ),
    );
  }

  Widget _buildPreview() {
    if (cubit.controller == null || !cubit.controller.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }

    return CroppedCameraPreview(cubit.controller);
  }

  Widget _buildControls() {
    return Material(
      type: MaterialType.transparency,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Spacer(),
            Align(alignment: Alignment.centerLeft, child: _buildLeftControls()),
            Spacer(),
            _buildBottomControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftControls() {
    return IconButton(
      padding: EdgeInsets.all(8),
      onPressed: () {
        if (!cubit.selectGradient()) return;
        context.navigator.pushNamed('creation/edit?backgroundType=gradient');
      },
      icon: Material(
        clipBehavior: Clip.antiAlias,
        shape: CircleBorder(side: BorderSide(color: Colors.white, width: 2)),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: Background.defaultGradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SizedBox.expand(),
        ),
      ),
    );
  }

  Widget _buildBottomControls() {
    Future<void> takePicture() async {
      final path = await cubit.takePicture();
      if (path == null) return;
      await context.navigator.pushNamed(
        'creation/edit?backgroundType=image&picturePath=${Uri.encodeQueryComponent(path)}',
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          padding: EdgeInsets.all(16),
          icon: Icon(OMIcons.image),
          onPressed: () {
            _scaffoldKey.showSimpleSnackBar(
              context.s.creation_camera_galleryButton,
            );
          },
        ),
        _ShutterButton(
          onPressed: cubit.canTakePicture ? takePicture : null,
        ),
        IconButton(
          padding: EdgeInsets.all(16),
          icon: Icon(OMIcons.switchCamera),
          onPressed: cubit.canToggleCameras ? cubit.toggleCameras : null,
        ),
      ],
    );
  }

  void _showCameraException(CameraException e) {
    logger.e('CameraWidget: Camera exception ${e.code}: ${e.description}');
    _showErrorSnackBar('${e.code}\n${e.description}');
  }

  void _showErrorSnackBar(String message) =>
      _scaffoldKey.showSimpleSnackBar(context.s.app_error_unknown(message));
}

class _ShutterButton extends StatelessWidget {
  const _ShutterButton({this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final color = onPressed != null ? Colors.white : Colors.grey.shade500;
    return RawMaterialButton(
      onPressed: onPressed,
      fillColor: color,
      splashColor: color.disabledOnColor,
      constraints: BoxConstraints.tight(Size.square(64)),
      shape: CircleBorder(side: BorderSide(color: Colors.black, width: 2)) +
          CircleBorder(side: BorderSide(color: color, width: 3)),
    );
  }
}
