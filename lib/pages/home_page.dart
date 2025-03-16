import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
              child: Text(getCurrentMonth()),
          ),
          Expanded(child: Row(
            children: [
              Expanded(child: OutlinedButton(onPressed: ()=>print("1"), child: Text("add category"))),
              Expanded(child: OutlinedButton(onPressed: ()=>print("2"), child: Text("add payment"))),
            ],
          ))
        ],
      ),
    );
  }
}
String getCurrentMonth(){
  DateTime now = DateTime.now();
  List<String> monthNames = [
    "Styczen", "Luty", "Marzec", "Kwiecień", "Maj","Czerwiec", "Wrzesień", " Sierpień", "Październik", "Listopad", "Grudzień"
  ];
  return monthNames[now.month -1];
}
