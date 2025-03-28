import 'package:flutter/material.dart';
class HomePaymentsView extends StatefulWidget {
  const HomePaymentsView({super.key});

  @override
  State<HomePaymentsView> createState() => _HomePaymentsViewState();
}

class _HomePaymentsViewState extends State<HomePaymentsView> {
  List<DropdownMenuItem<int>> listOfPaymentsTimeRange= [
    DropdownMenuItem(value: 0, child: Text("Ostatnie")),
    DropdownMenuItem(value: 1, child: Text("Wczorajsze")),
    DropdownMenuItem(value: 2, child: Text("Tydzień temu")),
  ];
  late final selectedTimeRange;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Text("Płatności"),
            DropdownButton<int>(
              value: selectedTimeRange,
              items: listOfPaymentsTimeRange,
              onChanged: (value) {
                setState(() {
                  selectedTimeRange = value ?? 0;
                });
              },
            ),
          ],
        ),
        Builder(
          builder: (context) {
            switch (selectedTimeRange) {
              case 0:
                return const Text("Opcja 1");
              case 1:
                return const Text("Opcja 2");
              case 2:
                return const Text("Opcja 3");
              default:
                return const Text("Błąd 404");
            }
          },
        ),
      ],
    );
  }
}
