import 'package:flutter/material.dart';

import '../../models/month.dart';

class NewMonthSummaryPage extends StatefulWidget {
  NewMonthSummaryPage({super.key, required this.currentMonthId});

  final currentMonthId;

  @override
  State<NewMonthSummaryPage> createState() => _NewMonthSummaryPageState();
}

class _NewMonthSummaryPageState extends State<NewMonthSummaryPage> {
  late Future<Month?> currentMonth;

  @override
  void initState() {
    // TODO: implement initState
    currentMonth = Month.getById(widget.currentMonthId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: currentMonth,
            builder: (BuildContext context, snapshot) {
              snapshot.data!.updateVariables();
              if (snapshot.hasData) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(snapshot.data!.name),
                      Text(
                          "Zaplanowany przychód: ${snapshot.data!.plannedIncome}"),
                      Text(
                          "Dodatkowy przychód: ${snapshot.data!.actualIncome}"),
                      Text(
                          "Suma zaplanowanych wydatków:${snapshot.data!.plannedExpense}"),
                      Text(
                          "Suma aktualnych wydatków:${snapshot.data!.actualExpense}"),
                      Text("Planowana Dochód:${snapshot.data!.plannedBalance}"),
                      Text("Aktualny Dochód :${snapshot.data!.actualBalance}"),
                      Text(
                          "Liczba Kategori :${snapshot.data!.categories.length}"),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Icon(Icons.error_outline);
              } else {
                return CircularProgressIndicator();
              }
            }));
  }
}
