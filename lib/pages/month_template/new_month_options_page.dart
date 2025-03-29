import 'package:budget_manager/models/option.dart';
import 'package:flutter/material.dart';

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
  late List<Option> optionsList;
  int categoriesListIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
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
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: categoriesList,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            snapshot.data![categoriesListIndex].loadOptions();
            optionsList = snapshot.data![categoriesListIndex].options;
            return Scaffold(
              body: Column(
                children: [
                  Expanded(child:ListView.builder(
                    itemCount: optionsList.length,
                              itemBuilder: (context, index)=>ListTile(
                                title: Text(optionsList[index].name),
                                subtitle: Text("Planowany koszt: ${optionsList[index].plannedCost}"),
                                trailing: IconButton(onPressed: (){}, icon: Icon(Icons.remove_circle_outline)),
                              )
                          ),
                  ),
                  categoriesListIndex == optionsList.length?
                      IconButton(onPressed: (){
                        setState(() {
                          categoriesListIndex-=1;
                        });
                      }, icon: Icon(Icons.arrow_left)):
                      Row(children: [
                        IconButton(onPressed: (){setState(() {
                          categoriesListIndex-=1;
                        });}, icon: Icon(Icons.arrow_left)),
                        IconButton(onPressed: (){setState(() {
                          categoriesListIndex+=1;
                        });}, icon: Icon(Icons.arrow_right)),
                      ],)
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Icon(Icons.error_outline);
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
