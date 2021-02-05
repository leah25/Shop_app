import 'package:flutter/material.dart';
import 'package:flutter_shop_app/Models/Cart.dart';
import 'package:flutter_shop_app/Models/orders.dart';
import 'package:flutter_shop_app/Widgets/Card.dart';
import 'package:provider/provider.dart';

import 'orders_screen.dart';

class CartScreen extends StatefulWidget {
  static const id = "id";

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartData>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart Items'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15.0),
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    ' Total',
                    style:
                        TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                  ),
                  Chip(
                    label: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '\$' + cartProvider.totalAmount.toStringAsFixed(2),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  FlatButton(
                    child: _isLoading
                        ? Text(
                            'Loading...',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          )
                        : Text(
                            'CONFIRM ORDER',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ),
                    onPressed: (cartProvider.totalAmount <= 0 || _isLoading)
                        ? null
                        : () async {
                            setState(() {
                              _isLoading = true;
                            });
                            await Provider.of<Orders>(context, listen: false)
                                .addOrders(cartProvider.items.values.toList(),
                                    cartProvider.totalAmount);
                            cartProvider.clear();
                            setState(() {
                              _isLoading = false;
                            });

                            Navigator.pushNamed(
                              context,
                              OrderScreen.id,
                            );
                          },
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
                itemCount: cartProvider.items.length,
                itemBuilder: (context, int index) {
                  return CardWidget(
                    id: cartProvider.items.values.toList()[index].id,
                    productId: cartProvider.items.keys.toList()[index],
                    price: cartProvider.items.values.toList()[index].price,
                    quantity:
                        cartProvider.items.values.toList()[index].quantity,
                    name: cartProvider.items.values.toList()[index].title,
                    total: (cartProvider.items.values.toList()[index].price *
                        cartProvider.items.values.toList()[index].quantity),
                  );
                }),
          )
        ],
      ),
    );
  }
}
