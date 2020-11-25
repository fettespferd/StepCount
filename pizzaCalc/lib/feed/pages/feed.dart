import 'package:flutter/material.dart';
import 'package:pizzaCalc/app/module.dart';
import 'package:pizzaCalc/feed/pages/cubit.dart';
import 'package:pizzaCalc/settings/preferences.dart';
import '../../auth/widgets/blurry_dialog.dart';
import 'package:timezone/timezone.dart' as tz;
import '../../main.dart';
import 'utils.dart';

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator>
    with StateWithCubit<StepCounter, StepCounterState, Calculator> {
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

  //Step Variables

  ScrollPhysics physics = FixedExtentScrollPhysics();

  @override
  void onCubitData(StepCounterState state) {
    state.maybeWhen(
        initialized: (targetSteps) {
          targetSteps = targetSteps;
        },
        newTarget: (int newTargetSteps) async {
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
            scheduleNotification(notificationsAllowed);
          }
        },
        success: () {
          //For safety
        },
        orElse: () {});
  }

  List<Widget> _targetStepList() {
    final widgetList = <Widget>[];
    final list = [for (var i = 3000; i <= 30000; i += 500) i];
    list.asMap().forEach((key, value) {
      widgetList.add(
        Text(
          '$value',
          style: TextStyle(color: Colors.orange),
        ),
      );
    });
    return widgetList;
  }

  Widget counterWidget(String text, String image) {
    return Column(
      children: [
        Image.asset(image),
        SizedBox(height: 8),
        Text(
          text,
          style: context.textTheme.bodyText2,
        ),
      ],
    );
  }

  int _completionPercentage(int currentSteps, int targetSteps) {
    final percentValue = (currentSteps / targetSteps * 100).toInt();
    if (percentValue < 100) {
      return percentValue;
    } else {
      return 100;
    }
  }

  Future<void> scheduleNotification(bool notificationsAllowed) async {
    final now = tz.TZDateTime.now(local);
    final reminderTime = now;
    //tz.TZDateTime.local(now.year, now.month, now.day, 22, 39);
    if (notificationsAllowed) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
          0,
          'Schritte nicht geschafft',
          'Du musst noch laufen',
          reminderTime.add(const Duration(seconds: 5)),
          const NotificationDetails(
              android: AndroidNotificationDetails('your channel id',
                  'your channel name', 'your channel description')),
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime);
    }
  }

  void toggleButton() {
    cubit.toggleNotification();
  }

  @override
  Widget build(BuildContext context) {
    final width = context.mediaQuery.size.width;
    final height = context.mediaQuery.size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Stepcounter'),
        backgroundColor: Colors.black12,
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
                  refreshButton(cubit, userWeight, userHeight),
                  notificationButton(notificationsAllowed, cubit)
                ],
              ),
              CircularPercentIndicator(
                radius: width / 1.5,
                lineWidth: 15,
                percent: (_completionPercentage(currentSteps, targetSteps)
                        .toDouble()) /
                    100,
                center: Text(
                    '${_completionPercentage(currentSteps, targetSteps)}%'),
                progressColor: Colors.green,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  counterWidget('$currentSteps / $targetSteps \n    Schritte',
                      'assets/images/steps.png'),
                  counterWidget('    $currentCalories \nKalorien',
                      'assets/images/flame.png'),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Center(
                  child: RaisedButton(
                    color: Colors.orange,
                    onPressed: () {
                      _onButtonPressed(targetSteps);
                    },
                    child: Wrap(
                      children: [
                        Icon(Icons.create, size: 15),
                        SizedBox(
                          width: 5,
                        ),
                        Text('Daily Goal'),
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
                    percent: (_completionPercentage(currentSteps, targetSteps)
                            .toDouble()) /
                        100,
                    backgroundColor: Colors.grey,
                    progressColor: Colors.blue,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Widget> _onButtonPressed(int targetSteps) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              height: 280,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(
                      'Tagesziel',
                      style: context.textTheme.headline4,
                    ),
                  ),
                  Container(
                    width: context.mediaQuery.size.width / 2,
                    height: 100,
                    child: ListWheelScrollView(
                      controller: FixedExtentScrollController(
                        initialItem: (targetSteps - 3000) ~/ 500,
                      ),
                      clipBehavior: Clip.hardEdge,
                      physics: physics,
                      onSelectedItemChanged: (i) {
                        selectedTargetSteps = i * 500 + 3000;
                      },
                      diameterRatio: 1,
                      magnification: 1.5,
                      overAndUnderCenterOpacity: 0.4,
                      itemExtent: 18,
                      children: _targetStepList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: RaisedButton(
                      child: Text(
                        'Speichern',
                        style: context.textTheme.headline5,
                      ),
                      onPressed: () {
                        cubit.setTargetSteps(selectedTargetSteps);

                        context.navigator.pop();
                      },
                    ),
                  ),
                ],
              ));
        });
  }
}
