import 'package:flutter/material.dart';
import 'package:flutter_shop_app/Models/Cart.dart';
import 'package:flutter_shop_app/Models/Sneaker_Provider.dart';
import 'package:flutter_shop_app/Screens/AboutSneaker.dart';
import 'package:flutter_shop_app/Screens/Products_available_Screen.dart';
import 'package:flutter_shop_app/Screens/CartScreen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Product(),
        ),
        ChangeNotifierProvider(
          create: (context) => CartData(),
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Colors.purple,
            accentColor: Colors.deepOrange,
          ),
          home: ProductsAvailable(),
          routes: {
            AboutSneaker.id: (context) => AboutSneaker(),
            CartScreen.id: (context)=> CartScreen(),

          }),
    );
  }
}
