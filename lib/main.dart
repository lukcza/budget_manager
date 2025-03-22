import 'package:budget_manager/models/month.dart';
import 'package:budget_manager/pages/add_category/add_category_page.dart';
import 'package:budget_manager/pages/add_category/category_page.dart';
import 'package:budget_manager/pages/add_payment.dart';
import 'package:budget_manager/pages/home_page.dart';
import 'package:budget_manager/pages/month_page/month_page.dart';
import 'package:budget_manager/pages/receipt_scanner_page/ReceiptScanner.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'services/database_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  int currentMonthId = await Month.ensureCurrentMonth();
  runApp(MyApp(
    currentMonthId: currentMonthId,
  ));
}

class MyApp extends StatelessWidget {
  MyApp({super.key, required this.currentMonthId});
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
              path: '/add_category',
              builder: (context, state) => AddCategoryPage(
                    currentMonthId: this.currentMonthId,
                  )),
          GoRoute(
              path: '/add_option/:categoryId/:categoryName',
              builder: (context, state) {
                final categoryTitle = state.pathParameters['categoryName'];
                final categoryId =
                    int.parse(state.pathParameters['categoryId']!);
                return CategoryPage(
                  categoryTitle: categoryTitle!,
                  categoryId: categoryId,
                );
              }),
          GoRoute(
              path: '/add_payment',
              builder: (context, state) => AddPayment(
                    currentMonthId: currentMonthId,
                  )),
          GoRoute(
              path: '/month_page',
              builder: (context, state) => MonthPage(
                    currentMonthId: currentMonthId,
                  )),
          GoRoute(path: '/receipt_scanner',builder: (context,state) =>ReceiptScanner())
          //GoRoute(path: '/stats', builder: (context,state)=>Stats()),
        ],
      ),
    );
  }
}
