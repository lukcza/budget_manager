import 'package:budget_manager/services/database_service.dart';

class Payment {
  final int? id;
  final int optionId;
  final String name;
  final double cost;
  Payment(
      {this.id,
      required this.optionId,
      required this.name,
      required this.cost});
  Map<String, dynamic> toMap() => {
        'id': id,
        'option_id': optionId,
        'name': name,
        'cost': cost,
      };
  factory Payment.fromMap(Map<String, dynamic> map) => Payment(
      id: map['id'],
      optionId: map['option_id'],
      name: map['name'],
      cost: map['cost']);
}
