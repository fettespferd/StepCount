import 'package:flutter/material.dart';
import 'package:pizzaCalc/app/module.dart';
import 'package:pizzaCalc/profile/pages/cubit.dart';
import 'package:pizzaCalc/settings/preferences.dart';
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
        isSlidingWeight: (double val) {
          userWeight = val;
        },
        isSlidingHeight: (int val) {
          userHeight = val;
        },
        success: () {
          context.showBlurryDialog(
            title: 'Danke',
            content: 'Die Daten wurden eingetragen',
            buttonMessage: 'Okay',
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
        title: Text('Dein Profil'),
        backgroundColor: Colors.black12,
      ),
      body: GradientBackground(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 64),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Gewicht bestimmen:',
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
                      child: Text('Größe bestimmen:',
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
                  child: RaisedButton(
                    child: Text('Werte eintragen'),
                    onPressed: () {
                      cubit.setData(userWeight, userHeight);
                    },
                  ),
                ),
                ElevatedButton(
                  child: Text('Einstellungen'),
                  onPressed: () => context.rootNavigator.pushNamed('/settings'),
                ),
                ElevatedButton(
                  child: Text('Ausloggen'),
                  onPressed: () async {
                    await services.firebaseAuth.signOut();
                    await context.rootNavigator.pushReplacementNamed('/login');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
