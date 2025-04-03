import 'package:budget_manager/widgets/list_item_category_widget.dart';
import 'package:flutter/material.dart';
import 'package:budget_manager/models/month.dart';

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
                  itemBuilder: (context, categoryIndex) {
                    bool isExpanded = expandedIndex == categoryIndex;
                    bool isMenuVisible = menuIndex == categoryIndex;
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              expandedIndex = isExpanded ? null : categoryIndex;
                            });
                          },
                          onLongPress: () {
                            _showPopupMenu(categoryIndex);
                          },
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: isExpanded
                                  ? Colors.amber.shade50
                                  : Colors.white,
                              border:
                                  Border.all(color: Colors.black87, width: 3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  title: Text(snapshot
                                      .data!.categories[categoryIndex].name),
                                  trailing: Icon(
                                    isExpanded
                                        ? Icons.expand_less
                                        : Icons.expand_more,
                                  ),
                                ),
                                if (isExpanded)
                                  SizedBox(
                                    height: 200,
                                    child: FutureBuilder(
                                        future: snapshot
                                            .data!.categories[categoryIndex]
                                            .loadOptionsList(),
                                        builder: (BuildContext context,
                                            snapshotNext) {
                                          if (snapshotNext.hasData) {
                                            return ListView.builder(
                                                itemCount:
                                                    snapshotNext.data!.length,
                                                itemBuilder: (context, index) {
                                                  return Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(snapshotNext
                                                              .data![index]
                                                              .name),
                                                          Text(snapshotNext
                                                              .data![index]
                                                              .actualCost
                                                              .toString()),
                                                        ],
                                                      ),
                                                      if (index + 1 ==
                                                          snapshotNext
                                                              .data!.length)
                                                        Column(
                                                          children: [
                                                            Divider(
                                                                color: Colors
                                                                    .black87),
                                                            Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                      "suma: "),
                                                                  Text(snapshot
                                                                      .data!
                                                                      .categories[
                                                                          categoryIndex]
                                                                      .totalActualCost
                                                                      .toString()),
                                                                ]),
                                                          ],
                                                        )
                                                    ],
                                                  );
                                                });
                                          } else if (snapshotNext.hasError) {
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
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 3),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: IconButton(
                                    icon:
                                        Icon(Icons.edit, color: Colors.black87),
                                    onPressed: () {
                                      _hidePopupMenu();
                                      // Logika edycji
                                    },
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 3),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: IconButton(
                                    icon: Icon(Icons.delete,
                                        color: Colors.black87),
                                    onPressed: () {
                                      setState(() {
                                        menuIndex = null;
                                        expandedIndex = null;
                                      });
                                    },
                                  ),
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
                    onPressed: () => context.go('/category'),
                    child: Text("dodaj")),
                ElevatedButton(
                    onPressed: () => context.go('/'), child: Text("wróć")),
              ],
            ))
      ],
    ));
  }*/
}
