//lib/data/database_helper.dart
import 'package:the_english_spiders/core/config/database_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:the_english_spiders/data/models/adjective_model.dart';
import 'package:the_english_spiders/data/models/compound_word_model.dart';
import 'package:the_english_spiders/data/models/nouns_model.dart';
import 'package:the_english_spiders/data/models/verb_conjugations_models.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseHelper {
  static Database? _database;
  static DatabaseHelper? _databaseHelperInstance;
  static const String _dbCopyKey = 'db_copied'; // Key for SharedPreferences

  static DatabaseHelper getInstance() {
    _databaseHelperInstance ??= DatabaseHelper._internal();
    return _databaseHelperInstance!;
  }

  DatabaseHelper._internal();

  static Future<DatabaseHelper> initialize() async {
    final dbHelper = getInstance();
    await dbHelper.database;
    return dbHelper;
  }

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, Constants.databaseName);
    bool exists = await databaseExists(path);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool dbCopied = prefs.getBool(_dbCopyKey) ?? false;

    if (!exists || !dbCopied) {
      try {
        await Directory(dirname(path)).create(recursive: true);
        ByteData data = await rootBundle
            .load("assets/database_files/${Constants.databaseName}");
        List<int> bytes =
            data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        await File(path).writeAsBytes(bytes, flush: true);

        await prefs.setBool(_dbCopyKey, true);
        debugPrint("DatabaseHelper: Database copied from assets.");
      } catch (e) {
        debugPrint("DatabaseHelper: Error copying database from assets: $e");
        throw Exception("Failed to copy database from assets: $e");
      }
    }

    try {
      final db = await openDatabase(path);
      return db;
    } catch (e) {
      debugPrint("DatabaseHelper: failed to open the database: $e");
      throw Exception("Failed to open the database: $e");
    }
  }

  Future<Database> getUserDatabase(String username) async {
    debugPrint("DatabaseHelper: getUserDatabase called for user: $username"); // أضف هنا
    var databasesPath = await getDatabasesPath();
    // Use a *username-specific* path for the user database.
    var path =
        join(databasesPath, 'users', '${username}_${Constants.userDatabaseName}');
    debugPrint("DatabaseHelper: Database path: $path"); // أضف هنا
    // We *don't* copy a pre-populated user database.  We create it if it doesn't exist.
    if (!await databaseExists(path)) {
      try {
        await Directory(dirname(path)).create(recursive: true); // Create the directory
      } catch (e) {
        debugPrint("Error creating user database directory: $e");
        throw Exception("Failed to create user database directory: $e");
      }
    }
    // Now open/create
    try {
      final db = await openDatabase(
        path,
        version: 1, // Increment this if you change the schema
        onCreate: (Database db, int version) async {
          // Create the user-specific tables here.
          await db.execute('''
                        CREATE TABLE ${Constants.usersTable} (
                            ${Constants.userIdColumn} INTEGER PRIMARY KEY AUTOINCREMENT,
                            ${Constants.userNameColumn} TEXT UNIQUE,
                            ${Constants.userPasswordColumn} TEXT,
                            ${Constants.userGenderColumn} TEXT,
                            ${Constants.userCreationDateColumn} TEXT
                        )
                    ''');

          await db.execute('''
                        CREATE TABLE ${Constants.quizResultsTable} (
                            ${Constants.quizResultIdColumn} INTEGER PRIMARY KEY AUTOINCREMENT,
                            ${Constants.quizResultUserIdColumn} INTEGER,
                            ${Constants.quizTypeColumn} TEXT,
                            ${Constants.quizResultScoreColumn} INTEGER,
                            ${Constants.quizResultDateColumn} TEXT,
                            ${Constants.quizResultCorrectAnswersColumn} INTEGER,
                            ${Constants.quizResultTotalQuestionsColumn} INTEGER,
                            FOREIGN KEY (${Constants.quizResultUserIdColumn}) REFERENCES ${Constants.usersTable}(${Constants.userIdColumn})
                        )
                    ''');
        },
      );
      return db;
    } catch (e) {
      debugPrint("failed to create the user database: $e");
      throw Exception("failed to create the user database: $e");
    }
  }

  Future<List<Adjective>> getAdjectives() async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> maps =
          await db.query(Constants.adjectivesTable);
      return maps.map((map) => Adjective.fromMap(map)).toList();
    } catch (e) {
      debugPrint('DatabaseHelper: Error loading adjectives: $e');
      throw Exception('Failed to load adjectives. Please try again later.');
    }
  }

  Future<List<CompoundWord>> getCompoundWords() async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> maps =
          await db.query(Constants.compoundWordsTable);
      return maps.map((map) => CompoundWord.fromMap(map)).toList();
    } catch (e) {
      // Improved error handling
      debugPrint('DatabaseHelper: Error loading compound words: $e');
      throw Exception(
          'Failed to load compound words. Please try again later.');
    }
  }

  Future<List<Noun>> getNouns() async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> maps = await db.query(Constants.nounsTable);
      return maps.map((map) => Noun.fromMap(map)).toList();
    } catch (e) {
      debugPrint('DatabaseHelper: Error loading nouns: $e');
      throw Exception('Failed to load nouns. Please try again later.');
    }
  }

  Future<List<Noun>> getNounsByCategory(String category) async {
    final db = await database;
    try {
      List<Map<String, dynamic>> maps;

      if (category == 'all') {
        maps = await db.query(Constants.nounsTable);
      } else {
        maps = await db.query(
          Constants.nounsTable,
          where: '${Constants.nounCategoryColumn} = ?',
          whereArgs: [category],
        );
      }
      return maps.map((map) => Noun.fromMap(map)).toList();
    } catch (e) {
      // Improved error handling
      debugPrint('DatabaseHelper: Error loading nouns by category: $e');
      throw Exception(
          'Failed to load nouns by category. Please try again later.');
    }
  }

  Future<List<Noun>> getNounsForMatchingQuiz() async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> maps = await db.query(Constants.nounsTable);
      return maps.map((e) => Noun.fromMap(e)).toList();
    } catch (e) {
      debugPrint('DatabaseHelper: Error loading nouns for matching quiz: $e');
      throw Exception(
          'Failed to load nouns for matching quiz. Please try again later.');
    }
  }

  Future<List<Verb>> getVerbs() async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> maps = await db.query(Constants.verbsTable);

      return maps.map((map) => Verb.fromMap(map)).toList();
    } catch (e) {
      debugPrint('DatabaseHelper: Error loading verbs: $e');
      throw Exception('Failed to load verbs. Please try again later.');
    }
  }

  Future<List<Conjugations>> getConjugationsByVerbId(int verbId) async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        Constants.conjugationsTable,
        where: '${Constants.conjugationVerbIdColumn} = ?',
        whereArgs: [verbId],
      );
      return maps.map((map) => Conjugations.fromMap(map)).toList();
    } catch (e) {
      debugPrint('DatabaseHelper: Error loading conjugations by verb ID: $e');
      throw Exception(
          'Failed to load conjugations by verb ID. Please try again later.');
    }
  }
}