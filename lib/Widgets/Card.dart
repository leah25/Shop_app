import 'package:flutter/material.dart';
import 'package:flutter_shop_app/Models/Cart.dart';
import 'package:provider/provider.dart';

import 'deleteItem.dart';

class CardWidget extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final String name;
  final double total;
  final int quantity;
  CardWidget(
      {this.id,
      this.price,
      this.name,
      this.total,
      this.quantity,
      this.productId});
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.startToEnd,
      background: Container(
        color: Colors.red,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 38.0),
          child: Icon(Icons.delete, color: Colors.white, size: 40.0),
        ),
        alignment: Alignment.centerLeft,
      ),
      onDismissed: (direction) {
        Provider.of<CartData>(context, listen: false).deleteItem(productId);
      },
      confirmDismiss: (direction) async {
        final result = await showDialog(
          context: context,
          builder: (_) => DeleteSneaker(),
        );
        return result;
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 15.0),
        child: Row(
          children: [
            Container(
              width: 300,
              child: ListTile(
                leading: CircleAvatar(
                  radius: 30.0,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: FittedBox(child: Text('\$$price')),
                  ),
                ),
                title: Text(name),
                subtitle: Text('Total: \$' + total.toString()),
                trailing: Text(quantity.toString() + "x"),
              ),
              //SizedBox(width:10.0),
            ),
          ],
        ),
      ),
    );
  }
}
