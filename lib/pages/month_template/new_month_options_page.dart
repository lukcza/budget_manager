import 'package:budget_manager/models/option.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/category.dart';
import '../../models/month.dart';

class NewMonthOptionsPage extends StatefulWidget {
  NewMonthOptionsPage({super.key, this.currentMonthId});

  final currentMonthId;

  @override
  State<NewMonthOptionsPage> createState() => _NewMonthOptionsPageState();
}

class _NewMonthOptionsPageState extends State<NewMonthOptionsPage> {
  late Future<List<Category>> categoriesList;
  Future<List<Option>>? optionsList;
  int categoriesListIndex = 0;
  final optionsNameController = TextEditingController();
  final costController = TextEditingController();
  final costActualController = TextEditingController();

  @override
  void initState() {
    super.initState();
    categoriesList = _loadCategories();
  }

  Future<List<Category>> _loadCategories() async {
    Month? currentMonth = await Month.getById(widget.currentMonthId);
    return currentMonth?.categories ?? [];
  }

  Future<void> _loadOptions() async {
    List<Category> categories = await categoriesList;
    if (categories.isNotEmpty &&
        categoriesListIndex >= 0 &&
        categoriesListIndex < categories.length) {
      setState(() {
        optionsList = categories[categoriesListIndex].loadOptionsList();
      });
    }
  }

  Future<void> _addOption(int categoryId) async {
    Option option = Option(
      categoryId: categoryId,
      name: optionsNameController.text,
      plannedCost: double.parse(costController.text),
      actualCost: double.parse(costActualController.text),
    );
    await option.save();
    await _loadOptions();
  }

  void _changeCategory(int newIndex) async {
    setState(() {
      categoriesListIndex = newIndex;
      optionsList = null;
    });
    await _loadOptions();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Category>>(
      future: categoriesList,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          if (optionsList == null) _loadOptions();
          return Scaffold(
            appBar: AppBar(
              title: Text(snapshot.data![categoriesListIndex].name),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  FutureBuilder<List<Option>>(
                    future: optionsList,
                    builder: (context, optionSnapshot) {
                      if (optionSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (optionSnapshot.hasError) {
                        return Icon(Icons.error_outline);
                      } else if (optionSnapshot.hasData) {
                        return Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount: optionSnapshot.data!.length,
                            itemBuilder: (context, index) => ListTile(
                              title: Text(optionSnapshot.data![index].name),
                              subtitle: Text(
                                  "Planowany koszt: ${optionSnapshot.data![index].plannedCost}"),
                              trailing: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.remove_circle_outline),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Text("Brak opcji do wyświetlenia");
                      }
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Container(
                      child: ListTile(
                        title: Text("Dodaj opcje"),
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
                                      controller: optionsNameController,
                                      decoration: InputDecoration(
                                        label: Text("Nazwa opcji"),
                                        hintText: "...",
                                      ),
                                    ),
                                    TextField(
                                      controller: costController,
                                      decoration: InputDecoration(
                                        label: Text("Planowany koszt"),
                                        hintText: "0",
                                      ),
                                    ),
                                    TextField(
                                      controller: costActualController,
                                      decoration: InputDecoration(
                                        label: Text("Aktualny koszt"),
                                        hintText: "0",
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () async {
                                      await _addOption(snapshot
                                          .data![categoriesListIndex].id!);
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
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: categoriesListIndex > 0
                              ? () => _changeCategory(categoriesListIndex - 1)
                              : null,
                          icon: Icon(
                            Icons.arrow_left,
                            size: 50,
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              context.go("/new_summary");
                            },
                            child: Text(
                              "zapisz",
                              style: TextStyle(fontSize: 20),
                            )),
                        IconButton(
                          onPressed: categoriesListIndex <
                                  snapshot.data!.length - 1
                              ? () => _changeCategory(categoriesListIndex + 1)
                              : null,
                          icon: Icon(
                            Icons.arrow_right,
                            size: 50,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Icon(Icons.error_outline);
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
