import 'package:flutter/material.dart';
import 'package:pizzaCalc/app/module.dart';
import 'package:pizzaCalc/feed/pages/cubit.dart';
import '../../auth/widgets/blurry_dialog.dart';
import 'package:timezone/timezone.dart' as tz;
import '../../main.dart';

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator>
    with StateWithCubit<StepCounter, StepCounterState, Calculator> {
  @override
  StepCounter cubit = StepCounter();

  //Step Variables
  int targetSteps = 4000;
  int selectedTargetSteps = 4000;
  int currentSteps = 1000;
  int currentCalories = 0;
  bool isLoading = false;

  //Size Variables
  double userWeight = 73; //in kg
  double userHeight = 178; //in cm

  int totalCalories = 0;

  //Button
  bool toggleValue = false;

  ScrollPhysics physics = FixedExtentScrollPhysics();

  @override
  void onCubitData(StepCounterState state) {
    state.maybeWhen(
        newTarget: (int newTargetSteps) {
          targetSteps = newTargetSteps;
        },
        isLoading: () {
          isLoading = true;
        },
        toggleNotification: () {
          toggleValue = !toggleValue;
        },
        resynched: (var totalSteps, var totalCalories) {
          isLoading = false;
          currentSteps = totalSteps;
          currentCalories = totalCalories;
          if (totalSteps < targetSteps) {
            scheduleNotification();
          }
        },
        orElse: () {});
  }

  Future<Widget> _onButtonPressed() {
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
                      clipBehavior: Clip.hardEdge,
                      physics: physics,
                      onSelectedItemChanged: (i) {
                        selectedTargetSteps = i * 500 + 3000;
                      },
                      diameterRatio: 1,
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

  List<Widget> _targetStepList() {
    final widgetList = <Widget>[];
    final list = [for (var i = 3000; i <= 30000; i += 500) i];
    list.asMap().forEach((key, value) {
      widgetList.add(Text('$value'));
    });
    return widgetList;
  }

  Widget _stepProgress() {
    return Text(
      '$currentSteps / $targetSteps Schritte',
      style: context.textTheme.bodyText2,
    );
  }

  Widget _calories() {
    return Text(
      '$currentCalories Kalorien',
      style: context.textTheme.bodyText2,
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

  Future<void> scheduleNotification() async {
    var now = tz.TZDateTime.now(local);
    final reminderTime =
        tz.TZDateTime.local(now.year, now.month, now.day, 22, 39);

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
              CircularPercentIndicator(
                radius: width / 1.5,
                lineWidth: 15.0,
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
                  _stepProgress(),
                  _calories(),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Center(
                  child: RaisedButton(
                    onPressed: _onButtonPressed,
                    child: Text('Daily Goal'),
                  ),
                ),
              ),
              RaisedButton(
                child: Text('Refresh'),
                onPressed: () {
                  cubit.syncData(userWeight, userHeight);
                },
              ),
              LinearPercentIndicator(
                width: width / 1.2,
                lineHeight: 15,
                percent: (_completionPercentage(currentSteps, targetSteps)
                        .toDouble()) /
                    100,
                backgroundColor: Colors.grey,
                progressColor: Colors.blue,
              ),
              RaisedButton(
                  child: Text('Notify'), onPressed: scheduleNotification),
              AnimatedContainer(
                  duration: Duration(microseconds: 1000),
                  height: 40,
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: toggleValue
                        ? Colors.greenAccent[50]
                        : Colors.redAccent[700],
                  ),
                  child: Stack(
                    children: <Widget>[
                      AnimatedPositioned(
                        child: InkWell(
                          onTap: toggleButton,
                          child: AnimatedSwitcher(
                            duration: Duration(milliseconds: 1000),
                            transitionBuilder:
                                (var child, Animation<double> animation) {
                              return RotationTransition(
                                  child: child, turns: animation);
                            },
                            child: toggleValue
                                ? Icon(Icons.check_circle,
                                    color: Colors.greenAccent,
                                    size: 35,
                                    key: UniqueKey())
                                : Icon(Icons.remove_circle_outline,
                                    color: Colors.redAccent,
                                    size: 35,
                                    key: UniqueKey()),
                          ),
                        ),
                        duration: Duration(milliseconds: 1000),
                        curve: Curves.easeIn,
                        top: 3,
                        left: toggleValue ? 60 : 0,
                        right: toggleValue ? 60 : 0,
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
