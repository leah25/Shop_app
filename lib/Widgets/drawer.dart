import 'package:flutter/material.dart';
import 'package:flutter_shop_app/Models/auth.dart';
import 'package:flutter_shop_app/Screens/Products_available_Screen.dart';
import 'package:flutter_shop_app/Screens/orders_screen.dart';
import 'package:flutter_shop_app/Screens/user_products_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_shop_app/Helpers/custom_route.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Shop App'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text(' Shop'),
            onTap: () {
              Navigator.pushNamed(context, ProductsAvailable.id);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text(' Orders'),
            onTap: () {
              Navigator.pushNamed(context, OrderScreen.id);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text(' Manage Products'),
            onTap: () {
              Navigator.pushNamed(context, UserProducts.id);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text(' Logout'),
            onTap: () {
              Provider.of<Auth>(context,listen: false).logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
    );
  }
}
