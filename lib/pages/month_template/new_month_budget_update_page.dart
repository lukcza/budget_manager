import 'package:budget_manager/models/month.dart';
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
      resizeToAvoidBottomInset: true,
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
                return Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 150),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(8, 8, 8, 40),
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Witamy w \n${snapshot.data!.name}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 20),
                            child: TextField(
                              controller: nameController,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                labelStyle: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                ),
                                labelText: "Miesiąc",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      width: 2,
                                      color: Colors.black87,
                                    )),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              controller: plannedIncomeController,
                              decoration: InputDecoration(
                                labelStyle: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                ),
                                labelText: "Miesięczny budżet",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      width: 4,
                                      color: Colors.black87,
                                    )),
                              ),
                              onChanged: (value) {
                                currentReadyMonth.plannedIncome =
                                    double.parse(value);
                              },
                            ),
                          ),
                        ],
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
          child: Icon(Icons.arrow_right_alt),
          onPressed: () async {
            await _saveMonthPlannedIncome();
            context.push('/new_categories');
          }),
    );
  }
}
