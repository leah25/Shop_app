import 'package:flutter/material.dart';
import 'package:flutter_shop_app/Models/Cart.dart';
import 'package:flutter_shop_app/Models/Sneaker_Provider.dart';
import 'package:flutter_shop_app/Screens/CartScreen.dart';
import 'package:flutter_shop_app/Widgets/Badge.dart';
import 'package:flutter_shop_app/Widgets/Sneaker.dart';
import 'package:flutter_shop_app/Widgets/drawer.dart';
import 'package:provider/provider.dart';

//enum ItemValues { favourites, all }

// enums are representing integers in words

class ProductsAvailable extends StatefulWidget {
  static String id = 'Products';
  @override
  _ProductsAvailableState createState() => _ProductsAvailableState();
}

class _ProductsAvailableState extends State<ProductsAvailable> {
  bool isItemFav = false;
  bool _init = true;
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // the .of context does not work in init state
  }

  @override
  void didChangeDependencies() {
    if (_init) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Product>(context).fetchProduct().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _init = false;
    super.didChangeDependencies();
  }

  Future<void> refresh() async {
    return await Provider.of<Product>(context, listen: false).fetchProduct(true);
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartData>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ' Sneakers Online Shop',
          textAlign: TextAlign.center,
        ),
        actions: [
          PopupMenuButton(
              onSelected: (int selectedItem) {
                setState(() {
                  if (selectedItem == 0) {
                    isItemFav = true;
                  } else {
                    isItemFav = false;
                  }
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (
                context,
              ) =>
                  [
                    PopupMenuItem(child: Text('Favourite Items'), value: 0),
                    PopupMenuItem(child: Text('All Items'), value: 1),
                  ]),
          Badge(
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.pushNamed(context, CartScreen.id);
              },
            ),
            value: cart.totalCartItems.toString(),
            colour: Theme.of(context).accentColor,
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(onRefresh: refresh, child: BuildGrid(isItemFav)),
    );
  }
}

class BuildGrid extends StatelessWidget {
  final bool favItem;
  BuildGrid(this.favItem);

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Product>(context);
    final sneakerList =
        favItem ? productData.favouriteSneeker : productData.sneekersData;

    return GridView.builder(
        itemCount: sneakerList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 2 / 3),
        itemBuilder: (context, index) {
          // changenotifier.value is more effecicient to be used in lists /grid views  insteadd of create or builder
          return ChangeNotifierProvider.value(
              value: sneakerList[index], child: Sneaker());
        });
  }
}
