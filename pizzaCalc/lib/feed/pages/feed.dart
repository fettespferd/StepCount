import 'package:flutter/material.dart';
import 'package:pizzaCalc/app/module.dart';
import 'package:pizzaCalc/feed/pages/cubit.dart';
import '../../auth/widgets/blurry_dialog.dart';

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator>
    with StateWithCubit<PizzaCubit, PizzaState, Calculator> {
  @override
  PizzaCubit cubit = PizzaCubit();

  double firstPizzaSize = 21;
  double pricePerCmSquaredFirst;
  double pricePerCmSquaredSecond;
  double smallestSize = 16;
  double largestSize = 32;
  bool firstPizzaEntered = false;
  bool secondPizzaEntered = false;
  int currentPriceEuro = 0;
  int currentPriceCent = 0;
  ScrollPhysics physics = FixedExtentScrollPhysics();

  @override
  void onCubitData(PizzaState state) {
    state.maybeWhen(
        isSliding: (val) {
          firstPizzaSize = val;
        },
        successFirst: (pricePerArea) {
          pricePerCmSquaredFirst = pricePerArea;
          firstPizzaEntered = true;
        },
        successSecond: (secondCheaper) {
          context.showBlurryDialog(
              title: 'Entscheidung',
              content: secondCheaper
                  ? 'Kaufe lieber die zweite Pizza'
                  : 'Kaufe lieber die erste Pizza',
              buttonMessage: 'Okay',
              onButtonPressed: () {
                context.rootNavigator.pop();
                cubit.reset();
              });
        },
        reset: () {
          firstPizzaEntered = false;
          currentPriceEuro = 0;
          currentPriceCent = 0;
        },
        orElse: () {});
  }

  Future<Widget> _onButtonPressed() {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              height: 230,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      'Preis',
                      style: context.textTheme.headline4,
                    ),
                  ),
                  Row(mainAxisSize: MainAxisSize.min, children: [
                    Container(
                      width: context.mediaQuery.size.width / 10,
                      height: 80,
                      child: ListWheelScrollView(
                        clipBehavior: Clip.hardEdge,
                        physics: physics,
                        onSelectedItemChanged: (i) {
                          currentPriceEuro = i;
                        },
                        diameterRatio: 1,
                        overAndUnderCenterOpacity: 0.4,
                        itemExtent: 20,
                        magnification: 1.8,
                        children: priceList(),
                      ),
                    ),
                    Text(
                      ',',
                      style: context.textTheme.headline5,
                    ),
                    Container(
                      width: context.mediaQuery.size.width / 14,
                      height: 80,
                      child: ListWheelScrollView(
                        diameterRatio: 1,
                        physics: physics,
                        onSelectedItemChanged: (i) {
                          currentPriceCent = i;
                        },
                        overAndUnderCenterOpacity: 0.4,
                        itemExtent: 20,
                        magnification: 1.8,
                        children: centList(),
                      ),
                    ),
                    Text(
                      ' €',
                      style: context.textTheme.headline5,
                    ),
                  ]),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: RaisedButton(
                      child: Text(
                        'Speichern',
                        style: context.textTheme.headline5,
                      ),
                      onPressed: () {
                        firstPizzaEntered
                            ? cubit.calculateResult(
                                currentPriceEuro,
                                currentPriceCent,
                                firstPizzaSize,
                                pricePerCmSquaredFirst)
                            : cubit.calculatePrice(currentPriceEuro,
                                currentPriceCent, firstPizzaSize);
                        context.navigator.pop();
                      },
                    ),
                  ),
                ],
              ));
        });
  }

  List<Widget> priceList() {
    final widgetList = <Widget>[];
    final list = Iterable<int>.generate(50).toList();
    list.asMap().forEach((key, value) {
      widgetList.add(Text('$value'));
    });
    return widgetList;
  }

  List<Widget> centList() {
    final widgetList = <Widget>[];
    final list = Iterable<int>.generate(10).toList();
    list.asMap().forEach((key, value) {
      widgetList.add(Text('$value'));
    });
    return widgetList;
  }

  Widget _stepProgress() {
    return Text(
      'Schritte',
      style: context.textTheme.headline4,
    );
  }

  Widget _calories() {
    return Text(
      'Kalorien',
      style: context.textTheme.headline4,
    );
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
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
              Center(
                child: RaisedButton(
                  onPressed: _onButtonPressed,
                  child: Text('Daily Goal'),
                ),
              ),
            ]));
  }
}
