import 'package:mobx/mobx.dart';
import 'my_app.dart';

part 'state.g.dart';

class ExampleState = _ExampleState with _$ExampleState;

abstract class _ExampleState with Store {
  @observable
  int value = 0;

  @observable
  int index = 0;

  @action
  void readBasket() {
    value = basket.length;
  }

  @action
  void indexChange() {
    index = index == 0 ? 1 : 0;
  }
}
