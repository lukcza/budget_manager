import 'package:budget_manager/models/category.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/month.dart';

class AddPayment extends StatefulWidget {
  const AddPayment({
    super.key,
    required this.currentMonthId,
  });
  final currentMonthId;
  @override
  State<AddPayment> createState() => _AddPaymentState();
}

class _AddPaymentState extends State<AddPayment> {
  int? selectedValue;
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();
  late Future<Month?> currentMonth = Month.getById(widget.currentMonthId);
  Future<Category?>? chosenCategory;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            FutureBuilder(
                future: currentMonth,
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Błąd: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return Text('Brak danych');
                  } else {
                    return Expanded(
                        child: Column(
                      children: [
                        DropdownMenu(
                          dropdownMenuEntries: snapshot.data!.categories
                              .map((category) => DropdownMenuEntry(
                                  value: category.id, label: category.name))
                              .toList(),
                          onSelected: (value) {
                            setState(() {
                              chosenCategory = Category.getById(
                                value!);
                            });
                          },
                        ),
                        if (chosenCategory != null)
                          FutureBuilder(
                              future: chosenCategory,
                              builder: (BuildContext context, snapshot) {
                                if (snapshot.hasData) {
                                  return DropdownMenu(
                                      dropdownMenuEntries: snapshot
                                          .data!.options
                                          .map((option) => DropdownMenuEntry(
                                              value: option.id,
                                              label: option.name))
                                          .toList());
                                } else {
                                  return Text('Brak danych');
                                }
                              })
                      ],
                    ));
                  }
                }),
            TextField(
              keyboardType: TextInputType.number,
              controller: amountController,
            ),
            TextField(
              keyboardType: TextInputType.text,
            ),
            ElevatedButton(
                onPressed: () => print("payment send"), child: Text("send"))
          ],
        ),
      ),
    );
  }
}
