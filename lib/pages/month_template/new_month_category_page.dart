import 'package:budget_manager/models/month.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/category.dart';

class NewMonthCategoryPage extends StatefulWidget {
  NewMonthCategoryPage({super.key, required this.currentMonthId});
  final currentMonthId;
  @override
  State<NewMonthCategoryPage> createState() => _NewMonthCategoryPageState();
}

class _NewMonthCategoryPageState extends State<NewMonthCategoryPage> {
  late Future<List<Category>> categoriesList;
  final categoryNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    categoriesList = _loadCategories();
  }

  Future<List<Category>> _loadCategories() async {
    Month? currentMonth = await Month.getById(widget.currentMonthId);
    if (currentMonth != null) {
      return currentMonth.categories;
    } else {
      return [];
    }
  }

  Future<void> _addCategory() async {
    Category category = Category(
      monthId: widget.currentMonthId,
      name: categoryNameController.text,
    );
    await category.save();

    setState(() {
      categoriesList = _loadCategories();
    });

    categoryNameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Kategorie")),
      body: FutureBuilder(
        future: categoriesList,
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Icon(Icons.error_outline));
          } else if (snapshot.hasData) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      snapshot.data![index].loadOptions();
                      return ListTile(
                        title: Text(snapshot.data![index].name),
                        subtitle: Text(
                          "Suma planowanych kosztów: ${snapshot.data![index].totalPlannedCost} "
                              "Ilość opcji: ${snapshot.data![index].options.length}",
                        ),
                        trailing: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.remove_circle_outline),
                        ),
                      );
                    },
                  ),
                ),
                Divider(),
                Container(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Container(
                    height: 150,
                    child: ListTile(
                      title: Text("Dodaj kategorię"),
                      trailing: IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("Wprowadź dane nowej kategorii"),
                                  TextField(
                                    controller: categoryNameController,
                                    decoration: InputDecoration(
                                      hintText: "Nazwa",
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () async {
                                    await _addCategory();
                                    Navigator.pop(context);
                                  },
                                  child: Text("Dodaj"),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: Icon(Icons.add_circle_outline),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(child: Text("Brak kategorii"));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: ()=>context.go('/new_options')),
    );
  }
}
