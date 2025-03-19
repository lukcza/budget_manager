import 'package:flutter/material.dart';

import '../models/category.dart';
class ListItemCategoryWidget extends StatelessWidget {
  ListItemCategoryWidget({super.key, required this.category, required this.onPressedRemove,required this.onPressedEdit, required this.animation});
  Category category;
  final Animation<double> animation;
  final VoidCallback onPressedRemove;
  final VoidCallback onPressedEdit;
  @override
  Widget build(BuildContext context){
    return SizeTransition(sizeFactor: animation,child: buildItem(context),);
  }
  Widget buildItem(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: ListTile(
        title: Text(category.name),
        subtitle: Text("aktualny koszt: "+category.totalActualCost.toString()+" planowany koszt: "+ category.totalPlannedCost.toString()),
        trailing:Row(
          children: [
            IconButton(onPressed: onPressedRemove, icon: Icon(Icons.delete)),
            SizedBox(width: 5,),
            IconButton(onPressed: onPressedEdit, icon: Icon(Icons.edit)),
          ],
        ),
         ),
    );
  }
}
