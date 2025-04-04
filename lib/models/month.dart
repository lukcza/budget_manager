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
      print(categories);
    }
  }

  Future<void> updateVariables() async {
    plannedExpense = 0;
    actualExpense = 0;
    plannedBalance = 0;
    actualBalance = 0;
    for (var item in categories) {
      plannedExpense += item.totalPlannedCost;
      actualExpense += item.totalActualCost;
    }
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

  static Future<Month?> getMonthSummary(int monthId) async {
    final data = await DatabaseService.instance.queryAllRows('months');
    final monthData =
        data.firstWhere((map) => map['id'] == monthId, orElse: () => {});
    if (monthData.isNotEmpty) {
      final month = Month.fromMap(monthData);
      if (month.id != null) {
        final categoryData =
            await DatabaseService.instance.queryAllRows('categories');
        List<Category> list = categoryData
            .where((map) => map['month_id'] == monthId)
            .map((map) => Category.fromMap(map))
            .toList();
        for (var item in list) {
          await item.loadOptions();
        }
        month.categories = list;
        month.plannedExpense = 0;
        month.actualExpense = 0;
        month.plannedBalance = 0;
        month.actualBalance = 0;
        for (var item in month.categories) {
          month.plannedExpense += item.totalPlannedCost;
          month.actualExpense += item.totalActualCost;
        }
        month.plannedBalance = month.plannedIncome - month.plannedExpense;
        month.actualBalance =
            month.plannedIncome + month.actualIncome - month.actualExpense;
      }
      return month;
    }
    return null;
  }

  static Future<Map<String, dynamic>> ensureCurrentMonth() async {
    final db = await DatabaseService.instance.database;
    String currentMonth = DateFormat('MMMM yyyy').format(DateTime.now());
    currentMonth = getPolishMonthName(currentMonth);
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

String getPolishMonthName(String input) {
  Map<String, String> monthNames = {
    "January": "Styczeń",
    "February": "Luty",
    "March": "Marzec",
    "April": "Kwiecień",
    "May": "Maj",
    "June": "Czerwiec",
    "July": "Lipiec",
    "August": "Sierpień",
    "September": "Wrzesień",
    "October": "Październik",
    "November": "Listopad",
    "December": "Grudzień",
  };

  try {
    List<String> parts = input.split(" ");
    String month = parts[0];
    String year = parts[1];

    return "${monthNames[month] ?? 'Nieznany miesiąc'} $year";
  } catch (e) {
    return input;
  }
}
