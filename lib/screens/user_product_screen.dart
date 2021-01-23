

import 'package:async/async.dart';

import './edit_user_product.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/products_provider.dart';

class UserProductScreen extends StatefulWidget {
  static const routeName = 'userProducts';

  @override
  _UserProductScreenState createState() => _UserProductScreenState();
}

class _UserProductScreenState extends State<UserProductScreen> {
  final AsyncMemoizer _memoizer = AsyncMemoizer();
  Future<void> _refreshList(BuildContext context) async {
    return this._memoizer.runOnce(() async {
    await Future.delayed(Duration(seconds: 2));
    await Provider.of<ProductsProvider>(context).fetchAndGetProd(true);
  });
  }

  @override
  Widget build(BuildContext context) {
    //final productData = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditUserProduct.routeName);
              }),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshList(context),
        builder: (context, snapshot) =>  snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshList(context),
                    child: Consumer<ProductsProvider>(
                                          builder:(context,productData,_)=> Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                            itemCount: productData.items.length,
                            itemBuilder: (context, i) {
                              return Column(
                                children: [
                                  UserProductItem(
                                      productData.items[i].id,
                                      productData.items[i].title,
                                      productData.items[i].image),
                                  Divider(),
                                ],
                              );
                            }),
                      ),
                    ),
                  ),
      ),
    );
  }
}
