import 'package:budget_manager/models/category.dart';
import 'package:flutter/material.dart';

import '../../models/month.dart';
import '../../models/option.dart';
import '../../models/payment.dart';
import 'home_payments_view.dart';

class HomePageNew extends StatefulWidget {
   HomePageNew({super.key, required this.currentMonthId});
  final int currentMonthId;
  @override
  State<HomePageNew> createState() => _HomePageNewState();
}

class _HomePageNewState extends State<HomePageNew> {
  List<DropdownMenuEntry<int>> listOfPaymentsTimeRange= const[
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Miesiąc 2025"),actions: [
        IconButton(onPressed: ()=>{}, icon: Icon(Icons.help_outline))
      ],),
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
                      return const Center(child: Text('Wybrano opcję 0'));
                    case 1:
                      return const Center(child: Text('Wybrano opcję 1'));
                    case 2:
                      return HomePaymentsView(currentMonth: widget.currentMonthId);
                    default:
                      return HomePaymentsView(currentMonth: widget.currentMonthId);
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.amber.shade600,
          unselectedItemColor: Colors.grey.shade600,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "start"),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today), label: "Miesiąc"),
            BottomNavigationBarItem(
                icon: Icon(Icons.edit_calendar), label: "Dodaj Kategorie"),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_circle_outline), label: "Dodaj opcje"),
            BottomNavigationBarItem(
                icon: Icon(Icons.payments_outlined), label: "Dodaj płatność"),
            BottomNavigationBarItem(
                icon: Icon(Icons.camera_alt_outlined), label: "Paragon"),
          ]
      ),
    );
  }
}
