import 'package:budget_manager/services/database_service.dart';
import 'package:budget_manager/widgets/list_item_category_widget.dart';
import 'package:flutter/material.dart';
import 'package:budget_manager/models/month.dart';
import 'package:go_router/go_router.dart';

import '../../models/category.dart';

class MonthPage extends StatefulWidget {
  const MonthPage({super.key, required this.currentMonthId});
  final currentMonthId;
  @override
  State<MonthPage> createState() => _MonthPageState();
}

class _MonthPageState extends State<MonthPage> {
  int? expandedIndex;
  int? menuIndex;
  late Future<Month?> currentMonth = Month.getById(widget.currentMonthId);
  @override
  void initState() {
    //currentMonth = Month.getById(widget.currentMonthId);
    super.initState();
  }

  void removeItem(int index, List<Category> categoriesList) {
    final removedItem = categoriesList[index];
    categoriesList.removeAt(index);
    categoryListKey.currentState!.removeItem(
        index,
        (context, animation) => ListItemCategoryWidget(
              category: removedItem,
              animation: animation,
              onPressedRemove: () {},
              onPressedEdit: () {},
            ));
    Category.delete(removedItem.id!);
  }
  void _showPopupMenu(int index) {
    setState(() {
      menuIndex = index;
    });
  }
  void _hidePopupMenu() {
    setState(() {
      menuIndex = null;
    });
  }
  final categoryListKey = GlobalKey<AnimatedListState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: currentMonth,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Błąd: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Text('Brak danych');
            } else {
              return GestureDetector(
                onTap: _hidePopupMenu,
                child: ListView.builder(
                  itemCount: snapshot.data!.categories.length,
                  itemBuilder: (context, index) {
                    bool isExpanded = expandedIndex == index;
                    bool isMenuVisible = menuIndex == index;
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              expandedIndex = isExpanded ? null : index;
                            });
                          },
                          onLongPress: () {
                            _showPopupMenu(index);
                          },
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: isExpanded ? Colors.blue.shade100 : Colors.white,
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  title: Text(snapshot.data!.categories[index].name),
                                  trailing: Icon(
                                    isExpanded ? Icons.expand_less : Icons.expand_more,
                                  ),
                                ),
                                if (isExpanded)
                                  SizedBox(
                                    height: 100,
                                    child: FutureBuilder(
                                        future: snapshot.data!.categories[index].loadOptionsList(),
                                        builder: (BuildContext context, snapshot) {
                                          if (snapshot.hasData) {
                                            return ListView.builder(
                                                itemCount: snapshot.data!.length,
                                                itemBuilder: (context,index){
                                                  return Text(snapshot.data![index].name);
                                                });
                                          } else if (snapshot.hasError) {
                                            return Icon(Icons.error_outline);
                                          } else {
                                            return CircularProgressIndicator();
                                          }
                                        }),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        if (isMenuVisible)
                          Container(
                            color: Colors.black54,
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.white),
                                  onPressed: () {
                                    _hidePopupMenu();
                                    // Logika edycji
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.white),
                                  onPressed: () {
                                    setState(() {
                                      menuIndex = null;
                                      expandedIndex = null;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                      ],
                    );
                  },
                ),
              );
            }
          }),
    );
  }
  /*Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        FutureBuilder(
            future: currentMonth,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Błąd: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data == null) {
                return Text('Brak danych');
              } else {
                return Expanded(
                  child: AnimatedList(
                      key: categoryListKey,
                      initialItemCount: snapshot.data!.categories.length,
                      itemBuilder: (context, index, animation) =>
                          ListItemCategoryWidget(
                              category: snapshot.data!.categories[index],
                              animation: animation,
                              onPressedRemove: () =>
                                  removeItem(index, snapshot.data!.categories),
                              onPressedEdit: () => print("yes"))),
                );
              }
            }),
        Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                ElevatedButton(
                    onPressed: () => context.go('/add_category'),
                    child: Text("dodaj")),
                ElevatedButton(
                    onPressed: () => context.go('/'), child: Text("wróć")),
              ],
            ))
      ],
    ));
  }*/
}
