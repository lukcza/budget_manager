import 'package:budget_manager/pages/add_category/add_category_page.dart';
import 'package:budget_manager/pages/add_category/category_page.dart';
import 'package:budget_manager/pages/add_payment.dart';
import 'package:budget_manager/pages/home_page.dart';
import 'package:budget_manager/pages/recipt_scanner_page/ReciptScanner.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'services/database_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  int currentMonthId = await DatabseService.instance.ensureCurrentMonth();
  runApp(MyApp(
    currentMonthId: currentMonthId,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.currentMonthId}) : super(key: key);
  final int currentMonthId;
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
              path: '/',
              builder: (context, state) => HomePage(
                    currentMonthId: this.currentMonthId,
                  )),
          GoRoute(
              path: '/add_category/:',
              builder: (context, state) => AddCategoryPage(
                    currentMonthId: this.currentMonthId,
                  )),
          GoRoute(
              path: '/add_category/:categoryId/:categoryName',
              builder: (context, state) {
                final categoryTitle = state.pathParameters['categoryName'];
                final categoryId = state.pathParameters['categoryId'] as int;
                return  CategoryPage(categoryTitle: categoryTitle!, categoryId: categoryId,);
              }),
          GoRoute(
              path: '/add_payment', builder: (context, state) => AddPayment()),
          //GoRoute(path: '/stats', builder: (context,state)=>Stats()),
        ],
      ),
    );
  }
}
