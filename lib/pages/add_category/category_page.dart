import 'package:budget_manager/models/option.dart';
import 'package:go_router/go_router.dart';
import '../../models/option.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CategoryPage extends StatefulWidget {
  CategoryPage({super.key, required this.categoryTitle, required this.categoryId});
  String categoryTitle;
  int categoryId;
  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<Option> items = [];
  void _addItem() {
    TextEditingController nameController = TextEditingController();
    TextEditingController amountController = TextEditingController();
    TextEditingController inncomeAmountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(

        title: Center(child: Text('Dodaj opcje')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
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
            TextField(
              keyboardType: TextInputType.number,
              controller: inncomeAmountController,
              decoration: InputDecoration(
                hintText: 'Podaj juz wydaną kwote',
              ),
            ),
          ],
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
                          : amountController.value.text),
                      int.parse(inncomeAmountController.value.text.isEmpty
                      ? '0'
                      : inncomeAmountController.value.text)));
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
                subtitle: Text("Limit: "+items[index].amount.toString()+" Wydane: "+ items[index].incomeAmount.toString()),
                trailing: IconButton(
                  icon: Icon(
                    Icons.remove_circle,
                    color: Colors.red,
                  ),
                  onPressed: () => {
                    setState(() {
                      items.removeAt(index);
                    })
                  },
                ),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  ElevatedButton(onPressed: () => context.pop(), child: Text("wroc")),
                  ElevatedButton(onPressed: _addItem, child: Text("dodaj")),
                  ElevatedButton(onPressed: () => context.pop(), child: Text("zapisz")),
                ],
              ))
        ],
      ),
    );
  }
}
