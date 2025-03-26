import 'package:budget_manager/models/category.dart';
import 'package:budget_manager/models/option.dart';
import 'package:budget_manager/models/payment.dart';
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
  int? selectedOption;
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();
  late Future<Month?> currentMonth = Month.getById(widget.currentMonthId);
  Future<Category?>? chosenCategory;
  int? optionId;
  Payment? payment;
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
                        FutureBuilder(
                            future: chosenCategory,
                            builder: (BuildContext context, snapshot) {
                              if (snapshot.hasData) {
                                optionId = snapshot.data?.id;
                                return DropdownMenu(
                                    onSelected: null,
                                    dropdownMenuEntries: snapshot
                                        .data!.options
                                        .map((option) => DropdownMenuEntry(
                                        value: option.id,
                                        label: option.name))
                                        .toList());
                              } else {
                                return DropdownMenu(dropdownMenuEntries: [],onSelected: null);
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
              controller: descriptionController,
            ),
            ElevatedButton(
                onPressed: () async{
                  if ((optionId != null) && (double.tryParse(amountController.text) != null) && (double.parse(amountController.text) != 0)) {
                    await Option.addPayment(optionId!,double.parse(amountController.text));
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("dodano"))
                    );
                  }else if(double.tryParse(amountController.text) == null || double.parse(amountController.text) == 0){
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("nie podana kwoty lub kwota = 0 po co to zapisywać?"))
                    );
                  }else if(optionId == null){
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("nie wybrano opcji"))
                    );
                  }
                },
                child: Text("send"))
          ],
        ),
      ),
    );
  }
}
