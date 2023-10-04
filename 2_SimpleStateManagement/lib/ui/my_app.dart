import 'package:flutter/material.dart';
import 'package:data/data.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';

List basket = [];

class BasketCounter with ChangeNotifier {
  int value = 0;

  void increment() {
    value = basket.length;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BasketCounter>(
        create: (context) => BasketCounter(),
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const MyHomePage(title: 'Покупки'),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    });
  }

  @override
  void disposeState() {
    _tabController.dispose();
    super.dispose();
  }

  List basketItems = getData();

  @override
  Widget build(BuildContext context) {
    print('build');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: TabBarView(
        controller: _tabController,
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
                      context.read<BasketCounter>().increment();
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
            setState(() {
              _tabController.index = index;
              _currentTabIndex = index;
            });
          },
          currentIndex: _currentTabIndex,
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
                badgeContent: Consumer<BasketCounter>(
                    builder: (context, state, child) => Text(
                          context.watch<BasketCounter>().value.toString(),
                          style: TextStyle(color: Colors.white),
                        )),
                child: Icon(Icons.shopping_basket_outlined),
              ),
              label: 'Корзина',
              backgroundColor: Colors.green,
            ),
          ]),

      // )
    );
  }
}
