import 'package:Shop/provider/products_provider.dart';
import 'package:Shop/screens/edit_user_product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String image;
  UserProductItem(this.id,this.title, this.image);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title,style:Theme.of(context).textTheme.bodyText1,),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(image),
      ),
      trailing: Container(
        width: 100,
        child: Row(children: [
          IconButton(
              icon: Icon(Icons.edit),
              onPressed: (){
                Navigator.of(context).pushNamed(EditUserProduct.routeName,arguments: id);

              },
              ),
          IconButton(
              icon: Icon(Icons.delete,color: Colors.red,),
              onPressed: (){
                Provider.of<ProductsProvider>(context).removeProd(id);
              },
              )
        ]),
      ),
    );
  }
}
 