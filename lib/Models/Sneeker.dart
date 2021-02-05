import 'dart:convert';

import "package:flutter/material.dart";
import 'package:http/http.dart' as http;

class Sneeker with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Sneeker(
      {this.id,
      this.imageUrl,
      this.description,
      this.isFavourite = false,
      this.price,
      this.title});

//   void onFavouriteSelected(String authToken, String userId) async {
//     var currentStatus = !isFavourite;
//     final String url =
//         'https://shop-b2f64-default-rtdb.firebaseio.com/favorites/$userId/$id.json?auth=$authToken';
//     isFavourite = !isFavourite;
//     final response = await http.put(url, body: json.encode(isFavourite));
//     if (response.statusCode >= 400) {
//       currentStatus = isFavourite;
//       notifyListeners();
//     }
//     notifyListeners();
//   }
// }
  void _setFavValue(bool newValue) {
    isFavourite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String authToken, String userId) async {
    final oldStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    final url =
        'https://shop-b2f64-default-rtdb.firebaseio.com/favorites/$userId/$id.json?auth=$authToken';
    try {
      final response = await http.put(
        url,
        body: json.encode(
          isFavourite,
        ),
      );
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
}
