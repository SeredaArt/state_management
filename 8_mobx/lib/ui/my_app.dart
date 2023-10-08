import 'package:flutter/material.dart';
import 'package:data/data.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'state.dart';

List basket = [];

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
        home: Provider(
          create: (context) => ExampleState(),
          child: MyHomePage(title: 'Покупки'),
        ));
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key, required this.title});

  final String title;
  final List basketItems = getData();

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<ExampleState>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Покупки'),
      ),
      body: Observer(
        builder: (context) => IndexedStack(
          index: state.index,
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
                        state.readBasket();
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
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            state.indexChange();
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
                badgeContent: Observer(
                    builder: (context) => Text(
                          state.value.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 8),
                        )),
                child: Icon(Icons.shopping_basket_outlined),
              ),
            ),
          ]),
    );
  }
}
