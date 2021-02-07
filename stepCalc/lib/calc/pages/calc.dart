import 'package:flutter/material.dart';
import 'package:stepCalc/app/module.dart';
import 'package:stepCalc/calc/pages/cubit.dart';
import 'package:stepCalc/settings/preferences.dart';

import 'utils.dart';
import 'widgets.dart';

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator>
    with StateWithCubit<StepCounter, StepCounterState, Calculator> {
  // Initizialisation
  int targetSteps;
  double userWeight; //in kg
  int userHeight; //in cm
  bool notificationsAllowed;
  int selectedTargetSteps;
  int currentSteps = 1000;
  int currentCalories;
  int totalCalories;
  bool isLoading = true;

  @override
  void initState() {
    targetSteps = UserPreferences().targetSteps;
    userWeight = UserPreferences().userWeight;
    userHeight = UserPreferences().userHeight;
    notificationsAllowed = UserPreferences().allowNotification;
    cubit.syncData(userWeight, userHeight);
    super.initState();
  }

  @override
  StepCounter cubit = StepCounter();

  @override
  void onCubitData(StepCounterState state) {
    state.maybeWhen(
        initialized: (targetSteps) {
          targetSteps = targetSteps;
        },
        newTarget: (final newTargetSteps) async {
          targetSteps = newTargetSteps;
        },
        isLoading: () {
          isLoading = true;
        },
        toggleNotification: () {
          notificationsAllowed = !notificationsAllowed;
          UserPreferences().allowNotification = notificationsAllowed;
        },
        resynched: (var totalSteps, var totalCalories) {
          isLoading = false;
          currentSteps = totalSteps;
          currentCalories = totalCalories;
          if (totalSteps < targetSteps) {
            cubit.scheduleNotification(context,
                notificationsAllowed: notificationsAllowed);
          }
        },
        success: () {},
        orElse: () {});
  }

  @override
  Widget build(BuildContext context) {
    final height = context.mediaQuery.size.height;
    final width = context.mediaQuery.size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(context.s.stepCalc_stepCounter),
        backgroundColor: context.theme.appBarTheme.color,
      ),
      body: LoadingOverlay(
        isLoading: isLoading,
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RefreshButton(cubit, userWeight, userHeight),
                  NotificationButton(cubit)
                ],
              ),
              CircularPercentIndicator(
                radius: height / 3.5,
                lineWidth: 15,
                percent: (completionPercentage(currentSteps, targetSteps)
                        .toDouble()) /
                    100,
                center:
                    Text('${completionPercentage(currentSteps, targetSteps)}%'),
                progressColor: context.theme.primaryColor,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CounterWidget(
                      '$currentSteps / $targetSteps \n    ${context.s.stepCalc_steps}',
                      'assets/images/steps.png'),
                  CounterWidget(
                      '    $currentCalories \n${context.s.stepCalc_calories}',
                      'assets/images/flame.png'),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Center(
                  child: RaisedButton(
                    color: context.theme.primaryColor,
                    onPressed: () {
                      selectTargetSteps(
                          targetSteps, context, cubit, selectedTargetSteps);
                    },
                    child: Wrap(
                      children: [
                        Icon(Icons.create, size: 15),
                        SizedBox(
                          width: 5,
                        ),
                        Text(context.s.stepCalc_daily_goal),
                      ],
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(Icons.flag_rounded),
                  LinearPercentIndicator(
                    width: width / 1.2,
                    lineHeight: 15,
                    percent: (completionPercentage(currentSteps, targetSteps)
                            .toDouble()) /
                        100,
                    progressColor: context.theme.primaryColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
