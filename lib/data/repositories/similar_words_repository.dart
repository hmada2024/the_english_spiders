// lib/data/repositories/similar_words_repository.dart
import 'package:the_english_spiders/core/config/database_constants.dart'; // Import
import 'package:the_english_spiders/data/database/database_helper.dart';
import 'package:the_english_spiders/data/models/similar_words_models.dart';

class SimilarWordsRepository {
  final DatabaseHelper dbHelper;

  SimilarWordsRepository(this.dbHelper);

  Future<List<SeedWithBranches>> getAllSeedsWithBranches() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> seedMaps =
        await db.query(Constants.verbsSeedsTable);

    final List<SeedWithBranches> result = [];
    for (final seedMap in seedMaps) {
      final SeedWord seed = SeedWord.fromMap(seedMap);
      final List<Map<String, dynamic>> branchMaps = await db.query(
        Constants.verbsBranchesTable,
        where: '${Constants.branchSeedIdColumn} = ?',
        whereArgs: [seed.id],
      );
      final List<BranchWord> branches =
          branchMaps.map((branchMap) => BranchWord.fromMap(branchMap)).toList();
      result.add(SeedWithBranches(seed: seed, branches: branches));
    }
    return result;
  }
}