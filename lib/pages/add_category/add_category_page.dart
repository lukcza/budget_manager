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
  @override
  void initState() {
    _loadMonthName();
    // TODO: implement initState
    super.initState();
  }

  Future<void> _loadMonthName() async {
    String? name =
        await DatabseService.instance.getMonthNameById(widget.currentMonthId);
    setState(() {
      monthName = name ?? "Brak danych";
    });
  }

  @override
  Widget build(BuildContext context) {
    int? categoryId;
    String categoryName;
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
                        await DatabseService.instance.createCategory(
                            widget.currentMonthId, titleController.value.text),
                        categoryId = await DatabseService.instance
                            .getCategoryId(titleController.value.text),
                        categoryName = titleController.text,
                        context.go(
                          '/add_option/$categoryId/$categoryName',
                        )
                      },
                  child: Text("dodaj"))
            ],
          ),
        ),
      ),
    );
  }
}
