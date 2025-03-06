//lib/data/repositories/modal_semi_modal_verb_repository.dart
import 'package:the_english_spiders/core/config/database_constants.dart';
import 'package:the_english_spiders/data/database/database_helper.dart';
import 'package:the_english_spiders/data/models/modal_semi_modal_verb_model.dart';
import 'package:the_english_spiders/data/repositories/generic_repository.dart';

class ModalSemiModalVerbRepository
    extends GenericRepository<ModalSemiModalVerb> {
  ModalSemiModalVerbRepository(DatabaseHelper dbHelper)
      : super(
            dbHelper: dbHelper,
            tableName: Constants.modalSemiModalVerbsTable,
            fromMap: ModalSemiModalVerb.fromMap,
          );
}