//lib/data/repositories/user_repository.dart
import 'package:the_english_spiders/core/config/database_constants.dart';
import 'package:the_english_spiders/data/models/user_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';
import 'package:the_english_spiders/data/database/database_helper.dart';

class UserRepository {
  final DatabaseHelper _databaseHelper;

  UserRepository(this._databaseHelper);

  Future<UserModel?> getUserByUsername(String username) async {
    final Database db = await _databaseHelper.getUserDatabase(username);
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        Constants.usersTable,
        where: '${Constants.userNameColumn} = ?',
        whereArgs: [username],
      );

      if (maps.isNotEmpty) {
        return UserModel.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      debugPrint("Error in getUserByUsername: $e");
      return null; // Or throw an exception, depending on your error handling
    }
  }

  Future<int> insertUser(UserModel user) async {
    final Database db = await _databaseHelper.getUserDatabase(user.name); // استخدام اسم المستخدم هنا
    try {
      return await db.insert(
        Constants.usersTable,
        user.toMap(),
        conflictAlgorithm:
            ConflictAlgorithm.replace, // Or .ignore, depending on your needs
      );
    } catch (e) {
      debugPrint("Error in insertUser: $e");
      rethrow;
    }
  }

  Future<int> updateUser(UserModel user) async {
   final Database db = await _databaseHelper.getUserDatabase(user.name); // استخدام اسم المستخدم هنا
    try {
      return await db.update(
        Constants.usersTable,
        user.toMap(),
        where: '${Constants.userIdColumn} = ?',
        whereArgs: [user.id],
      );
    } catch (e) {
      debugPrint("Error in updateUser: $e");
      rethrow;
    }
  }
}