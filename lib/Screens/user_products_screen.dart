import 'package:flutter/material.dart';
import 'package:flutter_shop_app/Models/Sneaker_Provider.dart';
import 'package:flutter_shop_app/Screens/edit_product_screen.dart';
import 'package:flutter_shop_app/Widgets/drawer.dart';
import 'package:flutter_shop_app/Widgets/user_product.dart';
import 'package:provider/provider.dart';

class UserProducts extends StatelessWidget {
  static String id = 'UserProducts';

  Future<void> refresh(BuildContext context) async {
    return await Provider.of<Product>(context, listen: false)
        .fetchProduct(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, EditScreen.id);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: refresh(context),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => refresh(context),
                    child: Column(
                      children: [
                        Consumer<Product>(
                          builder: (context, products, _) => Expanded(
                              child: ListView.builder(
                                  itemCount: products.sneekersData.length,
                                  itemBuilder: (ctx, i) {
                                    return Column(
                                      children: [
                                        UserProduct(
                                          id: products.sneekersData[i].id,
                                          title: products.sneekersData[i].title,
                                          imageUrl:
                                              products.sneekersData[i].imageUrl,
                                        ),
                                        Divider(),
                                      ],
                                    );
                                  })),
                        )
                      ],
                    ),
                  ),
      ),
    );
  }
}
