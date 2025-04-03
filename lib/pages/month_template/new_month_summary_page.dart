import 'package:budget_manager/widgets/item_in_summary_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/month.dart';

class NewMonthSummaryPage extends StatefulWidget {
  NewMonthSummaryPage({super.key, required this.currentMonthId});

  final currentMonthId;

  @override
  State<NewMonthSummaryPage> createState() => _NewMonthSummaryPageState();
}

class _NewMonthSummaryPageState extends State<NewMonthSummaryPage> {
  late Month readyMonth;
  late Future<Month?> currentMonth;

  void initState() {
    super.initState();
    currentMonth = Month.getMonthSummary(
        widget.currentMonthId); // ✅ Wywołanie funkcji ładującej dane
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
            future: currentMonth,
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasData) {
                //snapshot.data!.updateVariables();
                readyMonth = snapshot.data!;
                return Container(
                  alignment: Alignment.topLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ItemInSummaryPage(
                        prefixText: 'Miesiąc:',
                        text: snapshot.data!.name,
                      ),
                      ItemInSummaryPage(
                        prefixText: 'Zaplanowany przychód:',
                        text: snapshot.data!.plannedIncome.toString(),
                      ),
                      ItemInSummaryPage(
                        prefixText: 'Dodatkowy przychód:',
                        text: snapshot.data!.actualIncome.toString(),
                      ),
                      ItemInSummaryPage(
                        prefixText: 'Suma zaplanowanych wydatków:',
                        text: snapshot.data!.plannedExpense.toString(),
                      ),
                      ItemInSummaryPage(
                        prefixText: 'Suma aktualnych wydatków:',
                        text: snapshot.data!.actualExpense.toString(),
                      ),
                      ItemInSummaryPage(
                        prefixText: 'Planowana Dochód:',
                        text: snapshot.data!.plannedBalance.toString(),
                      ),
                      ItemInSummaryPage(
                        prefixText: 'Aktualny Dochód:',
                        text: snapshot.data!.actualBalance.toString(),
                      ),
                      ItemInSummaryPage(
                        prefixText: 'Liczba Kategori :',
                        text: snapshot.data!.categories.length.toString(),
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Icon(Icons.error_outline);
              } else {
                return CircularProgressIndicator();
              }
            }),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.check),
          onPressed: () {
            readyMonth.save();
            context.go('/');
          }),
    );
  }
}
