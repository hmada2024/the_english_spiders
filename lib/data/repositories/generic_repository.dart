//lib/data/repositories/generic_repository.dart
import 'package:the_english_spiders/data/database/database_helper.dart';
import 'package:the_english_spiders/data/repositories/base_repository.dart';
import 'package:sqflite/sqflite.dart';

abstract class GenericRepository<T> implements BaseRepository<T> {
  final DatabaseHelper dbHelper;
  final String tableName;
  final T Function(Map<String, dynamic>) fromMap;

  GenericRepository({
    required this.dbHelper,
    required this.tableName,
    required this.fromMap,
  });

  @override
  Future<List<T>> getAll() async {
    final Database db = await dbHelper.database;
    try {
        final List<Map<String, dynamic>> maps = await db.query(tableName);
        return maps.map(fromMap).toList();
    }catch (e)
    {
         throw Exception('Failed to load data from $tableName: ${e.toString()}');
    }
  }
}