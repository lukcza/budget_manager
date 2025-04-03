import 'package:budget_manager/widgets/element_of_summary.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../models/month.dart';

class HomeBudgetView extends StatefulWidget {
  HomeBudgetView({super.key, required this.currentMonthId});

  final currentMonthId;

  @override
  State<HomeBudgetView> createState() => _HomeBudgetViewState();
}

class _HomeBudgetViewState extends State<HomeBudgetView> {
  late Future<Month?> currentMonth;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentMonth = Month.getMonthSummary(widget.currentMonthId);
  }

  double _doubleToPercent(double max, double partial) {
    return (partial / max);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: currentMonth,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElementOfSummary(
                  title: "Budżet",
                  percentValue: _doubleToPercent(snapshot.data!.plannedIncome,
                      snapshot.data!.plannedIncome),
                  value: snapshot.data!.plannedIncome,
                  color: Colors.green,
                ),
                ElementOfSummary(
                  title: "Wydano:",
                  percentValue: _doubleToPercent(snapshot.data!.plannedIncome,
                      snapshot.data!.actualExpense),
                  value: snapshot.data!.actualExpense,
                  color: _doubleToPercent(snapshot.data!.plannedIncome,
                              snapshot.data!.plannedIncome) >
                          0.5
                      ? Colors.green
                      : Colors.red,
                ),
                ElementOfSummary(
                  title: "Bilans:",
                  percentValue: _doubleToPercent(snapshot.data!.plannedIncome,
                      snapshot.data!.actualBalance),
                  value: snapshot.data!.actualBalance,
                  color: _doubleToPercent(snapshot.data!.plannedIncome,
                              snapshot.data!.actualBalance) >
                          0.5
                      ? Colors.green
                      : Colors.red,
                ),
                ElementOfSummary(
                  title: "Przewidywany Bilans:",
                  percentValue: _doubleToPercent(snapshot.data!.plannedIncome,
                      snapshot.data!.plannedBalance),
                  value: snapshot.data!.plannedBalance,
                  color: _doubleToPercent(snapshot.data!.plannedIncome,
                              snapshot.data!.plannedBalance) >
                          0.5
                      ? Colors.green
                      : Colors.red,
                )
              ],
            );
          } else if (snapshot.hasError) {
            return Icon(Icons.error_outline);
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
