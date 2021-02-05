import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_shop_app/Models/Cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;

  final DateTime time;
  final List<CartItem> orderList;

  OrderItem({this.id, this.amount, this.time, this.orderList});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orderData = [];

  List<OrderItem> get orderData {
    return [..._orderData];
  }
  final authToken;
  final userId;
  Orders(this.authToken, this.userId,this._orderData);

  Future<void> fetchOrders() async {
    final String url =
        'https://shop-b2f64-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    final response = await http.get(url);
    var responseData = json.decode(response.body) as Map<String, dynamic>;
    if (responseData == null) {
      return;
    }
    List<OrderItem> orderFromFirebase = [];
    responseData.forEach((orderId, orderValue) {
      orderFromFirebase.add(OrderItem(
          id: orderId,
          amount: orderValue['amount'],
          time: DateTime.parse(orderValue['time']),
          orderList: (orderValue['listOfOrders'] as List<dynamic>)
              .map((item) => CartItem(
                  id: item['id'],
                  title: item['title'],
                  price: item['price'],
                  quantity: item['quantity']))
              .toList()));
    });
    _orderData = orderFromFirebase;
    notifyListeners();
  }

  Future<void> addOrders(List<CartItem> cartItems, double total) async {
    final currentTime = DateTime.now();
    final String url =
        'https://shop-b2f64-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'time': currentTime.toIso8601String(),
          'listOfOrders': cartItems
              .map((prod) => {
                    'id': prod.id,
                    'title': prod.title,
                    'price': prod.price,
                    'quantity': prod.quantity
                  })
              .toList()
        }));
    _orderData.insert(
      0,
      OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          time: currentTime,
          orderList: cartItems),
    );
    notifyListeners();
  }
}
