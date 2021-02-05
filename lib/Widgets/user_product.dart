import 'package:flutter/material.dart';
import 'package:flutter_shop_app/Models/Sneaker_Provider.dart';
import 'package:flutter_shop_app/Screens/edit_product_screen.dart';
import 'package:provider/provider.dart';

class UserProduct extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String id;

  UserProduct({this.title, this.imageUrl, this.id});
  @override
  Widget build(BuildContext context) {
   final scaffold =  Scaffold.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, EditScreen.id, arguments: id);
                }),
            IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () async {
                  try {
                    await Provider.of<Product>(context, listen: false)
                        .deleteProduct(id);
                   scaffold.hideCurrentSnackBar();
                    scaffold.showSnackBar(
                      SnackBar(
                        content: Text('Product deleted'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }catch(e) {
                    scaffold.hideCurrentSnackBar();
                    scaffold.showSnackBar(
                      SnackBar(
                        content: Text('Product  not deleted'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }

                }),
          ],
        ),
      ),
    );
  }
}
