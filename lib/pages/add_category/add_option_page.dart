import 'package:budget_manager/models/option.dart';
import '../../models/option.dart';
import 'package:flutter/material.dart';

class CategoryPage extends StatefulWidget {
  CategoryPage({super.key, required this.categoryTitle});
  late String categoryTitle;
  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<Option> items = [];
  void _addItem() {
    TextEditingController nameController = TextEditingController();
    TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(''),
        content: Expanded(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(hintText: 'Wpisz nazwe opcji'),
              ),
              TextField(
                keyboardType: TextInputType.number,
                controller: amountController,
                decoration: InputDecoration(
                  hintText: 'Podaj przewidywaną kwote',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Anuluj'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                setState(() {
                  items.add(Option(
                      nameController.text,
                      int.parse(amountController.value.text.isEmpty
                          ? '0'
                          : amountController.value.text)));
                });
              }
              Navigator.pop(context);
            },
            child: Text('Dodaj'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryTitle),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(items[index].name),
                subtitle: Text(items[index].amount.toString()),
                trailing: Icon(
                  Icons.remove_circle,
                  color: Colors.red,
                ),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(8),
              child: ElevatedButton(onPressed: _addItem, child: Text("dodaj")))
        ],
      ),
    );
  }
}
