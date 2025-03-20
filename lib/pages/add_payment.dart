import 'package:budget_manager/models/category.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/month.dart';
class AddPayment extends StatefulWidget {
  const AddPayment({super.key, required this.currentMonthId, });
  final currentMonthId;
  @override
  State<AddPayment> createState() => _AddPaymentState();
}
final List<DropdownMenuEntry<String>> dropdownItems = [
  DropdownMenuEntry(value: '1', label: 'Opcja 1'),
  DropdownMenuEntry(value: '2', label: 'Opcja 2'),
  DropdownMenuEntry(value: '3', label: 'Opcja 3'),
];
class _AddPaymentState extends State<AddPayment> {
  String? selectedValue;
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();
  late Future<Month?> categoryListFromCurrentMonth= _loadMonthFromDatabase();
  Future<Month?>_loadMonthFromDatabase() async {
    try {
      return await Month.getById(widget.currentMonthId);
    } catch (error) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text("Error"),
            content: Text(error.toString()),
            actions: <Widget>[
              TextButton(
                  onPressed: () => context.go('/'), child: Text("ok"))
            ],
          ));
    }
    return null;
  }
  Future<Category?>_loadCategoryFromMonth(int id) async {
    try {
      return await Category.getById(id);
    } catch (error) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text("Error"),
            content: Text(error.toString()),
            actions: <Widget>[
              TextButton(
                  onPressed: () => context.go('/'), child: Text("ok"))
            ],
          ));
    }
    return null;
  }
  Future<List<DropdownMenuEntry<String>>> dropdownItemsCategoryLoad(List<Category> categoryListFromCurrentMonth) async {
    List<DropdownMenuEntry<String>> dropdownItemsList = [];

    for (var item in categoryListFromCurrentMonth) {
      dropdownItemsList.add(
        DropdownMenuEntry(
          value: item.id?.toString() ?? '',
          label: item.name,
        ),
      );
    }

    return dropdownItemsList;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            FutureBuilder(
              future: categoryListFromCurrentMonth,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                return DropdownMenu(
                    initialSelection: dropdownItems.first.value,
                    onSelected: (String? value) {
                      setState(() {
                        selectedValue = value;
                      });
                    },
                    dropdownMenuEntries: dropdownItemsCategoryLoad(snapshot.data.));
              }
            ),
            DropdownMenu(
                initialSelection: dropdownItems.first.value,
                onSelected: (String? value) {
                  setState(() {
                    selectedValue = value;
                  });
                },
                dropdownMenuEntries: dropdownItems),
            TextField(
              keyboardType: TextInputType.number,
              controller: amountController,
            ),
            TextField(
              keyboardType: TextInputType.text,
            ),
            ElevatedButton(
                onPressed: ()=>print("payment send"),
                child: Text("send"))
          ],
        ),
      ),
    );
  }
}
