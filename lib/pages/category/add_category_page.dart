import 'package:budget_manager/models/category.dart';
import 'package:budget_manager/models/enum/page_index.dart';
import 'package:budget_manager/widgets/custom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/database_service.dart';

class AddCategoryPage extends StatefulWidget {
  const AddCategoryPage({
    super.key,
    required this.currentMonthId,
  });
  final currentMonthId;
  @override
  State<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  final titleController = TextEditingController();
  String? monthName;
  //int pageIndex;
  PageIndex? pageIndex;
  @override
  void initState() {
    _loadMonthName();
    // TODO: implement initState
    super.initState();
    pageIndex = PageIndex.categoryAdd;
  }
  Future<void> _loadMonthName() async {
    String? name =
        await DatabaseService.instance.getMonthNameById(widget.currentMonthId);
    setState(() {
      monthName = name ?? "Brak danych";
    });
  }

  @override
  Widget build(BuildContext context) {
    int? categoryId;
    String categoryName;
    Category category1;
    return Scaffold(
      appBar: AppBar(
        title: Text(monthName ?? "Ładowanie"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: titleController,
              ),
              ElevatedButton(
                  onPressed: () async => {
                        category1 = Category(
                            monthId: widget.currentMonthId,
                            name: titleController.value.text),
                        category1.save(),
                        categoryId = await category1.getCategoryId(),
                        categoryName = titleController.text,
                        context.push(
                          '/add_option/$categoryId/$categoryName',
                        )
                      },
                  child: Text("dodaj"))
            ],
          ),
        ),
      ),
      bottomNavigationBar:CustomNavBar(index: pageIndex!),
    );
  }
}
