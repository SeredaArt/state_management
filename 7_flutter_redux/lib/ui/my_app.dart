import 'package:flutter/material.dart';
import 'package:data/data.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

List basket = [];

class BasketCounterRead {}

@immutable
class AppState {
  final int value;

  const AppState({
    this.value = 0,
  });

  factory AppState.initial() => const AppState();

  AppState copyWith({
    int? value,
  }) {
    return AppState(
      value: value ?? this.value,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() {
    return 'AppState{value: $value}';
  }
}

final readBasketReducer = combineReducers<int>([
  TypedReducer<int, BasketCounterRead>(_read),
]);

int _read(int value, BasketCounterRead action) => value = basket.length;

AppState appReducer(AppState state, action) {
  return state.copyWith(
    value: readBasketReducer(state.value, action),
  );
}

class CounterConnector extends StatelessWidget {
  const CounterConnector({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (context, vn) {
        return MyHomePage(title: 'Покупки', value: vn.value, read: vn.onRead);
      },
    );
  }
}

class _ViewModel {
  final int value;
  final VoidCallback onRead;

  _ViewModel({
    required this.value,
    required this.onRead,
  });

  static _ViewModel fromStore(Store<AppState> store) => _ViewModel(
        value: store.state.value,
        onRead: () => store.dispatch(BasketCounterRead()),
      );
}

class MyApp extends StatelessWidget {
  final store = Store<AppState>(appReducer, initialState: AppState.initial());

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const CounterConnector(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage(
      {super.key,
      required this.title,
      required this.value,
      required this.read});

  final String title;
  final List basketItems = getData();
  final int value;
  final VoidCallback read;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text('Покупки')),
      body: IndexedStack(
        index: 0,
        children: [
          ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: basketItems.length,
              itemBuilder: (BuildContext context, int index) {
                String imagePath = basketItems[index].imagePath;
                return ListTile(
                  title: Center(child: Text('${basketItems[index].name}')),
                  leading: Image.asset('assets/images/$imagePath'),
                  trailing: OutlinedButton.icon(
                    label: Text('Добавить'),
                    icon: Icon(Icons.add),
                    onPressed: () {
                      basket.add(basketItems[index]);
                      read();
                    },
                  ),
                );
              }),
          ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: basket.length,
              itemBuilder: (BuildContext context, int index) {
                String imagePath = basket[index].imagePath;
                return ListTile(
                  title: Center(child: Text('${basket[index].name}')),
                  leading: Image.asset('assets/images/$imagePath'),
                );
              }),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            // BlocProvider.of<IndexBloc>(context).add(IndexChangeEvent());
          },
          items: <BottomNavigationBarItem>[
            const BottomNavigationBarItem(
              icon: Icon(Icons.list_outlined),
              label: 'Каталог',
              backgroundColor: Colors.red,
            ),
            BottomNavigationBarItem(
              label: 'Корзина',
              backgroundColor: Colors.green,
              icon: badges.Badge(
                position: badges.BadgePosition.topEnd(),
                badgeStyle: const badges.BadgeStyle(
                  padding: EdgeInsets.all(4),
                ),
                badgeContent: Text(
                  value.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 8),
                ),
                child: Icon(Icons.shopping_basket_outlined),
              ),
            ),
          ]),
    );
  }
}
