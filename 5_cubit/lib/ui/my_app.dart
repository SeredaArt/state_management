import 'dart:async';

import 'package:flutter/material.dart';
import 'package:data/data.dart';
import 'package:badges/badges.dart' as badges;

List basket = [];

class BasketCounterBloc {
  int value = 0;

  final _stateController = StreamController<int>();

  Stream<int> get state => _stateController.stream;

  void dispose() {
    _stateController.close();
  }

  void read() {
    value = basket.length;
    _stateController.add(value);
  }
}

class IndexBloc {
  int value = 0;

  final _stateController = StreamController<int>();

  Stream<int> get state => _stateController.stream;

  void dispose() {
    _stateController.close();
  }

  void change() {
    value = value == 0 ? 1 : 0;

    _stateController.add(value);
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
      home: const MyHomePage(title: 'Покупки'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List basketItems = getData();
  late final BasketCounterBloc bloc;
  late final IndexBloc blocNavi;

  @override
  Widget build(BuildContext context) {
    print('build');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Покупки'),
      ),
      body: StreamBuilder(
        stream: blocNavi.state,
        builder: (_, snapshot) {
          final index = snapshot.data == null ? 0 : snapshot.data?.toInt();
          return IndexedStack(
            index: index,
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
                          bloc.read();
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
            blocNavi.change();
          },
          items: <BottomNavigationBarItem>[
            const BottomNavigationBarItem(
              icon: Icon(Icons.list_outlined),
              label: 'Каталог',
              backgroundColor: Colors.red,
            ),
            BottomNavigationBarItem(
              icon: badges.Badge(
                position: badges.BadgePosition.topEnd(),
                badgeStyle: const badges.BadgeStyle(
                  padding: EdgeInsets.all(4),
                ),
                badgeContent: StreamBuilder(
                  stream: bloc.state,
                  builder: (_, snapshot) {
                    final count = snapshot.data?.toString() ?? '';
                    return Text(
                      count,
                      style: TextStyle(color: Colors.white, fontSize: 8),
                    );
                  },
                ),
                child: Icon(Icons.shopping_basket_outlined),
              ),
              label: 'Корзина',
              backgroundColor: Colors.green,
            ),
          ]),
    );
  }

  @override
  void initState() {
    super.initState();
    bloc = BasketCounterBloc();
    blocNavi = IndexBloc();
  }

  @override
  void dispose() {
    bloc.dispose();
    blocNavi.dispose();
    super.dispose();
  }
}
