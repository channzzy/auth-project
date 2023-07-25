import 'package:auth_project/pages/auth_page.dart';
import 'package:auth_project/pages/home_page.dart';
import 'package:auth_project/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/products.dart';
import './pages/add_product_page.dart';
import './pages/edit_product_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => Authen(),
          ),
          ChangeNotifierProxyProvider<Authen, Products>(
            create: (context) => Products(),
            update: (context, auth, products) {
              return products!..updateData(auth.token, auth.userId);
            },
          )
        ],
        builder: (context, child) => Consumer<Authen>(
              builder: (context, auth, child) => MaterialApp(
                debugShowCheckedModeBanner: false,
                home: auth.isAuth ? HomePage() : LoginScreen(),
                routes: {
                  AddProductPage.route: (ctx) => AddProductPage(),
                  EditProductPage.route: (ctx) => EditProductPage(),
                },
              ),
            ));
  }
}
