import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String desc;
  final int price;
  final String image;
  bool isFavourite;


  Product(
      {@required this.id,
      @required this.title,
      @required this.desc,
      this.isFavourite = false,
      @required this.image,
      @required this.price});

  void toggleFavorite(String token, String userId) {
    isFavourite = !isFavourite;
    final url = 'https://shop-ease-21af4.firebaseio.com/userFavourite/$userId/$id.json?auth=$token';
    http.put(
      url,
      body: json.encode(isFavourite),
    );
    notifyListeners();
  }

}
