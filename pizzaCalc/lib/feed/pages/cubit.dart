import 'package:pizzaCalc/app/module.dart';
import 'utils.dart';

part 'cubit.freezed.dart';

class StepCounter extends Cubit<StepCounterState> {
  StepCounter() : super(StepCounterState.initial());

  Future<void> setTargetSteps(int selectedTargetSteps) {
    emit(StepCounterState.newTarget(selectedTargetSteps));
  }

  Future<void> toggleNotification() {
    emit(StepCounterState.toggleNotification());
  }

  Future<void> syncData(double weight, double height) async {
    emit(StepCounterState.isLoading());
    var _healthDataList = <HealthDataPoint>[];
    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month, now.day);
    final endDate = now;

    final health = HealthFactory();

    /// Define the types to get.
    final types = <HealthDataType>[HealthDataType.STEPS];

    /// Fetch new data
    final healthData =
        await health.getHealthDataFromTypes(startDate, endDate, types);

    /// Save all the new data points
    _healthDataList.addAll(healthData);

    /// Filter out duplicates
    _healthDataList = HealthFactory.removeDuplicates(_healthDataList);
    int totalSteps = _healthDataList.fold(
        0,
        (previousValue, element) =>
            previousValue.toInt() + element.value.toInt());

    //Calc calories
    final totalCalories = calcCalories(weight, height, totalSteps);

    emit(StepCounterState.resynched(totalSteps, totalCalories));
  }
}

@freezed
abstract class StepCounterState with _$StepCounterState {
  const factory StepCounterState.initial() = _InitialState;
  const factory StepCounterState.isLoading() = _LoadingState;
  const factory StepCounterState.resynched(int totalSteps, int totalCalories) =
      _ResynchedState;
  const factory StepCounterState.newTarget(int selectedTargetSteps) =
      _NewTargetState;
  const factory StepCounterState.toggleNotification() = _ToggeledState;
  const factory StepCounterState.reset() = _ResetState;
}
