import 'dart:math';

import 'package:flutter/material.dart';
import '../provider/orders.dart';
import 'package:intl/intl.dart';

class OrderItems extends StatefulWidget {
  final OrderItem order;

  OrderItems(this.order);

  @override
  _OrderItemsState createState() => _OrderItemsState();
}

class _OrderItemsState extends State<OrderItems> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(children: [
        ListTile(
          title: Text('Rs ' + widget.order.amount.toString()),
          subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime)),
          trailing: IconButton(
            icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
            onPressed: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
          ),
        ),
        if (_expanded)
          Container(padding: EdgeInsets.symmetric(horizontal:15,vertical:4),
            height: min(widget.order.products.length * 20.0 + 10, 100),
            child: ListView(
              children: widget.order.products
                  .map(
                    (prod) => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          prod.title,
                           style:Theme.of(context).textTheme.bodyText1,),
                        Text(
                          prod.quantity.toString() +
                              'x ' +
                              'Rs' +
                              prod.price.toString(),
                          style:Theme.of(context).textTheme.bodyText1,
                        )
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
      ]),
    );
  }
}
