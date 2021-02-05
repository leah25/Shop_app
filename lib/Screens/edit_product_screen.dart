import 'package:flutter/material.dart';
import 'package:flutter_shop_app/Models/Sneaker_Provider.dart';
import 'package:flutter_shop_app/Models/Sneeker.dart';
import 'package:flutter_shop_app/Screens/user_products_screen.dart';
import 'package:provider/provider.dart';

class EditScreen extends StatefulWidget {
  static String id = ' EditScreen';
  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _priceNode = FocusNode();
  final _descriptNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();

  var newProduct = Sneeker(
    id: null,
    imageUrl: '',
    description: '',
    price: 0,
    title: '',
  );

  final _form = GlobalKey<FormState>();
  var _initValue = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  //ensures initialization.
  var _init = true;
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies

    if (_init) {
      var selectedProductId =
          ModalRoute.of(context).settings.arguments as String;
      if (selectedProductId != null) {
        newProduct = Provider.of<Product>(context).getById(selectedProductId);
        _initValue = {
          'title': newProduct.title,
          'description': newProduct.description,
          'price': newProduct.price.toString(),
          'imageUrl': '',
        };
        _imageUrlController.text = newProduct.imageUrl;
      }
      _init = false;
      super.didChangeDependencies();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _priceNode.dispose();
    _descriptNode.dispose();
    _imageUrlController.dispose();

    _imageUrlFocusNode.removeListener(() {
      _updateImageUrl();
    });
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    if (_form.currentState.validate() == true) {
      _form.currentState.save();
      setState(() {
        _isLoading = true;
      });
      if (newProduct.id != null) {
        await Provider.of<Product>(context, listen: false)
            .updateProduct(newProduct.id, newProduct);
        setState(() {
          _isLoading = false;
        });
        Navigator.pop(context);
      } else {
        try {
          await Provider.of<Product>(context, listen: false)
              .addProduct(newProduct);
        } catch (_) {
          await showDialog(
              context: (context),
              builder: (context) {
                return AlertDialog(
                  title: Row(
                    children: [
                      Icon(Icons.warning, color: Theme.of(context).accentColor),
                      Text('Error'),
                    ],
                  ),
                  content: Text('Error Occurred, Something went wrong!'),
                  actions: [
                    FlatButton(
                      color: Theme.of(context).primaryColor,
                      child:
                          Text('Close', style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                );
              });
        } finally {
          setState(() {
            _isLoading = false;
          });
          Navigator.pushNamed(context, UserProducts.id);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Product'), actions: []),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Form(
                key: _form,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _initValue['title'],
                        decoration: InputDecoration(labelText: 'Title'),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'please write the product title';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          setState(() {
                            newProduct = Sneeker(
                              id: newProduct.id,
                              isFavourite: newProduct.isFavourite,
                              imageUrl: newProduct.imageUrl,
                              description: newProduct.description,
                              price: newProduct.price,
                              title: value,
                            );
                          });
                        },
                      ),
                      TextFormField(
                        initialValue: _initValue['price'],
                        decoration: InputDecoration(labelText: 'price'),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        focusNode: _priceNode,
                        validator: (value) {
                          if (value.isEmpty) {
                            return ' Please input Price';
                          } else if (double.tryParse(value) == null) {
                            return 'Please input a number for price';
                          } else if (double.parse(value) <= 0) {
                            return 'Please input price should be greater than 0';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          setState(() {
                            newProduct = Sneeker(
                              id: newProduct.id,
                              isFavourite: newProduct.isFavourite,
                              imageUrl: newProduct.imageUrl,
                              description: newProduct.description,
                              price: double.parse(value),
                              title: newProduct.title,
                            );
                          });
                        },
                      ),
                      TextFormField(
                        initialValue: _initValue['description'],
                        decoration: InputDecoration(labelText: 'Description'),
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptNode,
                        maxLines: 4,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please write description';
                          }
                          if (value.length < 10) {
                            return 'Description is too short ';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          setState(() {
                            newProduct = Sneeker(
                              id: newProduct.id,
                              isFavourite: newProduct.isFavourite,
                              imageUrl: newProduct.imageUrl,
                              description: value,
                              price: newProduct.price,
                              title: newProduct.title,
                            );
                          });
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 10.0, right: 10.0),
                            width: 100,
                            height: 100,
                            child: _imageUrlController.text.isEmpty
                                ? Text('Enter image link')
                                : FittedBox(
                                    child: Image.network(
                                      _imageUrlController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(width: 1.0, color: Colors.grey),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              //you can not have both initial value and controller
                              decoration:
                                  InputDecoration(labelText: 'Image URL'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              focusNode: _imageUrlFocusNode,
                              onFieldSubmitted: (_) {
                                _saveForm();
                                Scaffold.of(context).hideCurrentSnackBar();
                                Scaffold.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Product Updated'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'please input Image Url';
                                }
                                if (!value.startsWith('https') ||
                                    !value.startsWith("http")) {
                                  return 'Please enter a valid Image Url';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                setState(() {
                                  newProduct = Sneeker(
                                    id: newProduct.id,
                                    isFavourite: newProduct.isFavourite,
                                    imageUrl: value,
                                    description: newProduct.description,
                                    price: newProduct.price,
                                    title: newProduct.title,
                                  );
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      FlatButton(
                        minWidth: 250,
                        color: Theme.of(context).primaryColor,
                        child: Center(
                            child: Text(
                          'Save',
                          style: TextStyle(color: Colors.white, fontSize: 25.0),
                        )),
                        onPressed: _saveForm,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
