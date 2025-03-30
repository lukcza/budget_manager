import 'package:budget_manager/models/month.dart';
import 'package:budget_manager/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NewMonthBudgetUpdatePage extends StatefulWidget {
  NewMonthBudgetUpdatePage({super.key, required this.currentMonthId});

  int currentMonthId;

  @override
  State<NewMonthBudgetUpdatePage> createState() =>
      _NewMonthBudgetUpdatePageState();
}

class _NewMonthBudgetUpdatePageState extends State<NewMonthBudgetUpdatePage> {
  late Future<Month?> currentMonth;
  final nameController = TextEditingController();
  final plannedIncomeController = TextEditingController();
  final actualIncomeController = TextEditingController();
  late Month currentReadyMonth;

  @override
  void initState() {
    // TODO: implement initState
    currentMonth = Month.getById(widget.currentMonthId);
    super.initState();
  }

  Future<void> _saveMonthPlannedIncome() async {
    print("saving...");
    currentReadyMonth.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
            future: currentMonth,
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasData) {
                nameController.text = snapshot.requireData!.name;
                if (snapshot.data!.plannedIncome != 0.0) {
                  plannedIncomeController.text =
                      snapshot.requireData!.plannedIncome.toString();
                }
                currentReadyMonth = snapshot.requireData!;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: nameController,
                    ),
                    TextField(
                      controller: plannedIncomeController,
                      decoration: InputDecoration(
                          hintText: "wprowadz planowany budżet na ten miesiąc"),
                      onChanged: (value) {
                        currentReadyMonth.plannedIncome = double.parse(value);
                      },
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Icon(Icons.error_outline);
              } else {
                return CircularProgressIndicator();
              }
            }),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () async {
        await _saveMonthPlannedIncome();
        context.push('/new_categories');
      }),
    );
  }
}
