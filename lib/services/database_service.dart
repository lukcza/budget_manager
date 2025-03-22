import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('budget.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const doubleType = 'REAL NOT NULL';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
      CREATE TABLE months (
        id $idType,
        name $textType,
        planned_income $doubleType,
        actual_income $doubleType,
        planned_expense $doubleType,
        actual_expense $doubleType,
        planned_balance $doubleType,
        actual_balance $doubleType,
        total_planned_expenses $doubleType,
        total_actual_expenses $doubleType
      )
    ''');

    await db.execute('''
      CREATE TABLE categories (
        id $idType,
        month_id INTEGER NOT NULL,
        name $textType,
        FOREIGN KEY (month_id) REFERENCES months (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE options (
        id $idType,
        category_id INTEGER NOT NULL,
        name $textType,
        planned_cost $doubleType,
        actual_cost $doubleType,
        FOREIGN KEY (category_id) REFERENCES categories (id) ON DELETE CASCADE
      )
    ''');
    await db.execute('''
      CREATE TABLE payments (
        id $idType,
        option_id INTEGER NOT NULL,
        name $textType,
        cost $doubleType,
        FOREIGN KEY (option_id) REFERENCES options (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await instance.database;
    return await db.insert(table, data);
  }

  Future<List<Map<String, dynamic>>> queryAllRows(String table) async {
    final db = await instance.database;
    return await db.query(table);
  }

  Future<int> update(String table, Map<String, dynamic> data, int id) async {
    final db = await instance.database;
    return await db.update(table, data, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> delete(String table, int id) async {
    final db = await instance.database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  Future<List<Map<String, dynamic>>> getCategoriesForMonth(int monthId) async {
    final db = await instance.database;
    try {
      final List<Map<String, dynamic>> categories = await db.query(
        'categories',
        where: 'month_id = ?',
        whereArgs: [monthId],
      );
      return categories;
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }

  Future<int> createOption(int categoryId, String name, double plannedCost,
      double actualCost) async {
    final db = await instance.database;
    return await db.insert('options', {
      'category_id': categoryId,
      'name': name,
      'planned_cost': plannedCost,
      'actual_cost': actualCost,
    });
  }

  Future<int> createCategory(int monthId, String categoryName) async {
    final db = await instance.database;
    return await db.insert('categories', {
      'month_id': monthId,
      'name': categoryName,
    });
  }

  Future<int?> getCategoryId(String categoryName) async {
    final db = await instance.database;
    final result = await db.query(
      'categories',
      columns: ['id'],
      where: 'name = ?',
      whereArgs: [categoryName],
    );
    if (result.isNotEmpty) {
      return result.first['id'] as int;
    } else {
      return null;
    }
  }

  /*Future<int> ensureCurrentMonth() async {
    final db = await instance.database;
    String currentMonth = DateFormat('MMMM yyyy').format(DateTime.now());

    final result = await db.query(
      'months',
      where: 'name = ?',
      whereArgs: [currentMonth],
    );

    if (result.isEmpty) {
      return await db.insert('months', {
        'name': currentMonth,
        'planned_income': 0.0,
        'actual_income': 0.0,
        'planned_expense': 0.0,
        'actual_expense': 0.0,
        'planned_balance': 0.0,
        'actual_balance': 0.0,
        'total_planned_expenses': 0.0,
        'total_actual_expenses': 0.0,
      });
    } else {
      return result.first['id'] as int;
    }
  }*/

  Future<String?> getMonthNameById(int monthId) async {
    final db = await instance.database;
    final result = await db.query(
      'months',
      columns: ['name'],
      where: 'id = ?',
      whereArgs: [monthId],
    );

    if (result.isNotEmpty) {
      return result.first['name'] as String;
    }
    return null;
  }
}
