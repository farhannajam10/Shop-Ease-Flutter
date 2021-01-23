import 'package:Shop/provider/product.dart';
import 'package:Shop/provider/products_provider.dart';
import 'package:Shop/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchProducts extends SearchDelegate<Product> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return null;
  }

  @override
  Widget buildLeading(BuildContext context) {
     return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    final products = query.isEmpty
        ? productsData.items
        : productsData.items
            .where((element) => element.title.startsWith(query))
            .toList();
    return products.isEmpty ?Center(child: Text("No Record Found...")):Expanded(
      child: GridView.builder(
        padding: EdgeInsets.all(5),
        itemCount: products.length,
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          value: products[i],
          child: ProductItem(),
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2 / 2,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    final products = query.isEmpty
        ? productsData.items
        : productsData.items
            .where((element) => element.title.startsWith(query))
            .toList();
    return products.isEmpty ?Center(child: Text("No Record Found...")):Expanded(
      child: GridView.builder(
        padding: EdgeInsets.all(5),
        itemCount: products.length,
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          value: products[i],
          child: ProductItem(),
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2 / 2,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5),
      ),
    );
  }
}
