import 'package:flutter/material.dart';
import 'package:flutter_shop_app/Models/Sneeker.dart';

class Product with ChangeNotifier {
  List<Sneeker> _sneekersData = [
    Sneeker(
        id: 'S1',
        imageUrl: "https://picsum.photos/250?image=5",
        description:
            "Sneaker shoelaces rarely look as good as when they are adorning your athletic kicks. These sport-centric sneakers are Nike and Adidas regulars and are the perfect blend of functionality and style. Any activity faster than walking, and you’ll want to slip on a pair of these.",
        price: 45.09,
        title: "Athletics Kicks"),
    Sneeker(
        id: 'S2',
        imageUrl: "https://picsum.photos/250?image=7",
        description:
            "These types of sneakers are super famous, and happen to be the most common of the bunch. Also called Low Top Sneakers, they stop just below the ankle and are best worn with secret socks and skinny jeans, or jeans rolled to reveal your naked ankle. Don’t wear high socks with these!",
        price: 75.19,
        title: "Plimsoll sneakers"),
    Sneeker(
        id: 'S3',
        imageUrl: "https://picsum.photos/250?image=2",
        description:
            "Your high top sneakers have two excellent advantages – the first is that you can wear long socks and no-one will see them, the second is that they always look cool. These match especially well with the tight fitting jeans of today, even though they became famous on the basketball court.",
        price: 95.60,
        title: "Basketball Sneakers"),
    Sneeker(
        id: 'S4',
        imageUrl: "https://picsum.photos/250?image=1",
        description:
            "Technically these sneakers are Vans, but they are an institution so they get on the list. We make the rules. These types of sneakers can be worn with anything, casual or formal, which makes them revolutionary. Clean, understated design means you’ll always look your best in these Authentics.",
        price: 45.09,
        title: "Authentic Sneakers"),
    Sneeker(
        id: 'S5',
        imageUrl: "https://picsum.photos/250?image=8",
        description:
            "Ah, the classic slip-on sneaker that has absolutely no shoelaces at all. These smooth top sneakers are making a comeback in metallic and interesting patterns, and are great for easy-wear. In fact, they ooze casual, so like plimsoll sneakers, don’t wear them with high socks. That’s not cool.",
        price: 75.00,
        title: "Slip On Sneakers"),
    Sneeker(
        id: 'S5',
        imageUrl: "https://picsum.photos/250?image=6",
        description:
            "Ah, the classic slip-on sneaker that has absolutely no shoelaces at all. These smooth top sneakers are making a comeback in metallic and interesting patterns, and are great for easy-wear. In fact, they ooze casual, so like plimsoll sneakers, don’t wear them with high socks. That’s not cool.",
        price: 75.00,
        title: "Slip On Sneakers"),
  ];

  List<Sneeker> get sneekersData {
    return [..._sneekersData];
  }

  List<Sneeker> get favouriteSneeker {
    return _sneekersData.where((object) => object.isFavourite).toList();
  }

  Sneeker getById(String id) {
    return _sneekersData.firstWhere((prod) => (prod.id == id));
  }

  void addProduct() {
    notifyListeners();
  }
}
