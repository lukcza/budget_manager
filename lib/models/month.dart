import 'package:intl/intl.dart';

import '../services/database_service.dart';
import 'category.dart';

class Month {
  final int? id;
  final String name;
  double plannedIncome;
  double actualIncome;
  double plannedExpense;
  double actualExpense;
  double plannedBalance;
  double actualBalance;
  double totalPlannedExpenses;
  double totalActualExpenses;
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

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'planned_income': plannedIncome,
        'actual_income': actualIncome,
        'planned_expense': plannedExpense,
        'actual_expense': actualExpense,
        'planned_balance': plannedBalance,
        'actual_balance': actualBalance,
      };

  factory Month.fromMap(Map<String, dynamic> map) => Month(
        id: map['id'],
        name: map['name'],
        plannedIncome: map['planned_income'],
        actualIncome: map['actual_income'],
        plannedExpense: map['planned_expense'],
        actualExpense: map['actual_expense'],
        plannedBalance: map['planned_balance'],
        actualBalance: map['actual_balance'],
      );

  Future<int> save() async {
    if (id == null) {
      return await DatabaseService.instance.insert('months', toMap());
    } else {
      return await DatabaseService.instance.update('months', toMap(), id!);
    }
  }

  Future<void> loadCategories() async {
    if (id != null) {
      categories = await Category.getByMonthId(id!);
    }
  }

  Future<void> updateVariables() async {
    await loadCategories();
    plannedExpense = categories.fold(
        0.0, (sum, category) => sum + category.totalPlannedCost);
    actualExpense =
        categories.fold(0.0, (sum, category) => sum + category.totalActualCost);
    plannedBalance = plannedIncome - plannedExpense;
    actualBalance = plannedIncome + actualIncome - actualExpense;
  }

  static Future<List<Month>> getAll() async {
    final data = await DatabaseService.instance.queryAllRows('months');
    return data.map((map) => Month.fromMap(map)).toList();
  }

  Future<List<Category>> getCategories() async {
    loadCategories();
    return categories;
  }

  static Future<Month?> getById(int monthId) async {
    final data = await DatabaseService.instance.queryAllRows('months');
    final monthData =
        data.firstWhere((map) => map['id'] == monthId, orElse: () => {});
    if (monthData.isNotEmpty) {
      final month = Month.fromMap(monthData);
      await month.loadCategories();
      return month;
    }
    return null;
  }

  static Future<Map<String, dynamic>> ensureCurrentMonth() async {
    final db = await DatabaseService.instance.database;
    String currentMonth = DateFormat('MMMM yyyy').format(DateTime.now());

    final result = await db.query(
      'months',
      where: 'name = ?',
      whereArgs: [currentMonth],
    );

    if (result.isNotEmpty) {
      return {
        'newMonthId': result.first['id'] as int,
        'isNewMonthExist': false,
      };
    } else {
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
      };

      if (lastMonthData.isNotEmpty) {
        final lastMonth = lastMonthData.first;
        newMonthData['planned_income'] = lastMonth['planned_income'];
        newMonthData['planned_expense'] = lastMonth['planned_expense'];
        newMonthData['planned_balance'] = lastMonth['planned_balance'];
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

      return {
        'newMonthId': newMonthId,
        'isNewMonthExist': true,
      };
    }
  }
}
