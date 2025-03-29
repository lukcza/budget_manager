import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
class BudgetPageChartView extends StatefulWidget {
  const BudgetPageChartView({super.key, required this.currentMonthID});
  final currentMonthID;
  @override
  State<BudgetPageChartView> createState() => _BudgetPageChartViewState();
}

class _BudgetPageChartViewState extends State<BudgetPageChartView> {
  final List<PieChartSectionData> pieChartList= [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Budżet"),
      ),
      body: Column(
        children: [
          PieChart(
              PieChartData(
                sections: pieChartList
              ),
            duration: Duration(milliseconds: 150), // Optional
            curve: Curves.easeOutExpo,
          )
        ],
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
          ]),
    );
  }
}
