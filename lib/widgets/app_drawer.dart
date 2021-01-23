import 'package:Shop/provider/auth.dart';
import 'package:provider/provider.dart';
import '../screens/user_product_screen.dart';
import 'package:flutter/material.dart';
import '../screens/orders_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer( 
      child: Column(
        children: [
          AppBar(
            title: Text('SHOP EASE'),
            automaticallyImplyLeading: false,
          ),
          
          Consumer<Auth>(
                          builder: (context,notifier,child) => SwitchListTile(
                title: Text("Dark Mode"),
                onChanged: (val){
                   notifier.toggleTheme();
                },
                value: notifier.darkTheme,
              ),
            ),
            Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shop'),
            onTap: () => Navigator.of(context).pushReplacementNamed('/'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: (){Navigator.of(context)
                .pushReplacementNamed(OrdersScreen.routeName);
             
                } ,

          ),
           Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Products'),
            onTap: () { Navigator.of(context).pushReplacementNamed(UserProductScreen.routeName);
            }
          ),
           Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Log out'),
            onTap: () { 
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context,listen: false).logout();
            }
          ),
        ],
      ),
    );
  }
}
