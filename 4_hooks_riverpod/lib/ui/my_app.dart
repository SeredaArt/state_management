import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:data/data.dart';
import 'package:badges/badges.dart' as badges;

List basket = [];

final counterProvider =
    StateNotifierProvider<BasketCounter, int>((_) => BasketCounter());
var indexProvider = StateProvider<int>((ref) => 0);

class BasketCounter extends StateNotifier<int> {
  BasketCounter() : super(0);

  int readBasketCount() {
    state = basket.length;
    return state;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
        child: MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    ));
  }
}

class MyHomePage extends HookConsumerWidget {
  final List basketItems = getData();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('build');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Покупки'),
      ),
      body: IndexedStack(
        index: ref.watch(indexProvider),
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
                      ref.read(counterProvider.notifier).readBasketCount();
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
      bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            ref.read(indexProvider.notifier).state = index;
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
                badgeContent: HookConsumer(
                  builder: (context, ref, _) {
                    final count = ref.watch(counterProvider);
                    return Text(
                      count.toString(),
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
}
