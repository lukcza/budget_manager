import 'package:flutter/material.dart';

import '../../models/payment.dart';
import '../../widgets/payment_card.dart';

class HomePaymentsView extends StatefulWidget {
  const HomePaymentsView({super.key, required this.currentMonth});
  final currentMonth;
  @override
  State<HomePaymentsView> createState() => _HomePaymentsViewState();
}

class _HomePaymentsViewState extends State<HomePaymentsView> {
  late Future<List<Payment?>> listOfPayments = Payment.getListOfPayments();
  void initState() {
    // TODO: implement initState
    listOfPayments = Payment.getListOfPayments();
    super.initState();
  }

  List<DropdownMenuItem<int>> listOfPaymentsTimeRange = [
    DropdownMenuItem(value: 0, child: Text("Ostatnie")),
    DropdownMenuItem(value: 1, child: Text("Wczorajsze")),
    DropdownMenuItem(value: 2, child: Text("Tydzień temu")),
  ];
  late var selectedTimeRange = 0;
  List<Payment> getYesterdayPayments(List<Payment?> listOfPayments) {
    DateTime today = DateTime.now();
    DateTime startOfYesterday = DateTime(today.year, today.month, today.day)
        .subtract(Duration(days: 1));
    DateTime endOfYesterday = DateTime(today.year, today.month, today.day)
        .subtract(Duration(seconds: 1));

    List<Payment> yesterdayPayments = [];
    for (var payment in listOfPayments) {
      if (payment!.createdAt != null &&
          payment.createdAt!.isAfter(startOfYesterday) &&
          payment.createdAt!.isBefore(endOfYesterday)) {
        yesterdayPayments.add(payment);
      }
    }
    return yesterdayPayments;
  }

// Funkcja zwracająca płatności z dzisiaj
  List<Payment> getTodayPayments(List<Payment?> listOfPayments) {
    DateTime today = DateTime.now();
    DateTime startOfDay = DateTime(today.year, today.month, today.day);
    DateTime endOfDay =
        startOfDay.add(Duration(days: 1)).subtract(Duration(seconds: 1));

    List<Payment> todayPayments = [];
    for (var payment in listOfPayments) {
      if (payment!.createdAt != null &&
          payment.createdAt!.isAfter(startOfDay) &&
          payment.createdAt!.isBefore(endOfDay)) {
        todayPayments.add(payment);
      }
    }
    return todayPayments;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        Expanded(
          child: FutureBuilder<List<Payment?>>(
            future: listOfPayments,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Błąd: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data == null) {
                return const Text('Brak danych');
              }

              List<Payment> filteredList = [];

              switch (selectedTimeRange) {
                case 0:
                  snapshot.data!
                      .sort((a, b) => b!.createdAt!.compareTo(a!.createdAt!));
                  filteredList = snapshot.data!.cast<Payment>();
                  break;
                case 1:
                  filteredList = getYesterdayPayments(snapshot.requireData);
                  break;
                case 2:
                  filteredList = getTodayPayments(snapshot.requireData);
                  break;
                default:
                  return const Text("Błąd 404");
              }

              return ListView.builder(
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final paymentMap = filteredList[index].toMap();
                  return PaymentCard(
                    name: paymentMap['name'],
                    cost: paymentMap['cost'],
                    date: DateTime.parse(paymentMap['created_at']),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
