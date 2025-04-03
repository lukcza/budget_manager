import 'package:budget_manager/models/payment.dart';

import '../services/database_service.dart';

class Option {
  final int? id;
  final int categoryId;
  final String name;
  final double plannedCost;
  final double actualCost;
  final List<Payment> payments = [];

  Option({
    this.id,
    required this.categoryId,
    required this.name,
    this.plannedCost = 0.0,
    this.actualCost = 0.0,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'category_id': categoryId,
        'name': name,
        'planned_cost': plannedCost,
        'actual_cost': actualCost,
      };

  factory Option.fromMap(Map<String, dynamic> map) => Option(
        id: map['id'],
        categoryId: map['category_id'],
        name: map['name'],
        plannedCost: map['planned_cost'],
        actualCost: map['actual_cost'],
      );

  static Future<List<Option>> getByCategoryId(int categoryId) async {
    final data = await DatabaseService.instance.queryAllRows('options');
    return data
        .where((map) => map['category_id'] == categoryId)
        .map((map) => Option.fromMap(map))
        .toList();
  }

  Future<int> save() async {
    if (id == null) {
      return await DatabaseService.instance.insert('options', toMap());
    } else {
      return await DatabaseService.instance.update('options', toMap(), id!);
    }
  }

  static Future<int> delete(int id) async {
    return await DatabaseService.instance.delete('options', id);
  }

  static Future addPayment(int optionId, double amount) async {
    final db = await DatabaseService.instance.database;
    db.update('options', {'actual_cost': amount},
        where: ' id=? ', whereArgs: [optionId]);
  }
}
