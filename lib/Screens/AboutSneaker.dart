import 'package:flutter/material.dart';
import 'package:flutter_shop_app/Models/Sneaker_Provider.dart';
import 'package:provider/provider.dart';

class AboutSneaker extends StatelessWidget {
  static String id = "AboutSneaker";

  @override
  Widget build(BuildContext context) {
    final sneakerArgumentsId =
        ModalRoute.of(context).settings.arguments as String;
    
    final productId = Provider.of<Product>(context).getById(sneakerArgumentsId);

    return Scaffold(
      appBar: AppBar(
        title: Text(productId.title),
      ),
    );
  }
}
