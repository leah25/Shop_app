import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_shop_app/Models/orders.dart';
import 'package:intl/intl.dart';

class Ordered extends StatefulWidget {
  final OrderItem orderItem;
  Ordered(this.orderItem);

  @override
  _OrderedState createState() => _OrderedState();
}

class _OrderedState extends State<Ordered> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      child: Column(
        children: [
          ListTile(
            title: Text(
              '\$${widget.orderItem.amount.toStringAsFixed(2)}',
              style: TextStyle(
                  color: Theme.of(context).accentColor, fontSize: 30.0),
            ),
            subtitle: Text(
              DateFormat('dd MM yyy hh: mm').format(widget.orderItem.time),
            ),
            trailing: IconButton(
              icon: isExpanded
                  ? Icon(Icons.expand_more)
                  : Icon(Icons.expand_less),
              onPressed: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
            ),
          ),
          if (isExpanded == true)
            Container(
              height: min(widget.orderItem.orderList.length * 20.0 + 100, 180),
              margin: EdgeInsets.symmetric(horizontal: 12.0),
              child: ListView(
                children: widget.orderItem.orderList
                    .map((item) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(item.title,
                                style: TextStyle(
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.bold)),
                            Text(item.price.toStringAsFixed(2)),
                            Text('${item.quantity} x'),
                          ],
                        ))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}
