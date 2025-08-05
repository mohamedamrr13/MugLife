import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:drinks_app/features/home/data/models/category_model.dart';

class HomeLocalDataSource {
  static Database? _db;

  final String tableCategories = 'categories';
  final String columnId = 'id';
  final String columnName = 'name';
  final String columnImage = 'image';

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'categories.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableCategories (
            $columnName TEXT,
            $columnImage TEXT
          )
        ''');
      },
    );
  }

  Future<void> cacheCategories(List<CategoryModel> categories) async {
    final db = await database;

    await db.delete(tableCategories);

    for (final category in categories) {
      await db.insert(tableCategories, {
        columnName: category.name,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<List<CategoryModel>> getCachedCategories() async {
    final db = await database;
    final maps = await db.query(tableCategories);

    if (maps.isEmpty) return [];

    return maps.map((map) {
      return CategoryModel(
        name: map[columnName] as String,
        image: map[columnImage] as String,
      );
    }).toList();
  }
}
