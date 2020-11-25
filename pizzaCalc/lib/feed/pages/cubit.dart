import 'package:pizzaCalc/app/module.dart';
import 'package:pizzaCalc/settings/preferences.dart';
import 'utils.dart';

part 'cubit.freezed.dart';

class StepCounter extends Cubit<StepCounterState> {
  StepCounter() : super(StepCounterState.initial());

  int targetSteps;
  Future<void> _setInitialValues() async {
    targetSteps = await _getStepsFromSharedPrefs();
    emit(StepCounterState.initialized(targetSteps));
  }

  Future<int> _getStepsFromSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final targetSteps = prefs.getInt('targetSteps');
    if (targetSteps == null) {
      return 1000;
    }
    return targetSteps;
  }

  Future<void> setTargetSteps(int selectedTargetSteps) async {
    UserPreferences().targetSteps = selectedTargetSteps;
    emit(StepCounterState.newTarget(selectedTargetSteps));
  }

  Future<void> toggleNotification() {
    emit(StepCounterState.toggleNotification());
    emit(StepCounterState.success());
  }

  Future<void> syncData(double weight, int height) async {
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
  const factory StepCounterState.initialized(int targetSteps) =
      _InitializedState;
  const factory StepCounterState.isLoading() = _LoadingState;
  const factory StepCounterState.resynched(int totalSteps, int totalCalories) =
      _ResynchedState;
  const factory StepCounterState.newTarget(int selectedTargetSteps) =
      _NewTargetState;
  const factory StepCounterState.toggleNotification() = _ToggeledState;
  const factory StepCounterState.success() = _SuccessState;

  const factory StepCounterState.reset() = _ResetState;
}
