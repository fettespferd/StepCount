import 'package:flutter/material.dart';
import 'cubit.dart';

class BurnedCalorieCalculator {
  double weight = 67; //in kg
  double height = 178; //incm

}

int calcCalories(double weight, int height, int totalSteps) {
  final caloriesPerMile = 0.57 * weight * 2.2; //Conversion to pounds
  final strideLength = height * 0.415; //Assumption
  final stepCountperMile = 160934.4 / strideLength; //Mile in cm
  final conversionFactor = caloriesPerMile / stepCountperMile;
  return (totalSteps * conversionFactor).toInt();
}

Widget notificationButton(bool notificationsAllowed, StepCounter cubit) {
  return AnimatedContainer(
      duration: Duration(microseconds: 300),
      height: 30,
      width: 60,
      decoration: BoxDecoration(
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
                    ? Icon(Icons.check_circle,
                        color: Colors.greenAccent, size: 25, key: UniqueKey())
                    : Icon(Icons.remove_circle_outline,
                        color: Colors.redAccent, size: 25, key: UniqueKey()),
              ),
            ),
            duration: Duration(milliseconds: 300),
            curve: Curves.easeIn,
            top: 3,
            left: notificationsAllowed ? 30 : 0,
            right: notificationsAllowed ? 0 : 30,
          ),
        ],
      ));
}

Widget refreshButton(StepCounter cubit, double userWeight, int userHeight) {
  return IconButton(
    splashColor: Colors.green,
    iconSize: 30,
    icon: Icon(Icons.refresh),
    onPressed: () {
      cubit.syncData(userWeight, userHeight);
    },
  );
}
