import 'dart:convert';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import "dart:io";
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/state_manager.dart';

class FoodMenu {
  FoodMenu({this.category, this.list});
  List<Item> list;
  List<CategoryItem> category;
  factory FoodMenu.fromJson(Map<String, dynamic> json) {
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
    return FoodMenu(list: items, category: categoryItems);
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
    return {
      "id": id,
      "widget": widget == null ? "" : widget,
      "title": title,
      "price": price,
      "catId": catId,
      "content": content == null ? "" : content
    };
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

Future<FoodMenu> loadFood(XFile xFile) async {
  String content = await xFile.readAsString();
  FoodMenu f = FoodMenu.fromJson(jsonDecode(content));
  return f;
}

saveFood(FoodMenu menu) async {
  String content = jsonEncode(menu);
  File f = new File('/tmp/config.json');
  var writer = f.openWrite();
  writer.write(content);
  await writer.close();
}

Future<FoodMenu> getFood() async {
  try {
    XFile file = XFile("/tmp/config.json");
    FoodMenu menu = await loadFood(file);
    return menu;
  } catch (e) {
    String content = await rootBundle.loadString('assets/images/food.json');
    return FoodMenu.fromJson(jsonDecode(content));
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

class FoodValueNotifierData extends ValueNotifier<FoodMenu> {
  FoodValueNotifierData(value) : super(value);
  update(FoodMenu menu) {
    value = menu;
  }
}
