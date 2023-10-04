import 'package:model/model.dart';

List getData() {

  List data = [];

  items.forEach((k, v) => data.add(Item(k, v)));

  return data;

}

