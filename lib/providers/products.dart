import 'dart:convert';

import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../models/product.dart';

class Products with ChangeNotifier {
  String? token, userId;

  void updateData(tokenData, uid) {
    token = tokenData;
    userId = uid;
    notifyListeners();
  }

  List<Product> _allProduct = [];
  List<Product> get allProduct => _allProduct;

  Future<void> addProduct(String title, String price) async {
    Uri url = Uri.parse(
        "https://auth-project-68c5f-default-rtdb.firebaseio.com/products.json?auth=$token");
    DateTime dateNow = DateTime.now();
    try {
      var response = await http.post(
        url,
        body: jsonEncode(
          {
            "title": title,
            "price": price,
            "createdAt": dateNow.toString(),
            "updatedAt": dateNow.toString(),
            "userId": userId,
          },
        ),
      );
      if (response.statusCode > 300 || response.statusCode < 200) {
        throw (response.statusCode);
      } else {
        Product data = Product(
          id: json.decode(response.body)["name"].toString(),
          title: title,
          price: price,
          cretedAt: dateNow,
          updatedAt: dateNow,
        );
        _allProduct.add(data);
        notifyListeners();
      }
    } catch (err) {
      rethrow;
    }
  }

  void editProduct(String id, String title, String price) async {
    Uri url = Uri.parse(
        "https://auth-project-68c5f-default-rtdb.firebaseio.com/products/$id.json?auth=$token");
    DateTime date = DateTime.now();
    try {
      var response = await http.patch(
        url,
        body: jsonEncode(
          {
            "title": title,
            "price": price,
            "updatedAt": date.toString(),
          },
        ),
      );
      if (response.statusCode > 300 || response.statusCode < 200) {
        throw (response.statusCode);
      } else {
        Product edit = _allProduct.firstWhere((element) => element.id == id);
        edit.title;
        edit.price;
        edit.updatedAt = date;
        notifyListeners();
      }
    } catch (err) {
      rethrow;
    }
  }

  void deleteProduct(String id) async {
    Uri url = Uri.parse(
        "https://auth-project-68c5f-default-rtdb.firebaseio.com/products/$id.json?auth=$token");

    try {
      var response = await http.delete(url);

      if (response.statusCode > 300 || response.statusCode < 200) {
        throw (response.statusCode);
      } else {
        _allProduct.removeWhere((element) => element.id == id);
        notifyListeners();
      }
    } catch (err) {
      rethrow;
    }
  }

  Product selectedById(String id) {
    return _allProduct.firstWhere((element) => element.id == id);
  }

  Future<void> inisialData() async {
    _allProduct = [];
    Uri url = Uri.parse(
        'https://auth-project-68c5f-default-rtdb.firebaseio.com/products.json?auth=$token&orderBy="userId"&equalTo="$userId"');
    try {
      var response = await http.get(url);

      if (response.statusCode >= 300 && response.statusCode < 200) {
        throw (response.statusCode);
      } else {
        var data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data != null) {
          data.forEach(
            (key, value) {
              Product prod = Product(
                id: key,
                title: value["title"],
                price: value["price"],
                cretedAt:
                    DateFormat("yyyy-mm-dd hh:mm:ss").parse(value["createdAt"]),
                updatedAt:
                    DateFormat("yyyy-mm-dd hh:mm:ss").parse(value["createdAt"]),
              );
              _allProduct.add(prod);
            },
          );
        }
      }
    } catch (err) {
      rethrow;
    }
  }
}
