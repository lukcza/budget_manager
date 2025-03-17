import 'package:flutter/material.dart';
class AddPayment extends StatefulWidget {
  const AddPayment({super.key});

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
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
    );
  }
}
