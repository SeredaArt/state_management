class Item {
  late final String name;
  late final String imagePath;

  Item(this.name, this.imagePath);

  @override
  String toString() {
    return '{ ${this.name}, ${this.imagePath} }';
  }

}

Map<String , String> items =
{'Молоко': 'icons8-бутылка-молока-30.png',
  'Сыр': 'icons8-сыр-30.png',
  'Майонез': 'icons8-майонез-30.png',
  'Бананы': 'icons8-банан-30.png',
  'Багет': 'icons8-багет-30.png',
  'Огруцы': 'icons8-огурец-30.png',
  'Томаты': 'icons8-помидор-30.png',
  'Яблоки': 'icons8-яблоко-30.png',
  'Яйца': 'icons8-яйца-30.png',
  'Спагетти': 'icons8-спагетти-30.png'};
