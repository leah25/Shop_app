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
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 300,
                width: double.infinity,
                child: Image.network(
                  productId.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  '\$${productId.price}',
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  '${productId.description}',
                  style: TextStyle(color: Colors.black, fontSize: 18.0),
                ),
              ),
            ]),
      ),
    );
  }
}
