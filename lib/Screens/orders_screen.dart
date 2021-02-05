import 'package:flutter/material.dart';
import 'package:flutter_shop_app/Models/orders.dart';
import 'package:flutter_shop_app/Widgets/orders.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  static String id = ' OrderScreen';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var _init = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() async {
    // this method changes all the time the app reruns
    // TODO: implement didChangeDependencies
    if (_init) {
      setState(() {
        _isLoading = true;
      });

      await Provider.of<Orders>(context).fetchOrders();

      setState(() {
        _isLoading = false;
      });
    }
    _init = false;
    super.didChangeDependencies();
  }

  Widget build(BuildContext context) {
    final orderProvider = Provider.of<Orders>(context);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Center(
            child: Text(
              ' Your Orders',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Container(
                margin: EdgeInsets.all(10.0),
                height: 500,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                    itemCount: orderProvider.orderData.length,
                    itemBuilder: (context, int index) {
                      return Ordered(orderProvider.orderData[index]);
                    }),
              ));
  }
}
