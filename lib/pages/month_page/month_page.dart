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
  late Future<Month?> currentMonth= _loadMonthFromDatabase();
  @override
  void initState()  {
    super.initState();
  }

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
  }

  /*void removeItem(int index) {
    final removedItem = listOfCategories[index];
    listOfCategories.removeAt(index);
    categoryListKey.currentState!.removeItem(
        index,
        (context, animation) => ListItemCategoryWidget(
            category: removedItem,
            animation: animation,
            onPressedRemove: (){},
            onPressedEdit: (){},));
  }*/

  final categoryListKey = GlobalKey<AnimatedListState>();
  @override
  Widget build(BuildContext context) {
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
                    itemBuilder: (context, index, animation) => ListItemCategoryWidget(
                        category: snapshot.data!.categories[index],
                        animation: animation,
                        onPressedRemove: () => print("da"),
                        onPressedEdit: () => print("yes"))),
              );
            }
          }
        ),
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
    )
        /*FutureBuilder(
          future: DatabaseService.instance
              .getCategoriesForMonth(widget.currentMonthId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Błąd: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Text('Brak danych');
            } else {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) => ListTile(
                        title:
                            Text(snapshot.data![index]['month_id'].toString()),
                      ));
            }
          }),*/
        );
  }
}
