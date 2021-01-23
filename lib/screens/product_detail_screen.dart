import '../provider/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = 'productDetailScreen';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProd = Provider.of<ProductsProvider>(context, listen: false)
        .findById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProd.title),
      ),
      body: SingleChildScrollView(
              child: Column(children: [
          Container(
            width: double.infinity,
            height: 300,
            child: Image.network(
              loadedProd.image,
              fit: BoxFit.cover,
            ),
          ),
          Padding(padding: EdgeInsets.all(10)),
          Text(
            'Rs ' + loadedProd.price.toString(),
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              
            ),
          ),
          SizedBox(height:10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
               loadedProd.desc,
              style: TextStyle(
                fontSize: 20, 
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
