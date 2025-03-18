import 'package:flutter/material.dart';
import '../../services/database_service.dart';
class AddCategoryPage extends StatefulWidget {
  const AddCategoryPage({super.key, required this.currentMonthId, });
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
    String? name = await DatabseService.instance.getMonthNameById(widget.currentMonthId);
    setState(() {
      monthName = name ?? "Brak danych";
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(monthName??"Ładowanie"),),
      body: Column(
        children: [
          TextField(
            controller: titleController,
          ),
        ],
      ),
    );
  }
}
