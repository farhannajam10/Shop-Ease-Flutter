import 'package:Shop/provider/auth.dart';
import 'package:Shop/screens/auth_screen.dart';
import 'package:Shop/screens/splash_screen.dart';
import 'package:flutter/services.dart';
import './screens/edit_user_product.dart';
import './screens/user_product_screen.dart';
import './provider/cart.dart';
import './screens/product_detail_screen.dart';
import './screens/products_overview_Screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './provider/orders.dart';
import './provider/products_provider.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductsProvider>(
          create: (_) => ProductsProvider(),
          update: (context, auth, data) => data
            ..update(auth.token, auth.userId, data == null ? [] : data.items),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => Orders(),
          update: (context, auth, data) => data
            ..update(auth.token, auth.userId, data == null ? [] : data.orders),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Shop Ease',
          theme: auth.darkTheme ? dark : light,
          home: auth.isAuth
              ? ProductOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductScreen.routeName: (ctx) => UserProductScreen(),
            EditUserProduct.routeName: (ctx) => EditUserProduct()
          },
        ),
      ),
    );
  }
}
