import 'package:flutter/material.dart';
import 'package:flutter_shop_app/Helpers/custom_route.dart';
import 'package:flutter_shop_app/Models/Cart.dart';
import 'package:flutter_shop_app/Models/Sneaker_Provider.dart';
import 'package:flutter_shop_app/Models/Sneeker.dart';
import 'package:flutter_shop_app/Models/auth.dart';
import 'package:flutter_shop_app/Models/orders.dart';
import 'package:flutter_shop_app/Screens/AboutSneaker.dart';
import 'package:flutter_shop_app/Screens/CartScreen.dart';
import 'package:flutter_shop_app/Screens/Products_available_Screen.dart';
import 'package:flutter_shop_app/Screens/SplashScreen.dart';
import 'package:flutter_shop_app/Screens/auth_screen.dart';
import 'package:flutter_shop_app/Screens/edit_product_screen.dart';
import 'package:flutter_shop_app/Screens/orders_screen.dart';
import 'package:flutter_shop_app/Screens/user_products_screen.dart';
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
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Product>(
          create: null,
          update: (context, auth, product) => Product(auth.token, auth.userId,
              product == null ? [] : product.sneekersData),
        ),
        ChangeNotifierProvider(
          create: (context) => CartData(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: null,
          update: (context, auth, order) => Orders(
              auth.token, auth.userId, order == null ? [] : order.orderData),
        ),
        ChangeNotifierProvider(
          create: (context) => Sneeker(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, authObject, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primaryColor: Colors.purple,
              accentColor: Colors.deepOrange,
              pageTransitionsTheme: PageTransitionsTheme(
                  builders: {TargetPlatform.android: CustomPageTransition()})),
          home: authObject.isAuth
              ? ProductsAvailable()
              : FutureBuilder(
                  future: authObject.retrieveStoredData(),
                  builder: (context, dataSnapshot) =>
                      dataSnapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen()),
          routes: {
            ProductsAvailable.id: (context) => ProductsAvailable(),
            AboutSneaker.id: (context) => AboutSneaker(),
            CartScreen.id: (context) => CartScreen(),
            OrderScreen.id: (context) => OrderScreen(),
            UserProducts.id: (context) => UserProducts(),
            EditScreen.id: (context) => EditScreen(),
          },
        ),
      ),
    );
  }
}
