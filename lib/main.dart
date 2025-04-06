import 'package:budget_manager/models/month.dart';
import 'package:budget_manager/pages/add_payment.dart';
import 'package:budget_manager/pages/category/add_category_page.dart';
import 'package:budget_manager/pages/category/category_page.dart';
import 'package:budget_manager/pages/home/home_page_new.dart';
import 'package:budget_manager/pages/month_page/month_page.dart';
import 'package:budget_manager/pages/month_template/new_month_budget_update_page.dart';
import 'package:budget_manager/pages/month_template/new_month_category_page.dart';
import 'package:budget_manager/pages/month_template/new_month_options_page.dart';
import 'package:budget_manager/pages/month_template/new_month_summary_page.dart';
import 'package:budget_manager/pages/receipt_scanner_page/ReceiptScanner.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
      debugShowCheckedModeBanner: false,
      routerConfig: GoRouter(
        initialLocation: isNewMonthExist ? '/new_month' : '/',
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: HomePageNew(
                currentMonthId: this.currentMonthId,
              ),
            ),
          ),
          GoRoute(
            path: '/add_category',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: AddCategoryPage(
                currentMonthId: this.currentMonthId,
              ),
            ),
          ),
          GoRoute(
            path: '/add_option/:categoryId/:categoryName',
            pageBuilder: (context, state) {
              final categoryTitle = state.pathParameters['categoryName'];
              final categoryId = int.parse(state.pathParameters['categoryId']!);
              return NoTransitionPage(
                key: state.pageKey,
                child: CategoryPage(
                  categoryTitle: categoryTitle!,
                  categoryId: categoryId,
                ),
              );
            },
          ),
          GoRoute(
            path: '/add_payment',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: AddPayment(
                currentMonthId: currentMonthId,
              ),
            ),
          ),
          GoRoute(
            path: '/month_page',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: MonthPage(
                currentMonthId: currentMonthId,
              ),
            ),
          ),
          GoRoute(
            path: '/receipt_scanner',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: ReceiptScanner(),
            ),
          ),
          GoRoute(
            path: '/new_month',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: NewMonthBudgetUpdatePage(
                currentMonthId: currentMonthId,
              ),
            ),
          ),
          GoRoute(
            path: '/new_categories',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: NewMonthCategoryPage(
                currentMonthId: currentMonthId,
              ),
            ),
          ),
          GoRoute(
            path: '/new_options',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: NewMonthOptionsPage(
                currentMonthId: currentMonthId,
              ),
            ),
          ),
          GoRoute(
            path: '/new_summary',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: NewMonthSummaryPage(
                currentMonthId: currentMonthId,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
