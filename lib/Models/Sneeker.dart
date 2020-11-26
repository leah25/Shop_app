import "package:flutter/material.dart";

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

  void onFavouriteSelected() {
    isFavourite = !isFavourite;
    notifyListeners();
  }
}
