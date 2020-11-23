import 'package:pizzaCalc/app/module.dart';

part 'cubit.freezed.dart';

class PizzaCubit extends Cubit<PizzaState> {
  PizzaCubit() : super(PizzaState.initial());

  Future<void> moveSlider(double val) async {
    emit(PizzaState.isSliding(val));
  }

  Future<void> reset() async {
    emit(PizzaState.reset());
  }

  Future<void> calculatePrice(
      int currentPriceEuro, int currentPriceCent, double pizzaSize) async {
    final totalPriceCent = currentPriceEuro * 100 + currentPriceCent;
    final pricePerArea = totalPriceCent / pizzaSize;
    emit(PizzaState.successFirst(pricePerArea));
  }

  Future<void> calculateResult(int currentPriceEuro, int currentPriceCent,
      double pizzaSize, double pricePerCmSquaredFirst) async {
    final totalPriceCent = currentPriceEuro * 100 + currentPriceCent;
    final pricePerArea = totalPriceCent / pizzaSize;
    final secondCheaper = pricePerCmSquaredFirst > pricePerArea;
    emit(PizzaState.successSecond(secondCheaper));
  }
}

@freezed
abstract class PizzaState with _$PizzaState {
  const factory PizzaState.initial() = _InitialState;
  const factory PizzaState.isCalculating() = _CalculatingState;
  const factory PizzaState.isSliding(double val) = _SlidingState;
  const factory PizzaState.successFirst(double pricePerArea) =
      _SuccessFirstState;
  // ignore: avoid_positional_boolean_parameters
  const factory PizzaState.successSecond(bool secondCheaper) =
      _SuccessSecondState;
  const factory PizzaState.reset() = _ResetState;
}
