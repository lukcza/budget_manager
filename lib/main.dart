import 'package:budget_manager/models/month.dart';
import 'package:budget_manager/pages/add_payment.dart';
import 'package:budget_manager/pages/category/add_category_page.dart';
import 'package:budget_manager/pages/category/category_page.dart';
import 'package:budget_manager/pages/home/home_page_new.dart';
import 'package:budget_manager/pages/home_page.dart';
import 'package:budget_manager/pages/month_page/month_page.dart';
import 'package:budget_manager/pages/month_template/new_month_budget_update_page.dart';
import 'package:budget_manager/pages/month_template/new_month_category_page.dart';
import 'package:budget_manager/pages/month_template/new_month_options_page.dart';
import 'package:budget_manager/pages/receipt_scanner_page/ReceiptScanner.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'services/database_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final currentMonthData = await Month.ensureCurrentMonth();
  int currentMonthId = currentMonthData['newMonthId'];
  bool isNewMonthExist = currentMonthData['isNewMonthExist'];
  runApp(MyApp(
    currentMonthId: currentMonthId,
    isNewMonthExist: isNewMonthExist,
  ));
}

class MyApp extends StatelessWidget {
  MyApp(
      {super.key, required this.currentMonthId, required this.isNewMonthExist});

  final int currentMonthId;
  final bool isNewMonthExist;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: GoRouter(
        initialLocation: isNewMonthExist ? '/' : '/',
        routes: [
          GoRoute(
              path: '/',
              builder: (context, state) => HomePageNew(
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
          GoRoute(
              path: '/receipt_scanner',
              builder: (context, state) => ReceiptScanner()),
          GoRoute(
              path: '/new_month',
              builder: (context, state) => NewMonthBudgetUpdatePage(
                    currentMonthId: currentMonthId,
                  )),
          GoRoute(
              path: '/new_categories',
              builder: (context, state) =>
                  NewMonthCategoryPage(currentMonthId: currentMonthId)),
          GoRoute(
              path: '/new_options',
              builder: (context, state) =>
                  NewMonthOptionsPage(currentMonthId: currentMonthId))
          //GoRoute(path: '/stats', builder: (context,state)=>Stats()),
        ],
      ),
    );
  }
}
