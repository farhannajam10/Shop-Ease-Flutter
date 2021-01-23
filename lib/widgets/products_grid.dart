import '../provider/products_provider.dart';

import 'package:flutter/material.dart';
import './product_item.dart';
import 'package:provider/provider.dart';
class ProductsGrid extends StatelessWidget {
  final bool showFav;

  ProductsGrid(this.showFav);
 
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    final products=showFav?productsData.favouriteItems :productsData.items;
    return Expanded(
          child: GridView.builder(
        padding: EdgeInsets.all(5),
        itemCount: products.length,
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          value: products[i],
                child: ProductItem(
          ),
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