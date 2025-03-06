//lib/data/repositories/verb_conjugations_repository.dart
import 'package:the_english_spiders/core/config/database_constants.dart';
import 'package:the_english_spiders/data/database/database_helper.dart';
import 'package:the_english_spiders/data/models/verb_conjugations_models.dart';
import 'package:the_english_spiders/data/repositories/generic_repository.dart';

class VerbConjugationsRepository extends GenericRepository<Verb> {
  VerbConjugationsRepository(DatabaseHelper dbHelper)
      : super(
            dbHelper: dbHelper,
            tableName: Constants.verbsTable,
            fromMap: Verb.fromMap,
          );

  Future<List<Conjugations>> getConjugations(int verbId) async {
    final db = await dbHelper.database;
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        Constants.conjugationsTable,
        where: '${Constants.conjugationVerbIdColumn} = ?',
        whereArgs: [verbId],
      );
      return maps.map((map) => Conjugations.fromMap(map)).toList();
    } catch (e) {
      throw Exception('Failed to load conjugations: ${e.toString()}');
    }
  }
}