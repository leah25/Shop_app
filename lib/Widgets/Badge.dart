import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  final Widget child;
  final String value;
  final Color colour;

  Badge({this.child, this.value, this.colour});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned(
          right: 8.0,
          left: 18.0,
          top: 5.0,
          child: Container(
            padding: EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Theme.of(context).accentColor,
            ),
            constraints: BoxConstraints(minWidth: 16.0, minHeight: 16.0),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15.0),
            ),
          ),
        ),
      ],
    );
  }
}
