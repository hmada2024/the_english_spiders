//lib/data/repositories/adjective_repository.dart
import 'package:the_english_spiders/core/config/database_constants.dart';
import 'package:the_english_spiders/data/database/database_helper.dart';
import 'package:the_english_spiders/data/models/adjective_model.dart';
import 'package:the_english_spiders/data/repositories/generic_repository.dart';

class AdjectiveRepository extends GenericRepository<Adjective> {
  AdjectiveRepository(DatabaseHelper dbHelper)
      : super(
            dbHelper: dbHelper,
            tableName: Constants.adjectivesTable,
            fromMap: Adjective.fromMap,
          );
}