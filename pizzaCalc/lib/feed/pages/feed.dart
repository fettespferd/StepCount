import 'package:flutter/material.dart';
import 'package:pizzaCalc/app/module.dart';
import 'package:pizzaCalc/feed/pages/cubit.dart';
import '../../auth/widgets/blurry_dialog.dart';

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator>
    with StateWithCubit<StepCounter, StepCounterState, Calculator> {
  @override
  StepCounter cubit = StepCounter();

  int targetSteps = 4000;
  int selectedTargetSteps = 4000;
  int currentSteps = 1000;
  int currentCalories = 0;
  bool isLoading = false;
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
        resynched: (int totalSteps) {
          isLoading = false;
          currentSteps = totalSteps;
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
    return (currentSteps / targetSteps * 100).toInt();
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
                    percent: currentSteps / targetSteps,
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
                    onPressed: cubit.syncData,
                  ),
                  LinearPercentIndicator(
                    width: width / 1.2,
                    lineHeight: 15,
                    percent: currentSteps / targetSteps,
                    backgroundColor: Colors.grey,
                    progressColor: Colors.blue,
                  ),
                ]),
          ),
        ));
  }
}
