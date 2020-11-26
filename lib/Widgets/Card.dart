import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final String id;
  final double price;
  final String name;
  final double total;
  final int quantity;
  CardWidget({this.id, this.price, this.name, this.total, this.quantity});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 15.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                child: Text('\$$price'),
              ),
              title: Text(name),
              subtitle: Text('Total: \$' + total.toString()),
              trailing: Text(quantity.toString() + "x"),
            ),
          ),
        ],
      ),
    );
  }
}
