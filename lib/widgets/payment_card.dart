import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class PaymentCard extends StatelessWidget {
  PaymentCard({super.key, required this.name, required this.cost,required this.date});
  String name;
  double cost;
  DateTime date;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(child:Column(
        children: [
          ListTile(
            leading: Icon(Icons.attach_money_rounded),
            title: Text(name),
            subtitle: Text(DateFormat('MM dd HH:mm').format(date)),
            trailing: Text(cost.toString()),
          )
        ],
      )
      ),
    );
  }
}
