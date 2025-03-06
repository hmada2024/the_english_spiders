//lib/data/repositories/phrasal_verb_repository.dart
import 'package:the_english_spiders/core/config/database_constants.dart';
import 'package:the_english_spiders/data/database/database_helper.dart';
import 'package:the_english_spiders/data/models/phrasal_verb_model.dart';
import 'package:the_english_spiders/data/repositories/generic_repository.dart';

class PhrasalVerbRepository extends GenericRepository<PhrasalVerb> {
  PhrasalVerbRepository(DatabaseHelper dbHelper)
      : super(
            dbHelper: dbHelper,
            tableName: Constants.phrasalVerbsTable,
            fromMap: PhrasalVerb.fromMap,
          );
}