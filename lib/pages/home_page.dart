import 'package:budget_manager/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.currentMonthId});
  final int currentMonthId;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? monthName;
  @override
  void initState() {
    _loadMonthName();
    super.initState();
  }
  Future<void> _loadMonthName() async {
    String? name = await DatabaseService.instance.getMonthNameById(widget.currentMonthId);
    setState(() {
      monthName = name ?? "Brak danych";
    });
  }
  @override
  Widget build(BuildContext context)  {
    return Scaffold(
      appBar: AppBar(title: Text(monthName?? "Ładowanie..."),),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: OutlinedButton(
                        onPressed: () => context.push('/add_category'),
                        child: Container(child: Text("dodaj kategorie")))),
                Expanded(
                    flex: 1,
                    child: OutlinedButton(
                        onPressed: () => context.push('/add_payment'),
                        child: Text("dodaj platnosc"))),Expanded(
                    flex: 1,
                    child: OutlinedButton(
                        onPressed: () => context.push('/month_page'),
                        child: Text("miesiac"))),
              ],
            )),
            Expanded(
                flex: 1,
                child: OutlinedButton(
                    onPressed: () => print("stats"), child: Text("stats"))
            ),
            Expanded(
                flex: 1,
                child: OutlinedButton(
                    onPressed: () => context.push('/receipt_scanner'), child: Text("Photo"))
            )
          ],
        ),
      ),
    );
  }
}

