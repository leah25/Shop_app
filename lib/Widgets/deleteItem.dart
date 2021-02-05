import 'package:flutter/material.dart';

class DeleteSneaker extends StatefulWidget {
  @override
  _DeleteSneakerState createState() => _DeleteSneakerState();
}

class _DeleteSneakerState extends State<DeleteSneaker> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Delete',
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
      elevation: 10.0,
      backgroundColor: Colors.white,
      content: Text(
        'Are You Sure You Want to Delete Product',
        style: TextStyle(fontSize: 20.0, color: Colors.black),
      ),
      actions: [
        FlatButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: Text(
            'Yes',
            style: TextStyle(color: Colors.white),
          ),
          color: Theme.of(context).primaryColor,
        ),
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text(
            'No',
            style: TextStyle(color: Colors.white),
          ),
          color: Theme.of(context).accentColor,
        ),
      ],
    );
  }
}
