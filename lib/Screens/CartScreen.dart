import 'package:flutter/material.dart';
import 'package:flutter_shop_app/Models/Cart.dart';
import 'package:flutter_shop_app/Widgets/Card.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static const id = "id";
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
                        '\$' + cartProvider.totalAmount.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  Text(
                    'ORDER NOW',
                    style: TextStyle(color: Theme.of(context).primaryColor),
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
