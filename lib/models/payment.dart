import 'package:budget_manager/models/option.dart';
import 'package:budget_manager/services/database_service.dart';

class Payment {
  final int? id;
  final int optionId;
  final String name;
  final double cost;
  final DateTime? createdAt;

  Payment({
    this.id,
    required this.optionId,
    required this.name,
    required this.cost,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'option_id': optionId,
      'name': name,
      'cost': cost,
      'created_at':
          createdAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
    };
  }

  // Zmodyfikowany konstruktor z odczytem created_at
  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      id: map['id'],
      optionId: map['option_id'],
      name: map['name'],
      cost: map['cost'],
      createdAt:
          map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
    );
  }

  Future<int> save() async {
    if (id == null) {
      Option.addPayment(this.optionId, this.cost);
      return await DatabaseService.instance.insert('payments', toMap());
    } else if (id == null) {
      return await DatabaseService.instance.insert('payments', toMap());
    } else {
      return await DatabaseService.instance.update('payments', toMap(), id!);
    }
  }

  static Future<List<Payment?>> getListOfPayments() async {
    final data = await DatabaseService.instance.queryAllRows('payments');
    return data.map((map) => Payment.fromMap(map)).toList();
  }
}
