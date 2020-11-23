class BurnedCalorieCalculator {
  double weight = 67; //in kg
  double height = 178; //incm

}

int calcCalories(double weight, double height, int totalSteps) {
  final caloriesPerMile = 0.57 * weight * 2.2; //Conversion to pounds
  final strideLength = height * 0.415; //Assumption
  final stepCountperMile = 160934.4 / strideLength; //Mile in cm
  final conversionFactor = caloriesPerMile / stepCountperMile;
  return (totalSteps * conversionFactor).toInt();
}
