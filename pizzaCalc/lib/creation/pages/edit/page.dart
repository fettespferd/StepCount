import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pizzaCalc/app/module.dart';
import 'package:pizzaCalc/content/module.dart';

import 'cubit.dart';

class EditPage extends StatefulWidget {
  const EditPage({@required this.backgroundType, this.picturePath})
      : assert(backgroundType != null);

  final String backgroundType;
  final String picturePath;

  @override
  _EditPageState createState() => _EditPageState(backgroundType, picturePath);
}

class _EditPageState extends State<EditPage>
    with StateWithCubit<EditCubit, EditState, EditPage> {
  _EditPageState(String backgroundType, String picturePath)
      : assert(backgroundType != null),
        cubit = EditCubit(backgroundType, picturePath);

  @override
  final EditCubit cubit;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void onCubitData(EditState state) {
    state.maybeWhen(
      unknownError: () => _scaffoldKey
          .showSimpleSnackBar(context.s.creation_edit_error_unknown),
      orElse: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final brightness = context.theme.brightness;

    return WillPopScope(
      onWillPop: context.showDiscardChangesDialog,
      child: Theme(
        data: AppTheme.secondary(brightness),
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.black,
            body: SafeArea(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: AspectRatio(
                      aspectRatio: ContentMedia.aspectRatio,
                      child: _buildBackground(),
                    ),
                  ),
                  Positioned.fill(child: _Overlay(cubit)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return cubit.background.when(
      image: (file) => Image.file(file, fit: BoxFit.cover),
      gradient: (colors) => DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SizedBox.expand(),
      ),
    );
  }
}

class _Overlay extends StatelessWidget {
  const _Overlay(this.cubit) : assert(cubit != null);

  static final _scrimColor = Colors.black.withOpacity(0.2);
  static const _scrimHeight = kToolbarHeight;

  final EditCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ..._buildScrims(),
        Positioned(left: 0, top: 0, child: CloseButton()),
        Positioned(
          right: 0,
          bottom: 0,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: _buildFab(context),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildScrims() {
    final colors = [_scrimColor, Colors.transparent];

    return [
      Positioned(
        left: 0,
        top: 0,
        right: 0,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [_scrimColor, Colors.transparent],
            ),
          ),
          child: SizedBox(height: _scrimHeight),
        ),
      ),
      Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: colors,
            ),
          ),
          child: SizedBox(height: _scrimHeight),
        ),
      ),
    ];
  }

  Widget _buildFab(BuildContext context) {
    return FancyFab.extended(
      isEnabled: cubit.canPost,
      isLoading: cubit.isPosting,
      loadingIndicator: SizedBox.fromSize(
        size: Size.square(18),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          value: cubit.postingProgress,
          valueColor: AlwaysStoppedAnimation<Color>(
            context.theme.highEmphasisOnPrimary,
          ),
        ),
      ),
      onPressed: () async {
        if (!await cubit.post()) return;
        context.navigator..pop()..pop();
      },
      icon: Icon(Icons.send),
      label: Text('Posten'),
      reverseChildren: true,
    );
  }
}
