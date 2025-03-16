import 'package:flutter/material.dart';

class FormPage extends StatefulWidget {
  const FormPage({Key? key}) : super(key: key);

  @override
  State<FormPage> createState() => _FormPageState();
}

final List<DropdownMenuEntry<String>> dropdownItems = [
  DropdownMenuEntry(value: '1', label: 'Opcja 1'),
  DropdownMenuEntry(value: '2', label: 'Opcja 2'),
  DropdownMenuEntry(value: '3', label: 'Opcja 3'),
];
void sendPayment(){

}
class _FormPageState extends State<FormPage> {
  String? selectedValue;
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
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
                onPressed: sendPayment,
                child: Text("send"))
          ],
        ),
      ),
    );
  }
}
