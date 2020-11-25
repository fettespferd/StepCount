//Mathematical assumption to calculate total calories based on weight and height
int calcCalories(double weight, int height, int totalSteps) {
  final caloriesPerMile = 0.57 * weight * 2.2; //Conversion to pounds
  final strideLength = height * 0.415; //Assumption
  final stepCountperMile = 160934.4 / strideLength; //Mile in cm
  final conversionFactor = caloriesPerMile / stepCountperMile;
  return (totalSteps * conversionFactor).toInt();
}

//Mathmatical function to calculate the completion in percent
int completionPercentage(int currentSteps, int targetSteps) {
  final percentValue = (currentSteps / targetSteps * 100).toInt();
  if (percentValue < 100) {
    return percentValue;
  } else {
    return 100;
  }
}
