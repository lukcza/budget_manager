import 'package:budget_manager/models/category.dart';
import 'package:budget_manager/models/enum/page_index.dart';
import 'package:budget_manager/pages/home/home_budget_view.dart';
import 'package:budget_manager/widgets/custom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/month.dart';
import '../../models/option.dart';
import '../../models/payment.dart';
import 'home_category_view.dart';
import 'home_payments_view.dart';

class HomePageNew extends StatefulWidget {
  HomePageNew({super.key, required this.currentMonthId});

  final int currentMonthId;

  @override
  State<HomePageNew> createState() => _HomePageNewState();
}
class _HomePageNewState extends State<HomePageNew> {
  List<DropdownMenuEntry<int>> listOfPaymentsTimeRange = const [
    DropdownMenuEntry(value: 0, label: "Ostatnie"),
    DropdownMenuEntry(value: 1, label: "Wczorajsze"),
    DropdownMenuEntry(value: 2, label: "Tydzień temu"),
  ];
  late int viewIndex = 0;
  late final selectedTimeRange;
  Month? currentMonth;
  Category? category;
  Option? option;
  Payment? payment;
  PageIndex? pageIndex;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageIndex = PageIndex.home;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Miesiąc 2025"),
        actions: [
          IconButton(onPressed: () => {}, icon: Icon(Icons.help_outline))
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      viewIndex = 0;
                    });
                  },
                  child: Text("Budżet"),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      viewIndex = 1;
                    });
                  },
                  child: Text("Kategorie"),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      viewIndex = 2;
                    });
                  },
                  child: Text("Płatności"),
                ),
              ],
            ),
            Expanded(
              child: Builder(
                builder: (context) {
                  switch (viewIndex) {
                    case 0:
                      return HomeBudgetView(
                          currentMonthId: widget.currentMonthId);
                    case 1:
                      return HomeCategoryView(currentMonthId: widget.currentMonthId);
                    case 2:
                      return HomePaymentsView(
                          currentMonth: widget.currentMonthId);
                    default:
                      return HomePaymentsView(
                          currentMonth: widget.currentMonthId);
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavBar(index: pageIndex!)
    );
  }
}
