import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: Text(
                    style: TextStyle(
                      fontSize: 30,
                    ),
                    getCurrentMonth()),
              ),
            ),
            Expanded(
                child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: OutlinedButton(
                        onPressed: () => context.go('/add_category'),
                        child: Container(child: Text("dodaj kategorie")))),
                Expanded(
                    flex: 1,
                    child: OutlinedButton(
                        onPressed: () => context.go('/add_payment'),
                        child: Text("dodaj platnosc"))),
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
                    onPressed: () => print("Photo"), child: Text("Photo"))
            )
          ],
        ),
      ),
    );
  }
}

String getCurrentMonth() {
  DateTime now = DateTime.now();
  List<String> monthNames = [
    "Styczen",
    "Luty",
    "Marzec",
    "Kwiecień",
    "Maj",
    "Czerwiec",
    "Wrzesień",
    " Sierpień",
    "Październik",
    "Listopad",
    "Grudzień"
  ];
  return monthNames[now.month - 1];
}
