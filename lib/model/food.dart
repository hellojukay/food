import 'dart:convert';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import "dart:io";
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/state_manager.dart';

class Food {
  Food({this.category, this.list});
  List<Item> list;
  List<CategoryItem> category;
  factory Food.fromJson(Map<String, dynamic> json) {
    List<dynamic> itemJsonArray = json["list"].toList();
    List<dynamic> categoryItemJsonArray = json["category"].toList();
    List<Item> items = [];
    List<CategoryItem> categoryItems = [];
    for (var e in itemJsonArray) {
      var item = Item.fromJson(e);
      items.add(item);
    }
    for (var e in categoryItemJsonArray) {
      var c = CategoryItem.fromJson(e);
      categoryItems.add(c);
    }
    return Food(list: items, category: categoryItems);
  }
  Map toJson() {
    return {"list": list, "category": category};
  }
}

class Item {
  Item(
      {this.title, this.price, this.catId, this.id, this.widget, this.content});
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
        id: json["id"] as int,
        price: json["price"].toDouble(),
        catId: json["catId"] as int,
        title: json["title"] as String,
        content: json["content"] != null ? json["content"] : "",
        widget: json["widget"] != null ? json["widget"] : "");
  }
  Map toJson() {
    return {"title": title, "price": price};
  }

  String title;
  double price;
  int catId;
  int id;
  String widget;
  String content;
}

class CategoryItem {
  CategoryItem({this.name, this.id});
  factory CategoryItem.fromJson(Map<String, dynamic> e) {
    return CategoryItem(id: e["id"] as int, name: e["name"] as String);
  }
  Map toJson() {
    return {"name": name, "id": id};
  }

  String name;
  int id;
}

Future<Food> loadFood(XFile xFile) async {
  String content = await xFile.readAsString();
  Food f = jsonDecode(content);
  return f;
}

saveFood(Food food) async {
  String content = jsonEncode(food);
  File f = new File('/tmp/config.json');
  var writer = f.openWrite();
  writer.write(content);
  await writer.close();
}

Future<Food> getFood() async {
  try {
    XFile file = XFile("/tmp/config.json");
    Food food = await loadFood(file);
    return food;
  } catch (e) {
    String content = await rootBundle.loadString('assets/images/food.json');
    return Food.fromJson(jsonDecode(content));
  }
}

class OrderFood extends Item {
  OrderFood(
      {this.id, this.title, this.count, this.price, this.widget, this.content});
  int id;
  String title;
  int count;
  double price;
  String widget;
  String content;
}

class FoodValueNotifierData extends ValueNotifier<Food> {
  FoodValueNotifierData(value) : super(value);
}
