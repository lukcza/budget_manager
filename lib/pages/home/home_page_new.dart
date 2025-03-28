import 'package:flutter/material.dart';

import 'home_payments_view.dart';

class HomePageNew extends StatefulWidget {
   HomePageNew({super.key, required this.currentMonthId});
  final int currentMonthId;
  @override
  State<HomePageNew> createState() => _HomePageNewState();
}

class _HomePageNewState extends State<HomePageNew> {
  List<DropdownMenuEntry<int>> listOfPaymentsTimeRange= const[
    DropdownMenuEntry(value: 0, label: "Ostatnie"),
    DropdownMenuEntry(value: 1, label: "Wczorajsze"),
    DropdownMenuEntry(value: 2, label: "Tydzień temu"),
  ];
  final  viewIndex = 0;
  late final selectedTimeRange;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Miesiąc 2025"),actions: [
        IconButton(onPressed: ()=>{}, icon: Icon(Icons.help_outline))
      ],),
      body: Column(
        children: [
          Row(
            children: [
              ElevatedButton(onPressed: ()=>{}, child: Text("Budżet")),
              ElevatedButton(onPressed: ()=>{}, child: Text("Kategorie")),
              ElevatedButton(onPressed: ()=>{}, child: Text("Płatności")),
            ],
          ),
          Builder(
            builder: (context) {
              switch (viewIndex) {
                case 0:
                  return HomePaymentsView();
                case 1:
                  return const Text('Wybrano opcję 2');
                case 2:
                  return const Text('Wybrano opcję 3');
                default:
                  return const Text('Nieznana opcja');
              }
            },
          ),

        ],),
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.amber.shade600,
          unselectedItemColor: Colors.grey.shade600,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "start"),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today), label: "Miesiąc"),
            BottomNavigationBarItem(
                icon: Icon(Icons.edit_calendar), label: "Dodaj Kategorie"),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_circle_outline), label: "Dodaj opcje"),
            BottomNavigationBarItem(
                icon: Icon(Icons.payments_outlined), label: "Dodaj płatność"),
            BottomNavigationBarItem(
                icon: Icon(Icons.camera_alt_outlined), label: "Paragon"),
          ]
      ),
    );
  }
}
