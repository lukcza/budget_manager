import 'package:budget_manager/pages/add_category/add_category_page.dart';
import 'package:budget_manager/pages/add_category/add_option_page.dart';
import 'package:budget_manager/pages/add_payment.dart';
import 'package:budget_manager/pages/home_page.dart';
import 'package:budget_manager/pages/recipt_scanner_page/ReciptScanner.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
void main() {
  runApp(const MyApp());
}
final _router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context,state)=>Reciptscanner()),
      GoRoute(path: '/add_category', builder: (context,state)=>AddCategoryPage()),
      GoRoute(path: '/add_payment', builder: (context,state)=>AddPayment()),
//GoRoute(path: '/stats', builder: (context,state)=>Stats()),
    ],
);
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}

