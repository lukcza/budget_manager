import 'package:flutter/material.dart';

import '../../models/category.dart';
import '../../models/month.dart';

class HomeCategoryView extends StatefulWidget {
  HomeCategoryView({super.key, required this.currentMonthId});

  int currentMonthId;

  @override
  State<HomeCategoryView> createState() => _HomeCategoryViewState();
}

class _HomeCategoryViewState extends State<HomeCategoryView> {
  late Future<List<Category>> categoriesList;

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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: categoriesList,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                snapshot.data![index].loadOptions();
                return Card(
                  child: ListTile(
                    title: Text(snapshot.data![index].name),
                    subtitle: Text(
                      "Suma planowanych kosztów: ${snapshot.data![index].totalPlannedCost} "
                      "\nIlość opcji: ${snapshot.data![index].options.length}",
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Icon(Icons.error_outline);
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
