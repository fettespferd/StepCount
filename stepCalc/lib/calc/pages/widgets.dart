import 'package:flutter/material.dart';
import 'package:stepCalc/app/module.dart';

import 'package:stepCalc/settings/preferences.dart';
import 'cubit.dart';

//Animated notification Button to enable/disable notifications
Widget notificationButton(StepCounter cubit) {
  final notificationsAllowed = UserPreferences().allowNotification;

  return AnimatedContainer(
      duration: Duration(microseconds: 300),
      height: 30,
      width: 60,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black45),
        borderRadius: BorderRadius.circular(20),
        color: notificationsAllowed
            ? Colors.greenAccent[100]
            : Colors.redAccent[100].withOpacity(0.5),
      ),
      child: Stack(
        children: <Widget>[
          AnimatedPositioned(
            child: InkWell(
              onTap: () {
                cubit.toggleNotification();
              },
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                transitionBuilder: (var child, animation) {
                  return RotationTransition(child: child, turns: animation);
                },
                child: notificationsAllowed
                    ? Icon(Icons.notifications,
                        color: Colors.green, size: 23, key: UniqueKey())
                    : Icon(Icons.notifications_none,
                        color: Colors.red, size: 23, key: UniqueKey()),
              ),
            ),
            duration: Duration(milliseconds: 300),
            curve: Curves.easeIn,
            top: 3,
            left: notificationsAllowed ? 25 : 0,
            right: notificationsAllowed ? 0 : 25,
          ),
        ],
      ));
}

//Button to refresh the current Steps provided by the the health packge
Widget refreshButton(StepCounter cubit, double userWeight, int userHeight) {
  userWeight = UserPreferences().userWeight;
  userHeight = UserPreferences().userHeight;
  return IconButton(
    splashColor: Colors.green,
    iconSize: 35,
    icon: Icon(Icons.refresh),
    onPressed: () {
      cubit.syncData(userWeight, userHeight);
    },
  );
}

//UI Widget for selecting the target steps
Future<Widget> selectTargetSteps(int targetSteps, BuildContext context,
    StepCounter cubit, int selectedTargetSteps) {
  //Scrollphysics for snapping on items
  final physics = FixedExtentScrollPhysics();
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
                    context.s.stepCalc_daily_goal,
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
                    children: _targetStepList(context),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: ElevatedButton(
                    child: Text(
                      context.s.stepCalc_saveButton,
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

//Creates the list for desired target steps that the use can choose from
List<Widget> _targetStepList(BuildContext context) {
  final widgetList = <Widget>[];
  final list = [for (var i = 3000; i <= 30000; i += 500) i];
  list.asMap().forEach((key, value) {
    widgetList.add(
      Text(
        '$value',
        style: TextStyle(color: context.theme.primaryColor),
      ),
    );
  });
  return widgetList;
}

//Generic widget to display a text and image
Widget counterWidget(String text, String image, BuildContext context) {
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
