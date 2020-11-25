import 'package:flutter/material.dart';
import 'package:stepCalc/app/module.dart';
import 'package:stepCalc/profile/pages/cubit.dart';
import 'package:stepCalc/settings/preferences.dart';
import '../../auth/widgets/blurry_dialog.dart';

class ProfilPage extends StatefulWidget {
  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage>
    with StateWithCubit<ProfilCubit, ProfilState, ProfilPage> {
  double userWeight;
  int userHeight;
  double minWeight = 45;
  double maxWeight = 150;
  int minHeight = 140;
  int maxHeight = 210;

  @override
  void initState() {
    userWeight = UserPreferences().userWeight;
    userHeight = UserPreferences().userHeight;
    super.initState();
  }

  @override
  ProfilCubit cubit = ProfilCubit();

  @override
  void onCubitData(ProfilState state) {
    state.maybeWhen(
        isSlidingWeight: (val) {
          userWeight = val;
        },
        isSlidingHeight: (val) {
          userHeight = val;
        },
        success: () {
          context.showBlurryDialog(
            title: context.s.profile_alert_title,
            content: context.s.profile_alert_content,
            buttonMessage: context.s.profile_alert_content,
            onButtonPressed: () {
              context.rootNavigator.pop();
            },
          );
        },
        orElse: () {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.s.profile_title),
        backgroundColor: context.theme.appBarTheme.color,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 64),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(context.s.profile_set_weight,
                        style: TextStyle(fontWeight: FontWeight.normal))),
              ),
              Center(
                child: Slider(
                    label: '${userWeight.toStringAsFixed(1)} kg',
                    value: userWeight,
                    divisions: 50,
                    min: minWeight,
                    max: maxWeight,
                    onChanged: (val) {
                      cubit.moveSlider(val);
                    }),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(context.s.profile_set_height,
                        style: TextStyle(fontWeight: FontWeight.normal))),
              ),
              Center(
                child: Slider(
                    label: '$userHeight cm',
                    value: userHeight.toDouble(),
                    divisions: 50,
                    min: minHeight.toDouble(),
                    max: maxHeight.toDouble(),
                    onChanged: (val) {
                      cubit.moveHeightSlider(val.toInt());
                    }),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ElevatedButton(
                  child: Text(context.s.profile_set_params),
                  onPressed: () {
                    cubit.setData(userWeight, userHeight);
                  },
                ),
              ),
              ElevatedButton(
                child: Text(context.s.settings),
                onPressed: () => context.rootNavigator.pushNamed('/settings'),
              ),
              ElevatedButton(
                child: Text(context.s.log_out),
                onPressed: () async {
                  await services.firebaseAuth.signOut();
                  await context.rootNavigator.pushReplacementNamed('/login');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
