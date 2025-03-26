import '../services/database_service.dart';
import 'option.dart';

class Category {
  final int? id;
  final int monthId;
  final String name;
  List<Option> options = [];
  double totalPlannedCost = 0.0;
  double totalActualCost = 0.0;

  Category({this.id, required this.monthId, required this.name});

  Map<String, dynamic> toMap() => {
        'id': id,
        'month_id': monthId,
        'name': name,
      };

  factory Category.fromMap(Map<String, dynamic> map) => Category(
        id: map['id'],
        monthId: map['month_id'],
        name: map['name'],
      );

  Future<void> loadOptions() async {
    if (id != null) {
      options = await Option.getByCategoryId(id!);
      totalPlannedCost =
          options.fold(0.0, (sum, option) => sum + option.plannedCost);
      totalActualCost =
          options.fold(0.0, (sum, option) => sum + option.actualCost);
    }
  }

  static Future<List<Category>> getByMonthId(int monthId) async {
    final data = await DatabaseService.instance.queryAllRows('categories');
    List<Category> list = data
        .where((map) => map['month_id'] == monthId)
        .map((map) => Category.fromMap(map))
        .toList();
    for(var item in list){
      item.loadOptions();
    }
    return list;
  }

  Future<int> save() async {
    if (id == null) {
      return await DatabaseService.instance.insert('categories', toMap());
    } else {
      return await DatabaseService.instance.update('categories', toMap(), id!);
    }
  }
  static Future<Category?> getById(int categoryId) async{
    final data = await DatabaseService.instance.queryAllRows('categories');
    final categoryData = data.firstWhere((map) => map['id'] == categoryId,
        orElse: () => {});
    if(categoryData.isNotEmpty){
      final category = Category.fromMap(categoryData);
      await category.loadOptions();
      return category;
    }
  }
  Future<int?> getCategoryId() async {
    final db = await DatabaseService.instance.database;
    final result = await db.query(
      'categories',
      where: 'name = ?',
      whereArgs: [this.name],
    );
    if (result.isNotEmpty) {
      return result.first['id'] as int;
    } else {
      return null;
    }
  }

  static Future<int> delete(int id) async {
    return await DatabaseService.instance.delete('categories', id);
  }
}
