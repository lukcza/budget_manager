import 'package:budget_manager/models/option.dart';
import 'package:budget_manager/services/database_service.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

class CategoryPage extends StatefulWidget {
  CategoryPage(
      {super.key, required this.categoryTitle, required this.categoryId});
  String categoryTitle;
  int categoryId;
  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<Option> items = [];
  void _addItem() {
    TextEditingController nameController = TextEditingController();
    TextEditingController plannedCostController = TextEditingController();
    TextEditingController actualCostController = TextEditingController();
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
              controller: plannedCostController,
              decoration: InputDecoration(
                hintText: 'Podaj przewidywaną kwote',
              ),
            ),
            TextField(
              keyboardType: TextInputType.number,
              controller: actualCostController,
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
                      double.parse(plannedCostController.value.text.isEmpty
                          ? '0'
                          : plannedCostController.value.text),
                      double.parse(actualCostController.value.text.isEmpty
                          ? '0'
                          : actualCostController.value.text)));
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

  void _addAllOptions() async {
    for (var item in items) {
      await DatabseService.instance.createOption(
          widget.categoryId, item.name, item.plannedCost, item.actualCost);
    }
    showDialog(
        context: context,
        builder:(BuildContext context)=>
            AlertDialog(
              content: Text("Czy napewno chcesz dodać te opcje?"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    this.context.pop();// Zamknięcie dialogu
                  },
                  child: Text('TAK'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Zamknięcie dialogu
                  },
                  child: Text('NIE'),
                ),
              ],
            ));
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
                subtitle: Text("Limit: " +
                    items[index].plannedCost.toString() +
                    " Wydane: " +
                    items[index].actualCost.toString()),
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
                  ElevatedButton(
                      onPressed: (){
                        items = [];
                        context.pop();
                      }, child: Text("wroc")),
                  ElevatedButton(onPressed: _addItem, child: Text("dodaj")),
                  ElevatedButton(
                      onPressed: () => _addAllOptions(), child: Text("zapisz")),
                ],
              ))
        ],
      ),
    );
  }
}
