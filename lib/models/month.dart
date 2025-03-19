import 'package:intl/intl.dart';

import '../services/database_service.dart';
import 'category.dart';

class Month {
  final int? id;
  final String name;
  final double plannedIncome;
  final double actualIncome;
  final double plannedExpense;
  final double actualExpense;
  final double plannedBalance;
  final double actualBalance;
  final double totalPlannedExpenses;
  final double totalActualExpenses;
  List<Category> categories = [];

  Month({
    this.id,
    required this.name,
    this.plannedIncome = 0.0,
    this.actualIncome = 0.0,
    this.plannedExpense = 0.0,
    this.actualExpense = 0.0,
    this.plannedBalance = 0.0,
    this.actualBalance = 0.0,
    this.totalPlannedExpenses = 0.0,
    this.totalActualExpenses = 0.0,
  });

  Map<String, dynamic> toMap() =>
      {
        'id': id,
        'name': name,
        'planned_income': plannedIncome,
        'actual_income': actualIncome,
        'planned_expense': plannedExpense,
        'actual_expense': actualExpense,
        'planned_balance': plannedBalance,
        'actual_balance': actualBalance,
        'total_planned_expenses': totalPlannedExpenses,
        'total_actual_expenses': totalActualExpenses,
      };

  factory Month.fromMap(Map<String, dynamic> map) =>
      Month(
        id: map['id'],
        name: map['name'],
        plannedIncome: map['planned_income'],
        actualIncome: map['actual_income'],
        plannedExpense: map['planned_expense'],
        actualExpense: map['actual_expense'],
        plannedBalance: map['planned_balance'],
        actualBalance: map['actual_balance'],
        totalPlannedExpenses: map['total_planned_expenses'],
        totalActualExpenses: map['total_actual_expenses'],
      );

  Future<void> loadCategories() async {
    if (id != null) {
      categories = await Category.getByMonthId(id!);
    }
  }

  static Future<List<Month>> getAll() async {
    final data = await DatabaseService.instance.queryAllRows('months');
    return data.map((map) => Month.fromMap(map)).toList();
  }

  static Future<Month?> getById(int monthId) async {
    final data = await DatabaseService.instance.queryAllRows('months');
    final monthData = data.firstWhere((map) => map['id'] == monthId,
        orElse: () => {});
    if (monthData.isNotEmpty) {
      final month = Month.fromMap(monthData);
      await month.loadCategories();
      return month;
    }
    return null;
  }
  static Future<int> ensureCurrentMonth() async {
    final db = await DatabaseService.instance.database;
    String currentMonth = DateFormat('MMMM yyyy').format(DateTime.now());

    final result = await db.query(
      'months',
      where: 'name = ?',
      whereArgs: [currentMonth],
    );

    if (result.isNotEmpty) {
      return result.first['id'] as int;
    } else {
      // Get last month data
      final lastMonthData = await db.query(
        'months',
        orderBy: 'id DESC',
        limit: 1,
      );

      Map<String, dynamic> newMonthData = {
        'name': currentMonth,
        'planned_income': 0.0,
        'actual_income': 0.0,
        'planned_expense': 0.0,
        'actual_expense': 0.0,
        'planned_balance': 0.0,
        'actual_balance': 0.0,
        'total_planned_expenses': 0.0,
        'total_actual_expenses': 0.0,
      };

      if (lastMonthData.isNotEmpty) {
        final lastMonth = lastMonthData.first;
        newMonthData['planned_income'] = lastMonth['planned_income'];
        newMonthData['planned_expense'] = lastMonth['planned_expense'];
        newMonthData['planned_balance'] = lastMonth['planned_balance'];
        newMonthData['total_planned_expenses'] =
        lastMonth['total_planned_expenses'];
      }

      final newMonthId = await db.insert('months', newMonthData);

      if (lastMonthData.isNotEmpty) {
        final lastMonthId = lastMonthData.first['id'] as int;
        final lastCategories = await Category.getByMonthId(lastMonthId);

        for (var category in lastCategories) {
          final newCategoryId = await db.insert('categories', {
            'month_id': newMonthId,
            'name': category.name,
          });

          for (var option in category.options) {
            await db.insert('options', {
              'category_id': newCategoryId,
              'name': option.name,
              'planned_cost': option.plannedCost,
              'actual_cost': 0.0,
            });
          }
        }
      }

      return newMonthId;
    }
  }
}