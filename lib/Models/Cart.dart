import 'package:flutter/material.dart';

class CartItem {
  final String id;

  final String title;
  final double price;
  final int quantity;

  CartItem({this.id, this.title, this.price, this.quantity});
}

class CartData with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get totalCartItems {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.quantity * cartItem.price;
      // notifyListeners();
    });
    return total;
  }

  void addItem(
    String sneakerId,
    String sneakerTitle,
    double sneakerPrice,
  ) {
    //if its already added to the cart at least once
    if (_items.containsKey(sneakerId)) {
      _items.update(
          sneakerId,
          (existingItem) => CartItem(
              id: existingItem.id,
              title: existingItem.title,
              price: existingItem.price,
              quantity: existingItem.quantity + 1));
    } else {
      // if item is not added at all
      _items.putIfAbsent(
          sneakerId,
          () => CartItem(
              id: DateTime.now().millisecond.toString(),
              title: sneakerTitle,
              price: sneakerPrice,
              quantity: 1));
    }
    notifyListeners();
  }

  void deleteItem(String sneakerId) {
    _items.remove(sneakerId);
    notifyListeners();
  }

  void deleteSingleItem(String sneakerId) {
    if (!_items.containsKey(sneakerId)) {
      return;
    }
    if (_items[sneakerId].quantity > 1) {
      _items.update(sneakerId, (availableItem) {
        return CartItem(
          id: availableItem.id,
          title: availableItem.title,
          price: availableItem.price,
          quantity: availableItem.quantity - 1,
        );
      });
    } else {
      _items.remove(sneakerId);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
