//lib/data/repositories/compound_word_repository.dart
import 'package:the_english_spiders/core/config/database_constants.dart';
import 'package:the_english_spiders/data/database/database_helper.dart';
import 'package:the_english_spiders/data/models/compound_word_model.dart';
import 'package:the_english_spiders/data/repositories/generic_repository.dart';

class CompoundWordRepository extends GenericRepository<CompoundWord> {
  CompoundWordRepository(DatabaseHelper dbHelper)
      : super(
            dbHelper: dbHelper,
            tableName: Constants.compoundWordsTable,
            fromMap: CompoundWord.fromMap,
          );
}