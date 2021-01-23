import 'dart:convert';

import './product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductsProvider with ChangeNotifier {
  String authToken ;
  String userID;
 
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }
  List<Product> get favouriteItems {
    return _items.where((prod) => prod.isFavourite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }
void update(String token, String userId,List list) {
 authToken=token;
 _items=list;
userID=userId;
  }
  Future<void> fetchAndGetProd([bool filterByUser=false]) async {
    final filterString= filterByUser ? 'orderBy="creatorId"&equalTo="$userID"' : '';
    var url = 'https://shop-ease-21af4.firebaseio.com/products.json?auth=$authToken&$filterString';
    final response = await http.get(url);
    
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if(extractedData== null)
    {
      return;
    }
    url = 'https://shop-ease-21af4.firebaseio.com/userFavourite/$userID.json?auth=$authToken';
    final responseFav=await http.get(url);
    final favData= json.decode(responseFav.body);
    final List<Product> loadedProd = [];
    extractedData.forEach((prodId, prodData) {
      loadedProd.add(Product(
          id: prodId,
          title: prodData['title'],
          image: prodData['image'],
          price: prodData['price'],
          isFavourite: favData== null ? false : favData[prodId] ?? false ,
          desc: prodData['desc']));
    });
    _items = loadedProd;
    notifyListeners();
  }

  Future<void> addProduct(Product product) {
    final url = 'https://shop-ease-21af4.firebaseio.com/products.json?auth=$authToken"';
    return http
        .post(url,
            body: jsonEncode({
              'title': product.title,
              'desc': product.desc,
              'image': product.image,
              'price': product.price,
              'creatorId': userID,
            }))
        .then((response) { 
      final newProduct = Product(
          title: product.title,
          price: product.price,
          id: json.decode(response.body)['name'],
          desc: product.desc,
          image: product.image);
      _items.add(newProduct);

      notifyListeners();
    });
  }

  void updateProd(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = 'https://shop-ease-21af4.firebaseio.com/products/$id.json?auth=$authToken';
     await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'desc': newProduct.desc,
            'price': newProduct.price,
            'image': newProduct.image,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    }
  }

  void removeProd(String id) {
    final url = 'https://shop-ease-21af4.firebaseio.com/products/$id.json?auth=$authToken';
    http.delete(url);
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }

  
}

