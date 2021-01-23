import '../provider/orders.dart';
import '../widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = 'orders';
  
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _isLoading= false;

  @override
  void initState() {
    
    Future.delayed(Duration.zero).then((_)async {
      setState(() {
      _isLoading=true;
    });
     await Provider.of<Orders>(context, listen: false).fetchAndGetOrders();
setState(() {
      _isLoading=false;
    });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        drawer: AppDrawer(),
        body: _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
            itemBuilder: (ctx, i) {
              return OrderItems(ordersData.orders[i]);
            },
            itemCount: ordersData.orders.length));
  }
}
