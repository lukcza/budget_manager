import 'dart:ffi';

import '../services/database_service.dart';
import 'option.dart';

class Category {
  int? id;
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

  Future<List<Option>> loadOptionsList() async {
    if (id != null) {
      options = await Option.getByCategoryId(id!);
      totalPlannedCost =
          options.fold(0.0, (sum, option) => sum + option.plannedCost);
      totalActualCost =
          options.fold(0.0, (sum, option) => sum + option.actualCost);
    }
    return options;
  }

  static Future<List<Category>> getByMonthId(int monthId) async {
    final data = await DatabaseService.instance.queryAllRows('categories');
    List<Category> list = data
        .where((map) => map['month_id'] == monthId)
        .map((map) => Category.fromMap(map))
        .toList();
    for (var item in list) {
      await item.loadOptions();
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
  static Future<Category> getCurrentMonthCategoryByName(String name, int monthId) async {
    List<Category> listOfCategories =  await Category.getByMonthId(monthId);
    Category matchingCategory = listOfCategories.firstWhere((category)=> category.name == name);
    return matchingCategory;
  }
  static Future<Category?> getById(int categoryId) async {
    final data = await DatabaseService.instance.queryAllRows('categories');
    final categoryData =
        data.firstWhere((map) => map['id'] == categoryId, orElse: () => {});
    if (categoryData.isNotEmpty) {
      final category = Category.fromMap(categoryData);
      await category.loadOptions();
      return category;
    }
    return null;
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

  static Future insertCategoriesOfTemplate(int monthId) async {
    Category zywnoscCategory = Category(monthId: monthId, name: "Żywność");
    Category utrzymanieDomuCategory =
        Category(monthId: monthId, name: "Utrzymanie domu");
    Category transportCategory = Category(monthId: monthId, name: "Transport");
    Category rozrywkaCategory = Category(monthId: monthId, name: "Rozrywka");
    Category inneCategory = Category(monthId: monthId, name: "Inne");
    List<Category> listOfCategory = [
      zywnoscCategory,
      utrzymanieDomuCategory,
      transportCategory,
      rozrywkaCategory,
      inneCategory,
    ];

    // Najpierw zapisz kategorie, żeby mieć ich ID
    for (var category in listOfCategory) {
      await category.save();
    }
    zywnoscCategory = await Category.getCurrentMonthCategoryByName(zywnoscCategory.name, monthId);
    utrzymanieDomuCategory = await Category.getCurrentMonthCategoryByName(utrzymanieDomuCategory.name, monthId);
    transportCategory = await Category.getCurrentMonthCategoryByName(transportCategory.name, monthId);
    rozrywkaCategory = await Category.getCurrentMonthCategoryByName(rozrywkaCategory.name, monthId);
    inneCategory = await Category.getCurrentMonthCategoryByName(inneCategory.name, monthId);
    zywnoscCategory.options = [
      Option(categoryId: zywnoscCategory.id!, name: "Obiad"),
      Option(categoryId: zywnoscCategory.id!, name: "Kolacja"),
      Option(categoryId: zywnoscCategory.id!, name: "Śniadanie"),
      Option(categoryId: zywnoscCategory.id!, name: "Deser"),
      Option(categoryId: zywnoscCategory.id!, name: "Napoje"),
      Option(categoryId: zywnoscCategory.id!, name: "Inne"),
    ];
    utrzymanieDomuCategory.options = [
      Option(categoryId: utrzymanieDomuCategory.id!, name: "Czynsz"),
      Option(categoryId: utrzymanieDomuCategory.id!, name: "Prąd"),
      Option(categoryId: utrzymanieDomuCategory.id!, name: "Internet"),
      Option(categoryId: utrzymanieDomuCategory.id!, name: "Woda"),
      Option(categoryId: utrzymanieDomuCategory.id!, name: "Gaz"),
      Option(
          categoryId: utrzymanieDomuCategory.id!, name: "Artykuły czystości"),
      Option(categoryId: utrzymanieDomuCategory.id!, name: "Inne"),
    ];
    transportCategory.options = [
      Option(categoryId: transportCategory.id!, name: "Paliwo"),
      Option(categoryId: transportCategory.id!, name: "Ubezpieczenie"),
      Option(categoryId: transportCategory.id!, name: "Komunikacja miejska"),
      Option(categoryId: transportCategory.id!, name: "Inne"),
    ];
    rozrywkaCategory.options = [
      Option(categoryId: rozrywkaCategory.id!, name: "Subskrypcje media"),
      Option(categoryId: rozrywkaCategory.id!, name: "Imprezy"),
      Option(categoryId: rozrywkaCategory.id!, name: "Inne"),
    ];
    inneCategory.options = [
      Option(categoryId: inneCategory.id!, name: "Inne"),
    ];
    List<Category> listToSave = [
      zywnoscCategory,
      utrzymanieDomuCategory,
      transportCategory,
      rozrywkaCategory,
      inneCategory,
    ];
    for (var item in listToSave) {
      for (var item in item.options) {
        await item.save();
      }
      await item.save();
    }
  }
}
