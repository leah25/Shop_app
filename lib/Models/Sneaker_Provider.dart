import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_shop_app/Models/Sneeker.dart';
import 'package:flutter_shop_app/Models/my_exception.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  List<Sneeker> _sneekersData = [
    // Sneeker(
    //     id: 'S1',
    //     imageUrl: "https://picsum.photos/250?image=5",
    //     description:
    //         "Sneaker shoelaces rarely look as good as when they are adorning your athletic kicks. These sport-centric sneakers are Nike and Adidas regulars and are the perfect blend of functionality and style. Any activity faster than walking, and you’ll want to slip on a pair of these.",
    //     price: 45.09,
    //     title: "Athletics Kicks"),
    // Sneeker(
    //     id: 'S2',
    //     imageUrl: "https://picsum.photos/250?image=7",
    //     description:
    //         "These types of sneakers are super famous, and happen to be the most common of the bunch. Also called Low Top Sneakers, they stop just below the ankle and are best worn with secret socks and skinny jeans, or jeans rolled to reveal your naked ankle. Don’t wear high socks with these!",
    //     price: 75.19,
    //     title: "Plimsoll sneakers"),
    // Sneeker(
    //     id: 'S3',
    //     imageUrl: "https://picsum.photos/250?image=2",
    //     description:
    //         "Your high top sneakers have two excellent advantages – the first is that you can wear long socks and no-one will see them, the second is that they always look cool. These match especially well with the tight fitting jeans of today, even though they became famous on the basketball court.",
    //     price: 95.60,
    //     title: "Basketball Sneakers"),
    // Sneeker(
    //     id: 'S4',
    //     imageUrl: "https://picsum.photos/250?image=1",
    //     description:
    //         "Technically these sneakers are Vans, but they are an institution so they get on the list. We make the rules. These types of sneakers can be worn with anything, casual or formal, which makes them revolutionary. Clean, understated design means you’ll always look your best in these Authentics.",
    //     price: 45.09,
    //     title: "Authentic Sneakers"),
    // Sneeker(
    //     id: 'S5',
    //     imageUrl: "https://picsum.photos/250?image=8",
    //     description:
    //         "Ah, the classic slip-on sneaker that has absolutely no shoelaces at all. These smooth top sneakers are making a comeback in metallic and interesting patterns, and are great for easy-wear. In fact, they ooze casual, so like plimsoll sneakers, don’t wear them with high socks. That’s not cool.",
    //     price: 75.00,
    //     title: "Slip On Sneakers"),
    // Sneeker(
    //     id: 'S5',
    //     imageUrl: "https://picsum.photos/250?image=6",
    //     description:
    //         "Ah, the classic slip-on sneaker that has absolutely no shoelaces at all. These smooth top sneakers are making a comeback in metallic and interesting patterns, and are great for easy-wear. In fact, they ooze casual, so like plimsoll sneakers, don’t wear them with high socks. That’s not cool.",
    //     price: 75.00,
    //     title: "Slip On Sneakers"),
  ];
  final authToken;
  final userId;
  Product(this.authToken, this.userId, this._sneekersData);

  List<Sneeker> get sneekersData {
    return [..._sneekersData];
  }

  List<Sneeker> get favouriteSneeker {
    return _sneekersData.where((object) => object.isFavourite).toList();
  }

  Sneeker getById(String id) {
    return _sneekersData.firstWhere((prod) => (prod.id == id));
  }

  Future<void> updateProduct(String id, Sneeker updatedSneaker) async {
    var productIndex = _sneekersData.indexWhere((item) => item.id == id);
    if (productIndex >= 0) {
      final String url =
          'https://shop-b2f64-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
      await http.patch(url,
          body: json.encode({
            'title': updatedSneaker.title,
            'description': updatedSneaker.description,
            'price': updatedSneaker.price,
            'imageUrl': updatedSneaker.imageUrl,
          }));
    }
    _sneekersData[productIndex] = updatedSneaker;
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    final String url =
        'https://shop-b2f64-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
    final productIndex =
        _sneekersData.indexWhere((product) => product.id == id);
    var existingProduct = _sneekersData[productIndex];

    await http.delete(url).then((response) {
      if (response.statusCode >= 400) {
        // _sneekersData.insert(productIndex, existingProduct);
        notifyListeners();
        throw HttpException('Item not deleted');
      }
      existingProduct = null;
    }).catchError((_) {
      _sneekersData.insert(productIndex, existingProduct);
      notifyListeners();
    });
    _sneekersData.removeAt(productIndex);
    notifyListeners();
  }

  //fetch products form firebase
  Future<void> fetchProduct([bool filterUser = false]) async {
    String filterString =
        filterUser ? '&orderBy="creatorId"&equalTo="$userId"' : '';

    var url =
        'https://shop-b2f64-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      print(extractedData);
      if (extractedData == null) {
        return;
      }
      url =
          'https://shop-b2f64-default-rtdb.firebaseio.com/favorites/$userId.json?auth=$authToken';
      var favoriteResponse = await http.get(url);
      var favouriteData = json.decode(favoriteResponse.body);

      final List<Sneeker> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Sneeker(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          isFavourite:
              favouriteData == null ? false : favouriteData[prodId] ?? false,
          imageUrl: prodData['imageUrl'],
        ));
      });
      _sneekersData = loadedProducts;
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> addProduct(Sneeker sneaker) async {
    final String url =
        'https://shop-b2f64-default-rtdb.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': sneaker.title,
            'description': sneaker.description,
            'price': sneaker.price,
            'imageUrl': sneaker.imageUrl,
            'creatorId': userId,
          }));
      final newSneaker = Sneeker(
          id: json.decode(response.body)['name'],
          imageUrl: sneaker.imageUrl,
          title: sneaker.title,
          description: sneaker.description,
          price: sneaker.price);
      _sneekersData.add(newSneaker);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
