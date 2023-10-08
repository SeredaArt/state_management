import 'package:flutter/material.dart';
import 'package:data/data.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_bloc/flutter_bloc.dart';

List basket = [];

abstract class CounterEvent {}

class CounterReadEvent extends CounterEvent {}

abstract class IndexEvent {}

class IndexChangeEvent extends IndexEvent {}

class BasketCounterBloc extends Bloc<CounterEvent, int> {

  BasketCounterBloc() : super(0) {
    on<CounterReadEvent>(_onRead);
  }

  _onRead(CounterReadEvent event, Emitter<int> emit) {
    emit(basket.length);
  }
}

class IndexBloc extends Bloc<IndexEvent, int> {

  IndexBloc() : super(0) {
    on<IndexChangeEvent>(_onChange);
  }

  _onChange(IndexChangeEvent event, Emitter<int> emit) {
    emit(state == 0 ? 1 : 0);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: BlocProvider<BasketCounterBloc>(
          create: (_) => BasketCounterBloc(),
          child: BlocProvider<IndexBloc>(
            create: (_) => IndexBloc(),
            child: MyHomePage(title: 'Покупки'),
          ),
        ));
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key, required this.title});

  final String title;
  final List basketItems = getData();

  @override
  Widget build(BuildContext context) {
    print('build');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Покупки'),
      ),
      body: BlocBuilder<IndexBloc, int>(
        builder: (_, state) {
          return IndexedStack(
            index: state.toInt(),
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
                        onPressed: () {
                          basket.add(basketItems[index]);
                          BlocProvider.of<BasketCounterBloc>(context)
                              .add(CounterReadEvent());
                        },
                        icon: Icon(Icons.add),
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
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
              onTap: (index) {
                BlocProvider.of<IndexBloc>(context).add(IndexChangeEvent());
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
                  icon: BlocBuilder<BasketCounterBloc, int>(
                    builder: (_, state) {
                      return badges.Badge(
                        position: badges.BadgePosition.topEnd(),
                        badgeStyle: const badges.BadgeStyle(
                          padding: EdgeInsets.all(4),
                        ),
                        badgeContent: Text(
                          state.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 8),
                        ),
                        child: Icon(Icons.shopping_basket_outlined),
                      );
                    },
                  ),
                ),
              ]),
    );
  }
}
