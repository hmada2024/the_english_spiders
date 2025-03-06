//lib/data/repositories/noun_repository.dart
import 'package:the_english_spiders/core/config/database_constants.dart';
import 'package:the_english_spiders/data/database/database_helper.dart';
import 'package:the_english_spiders/data/models/nouns_model.dart';
import 'package:the_english_spiders/data/repositories/generic_repository.dart';

class NounRepository extends GenericRepository<Noun> {
  NounRepository(DatabaseHelper dbHelper)
      : super(
            dbHelper: dbHelper,
            tableName: Constants.nounsTable,
            fromMap: Noun.fromMap,
          );

    Future<List<String>> getAllCategories() async {
      final db = await dbHelper.database;
      try {
            final List<Map<String, dynamic>> maps = await db.query(
              Constants.nounsTable,
              columns: [Constants.nounCategoryColumn],
              distinct: true,
            );
            return maps.map((map) => map[Constants.nounCategoryColumn] as String).toList();
      } catch (e) {
            throw Exception('Failed to load all noun categories: ${e.toString()}');
      }

    }
    Future<List<Noun>> getNounsByCategory(String category) async {
       final db = await dbHelper.database;
       List<Map<String, dynamic>> maps;
       try{
        if (category == 'all') {
            maps = await db.query(Constants.nounsTable);
        } else {
            maps = await db.query(
                Constants.nounsTable,
                where: '${Constants.nounCategoryColumn} = ?',
                whereArgs: [category],
            );
        }
       }catch(e)
       {
         throw Exception('Failed to load nouns By Category: ${e.toString()}');
       }
        return maps.map(fromMap).toList();
    }

     Future<List<Noun>> getNounsForMatchingQuiz() async {
        final db = await dbHelper.database;
        try {
            final List<Map<String, dynamic>> maps =
                await db.query(Constants.nounsTable);
            return maps.map((e) => Noun.fromMap(e)).toList();
        } catch (e) {
            throw Exception('Failed to load nouns for matching quiz: ${e.toString()}');
        }
  }
}