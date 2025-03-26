import 'package:budget_manager/models/option.dart';
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
  Future<int> save() async {
    if (this.optionId != null && id == null) {
      Option.addPayment(this.optionId, this.cost);
      return await DatabaseService.instance.insert('payments', toMap());
    } else if (id == null) {
      return await DatabaseService.instance.insert('payments', toMap());
    } else {
      return await DatabaseService.instance.update('payments', toMap(), id!);
    }
  }
}
