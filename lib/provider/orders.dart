import 'dart:convert';
import './cart.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final int amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
String authToken;
String userId;
  List<OrderItem> get orders {
    return [..._orders];
  }
  

  
 
Future<void> fetchAndGetOrders() async {
  final url = 'https://shop-ease-21af4.firebaseio.com/Orders/$userId.json?auth=$authToken';
  final response = await http.get(url);
   final extractedData = json.decode(response.body) as Map<String, dynamic>;
    final List<OrderItem> loadedProd = [];
    if(extractedData== null)
    {
      return;
    }
    extractedData.forEach((prodId, prodData) {
      loadedProd.add( OrderItem(
          id: prodId,
          amount: prodData['amount'],
          dateTime: DateTime.parse(prodData['dateTime']) ,
         products:(prodData['products'] as List<dynamic>).map((items) => CartItem(id: items['id'] ,title:items['title']  ,price: items['price'] ,quantity:items['quantity'] )).toList() ,
         ));
    }
    );
    _orders= loadedProd.reversed.toList();
    notifyListeners();
}
  Future<void> addOrder(List<CartItem> cartProducts, int amount) async {
    final url = 'https://shop-ease-21af4.firebaseio.com/Orders/$userId.json?auth=$authToken';
    final time=DateTime.now();
    final response= await http.post(url,
        body: json.encode({
          'amount': amount,
          'dateTime': time.toIso8601String(),
          'products': cartProducts
              .map(
                (cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'quantity': cp.quantity,
                  'price': cp.price
                },
              )
              .toList()
        }));
    _orders.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            amount: amount,
            dateTime: time,
            products: cartProducts));
    notifyListeners();
  }
   void update(String token,String orderId, List list) {
 authToken=token;
 userId= orderId;
 _orders=list;
  }
}
