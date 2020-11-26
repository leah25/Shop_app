import 'package:flutter/material.dart';
import 'package:flutter_shop_app/Models/Cart.dart';
import 'package:flutter_shop_app/Models/Sneeker.dart';
import 'package:flutter_shop_app/Screens/AboutSneaker.dart';
import 'package:provider/provider.dart';

class Sneaker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sneakerObject = Provider.of<Sneeker>(context);
    final cart = Provider.of<CartData>(context);

    // consumer <class> is  can also be used it is similar to provider. of  it takes bulder context, object and child
    //child is the widget that needs not to be rebuilt.
    //returns the widget to be be changed



    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, AboutSneaker.id,
                arguments: sneakerObject.id);
          },
          child: GridTile(
            child: Image.network(
              sneakerObject.imageUrl,
              fit: BoxFit.cover,
            ),
            footer: GridTileBar(
              backgroundColor: Colors.black54,
              title: Text(sneakerObject.title),
              leading: IconButton(
                  icon: Icon(
                    sneakerObject.isFavourite
                        ? Icons.favorite_sharp
                        : Icons.favorite_outline,
                    color: Theme.of(context).accentColor,
                  ),
                  onPressed: () {
                    sneakerObject.onFavouriteSelected();
                  }),
              trailing: IconButton(
                  icon: Icon(
                    Icons.add_shopping_cart,
                    color: Theme.of(context).accentColor,
                  ),
                  onPressed: () {
                    cart.addItem(sneakerObject.id, sneakerObject.title,
                        sneakerObject.price);
                  }),
            ),
          ),
        ),
      ),
    );
  }
}
