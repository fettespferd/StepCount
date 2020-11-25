import 'package:stepCalc/app/module.dart';
import 'package:stepCalc/settings/preferences.dart';

part 'cubit.freezed.dart';

class ProfilCubit extends Cubit<ProfilState> {
  ProfilCubit() : super(ProfilState.initial());

  Future<void> moveSlider(double val) async {
    emit(ProfilState.isSlidingWeight(val));
  }

  Future<void> moveHeightSlider(int val) async {
    emit(ProfilState.isSlidingHeight(val));
  }

  Future<void> setData(double userWeight, int userHeight) async {
    UserPreferences().userWeight = userWeight;
    UserPreferences().userHeight = userHeight;

    emit(ProfilState.success());
  }
}

@freezed
abstract class ProfilState with _$ProfilState {
  const factory ProfilState.initial() = _InitialState;
  const factory ProfilState.isSlidingWeight(double val) = _WeightslideState;
  const factory ProfilState.isSlidingHeight(int val) = _HeightslideState;
  const factory ProfilState.success() = _SuccessState;
}
