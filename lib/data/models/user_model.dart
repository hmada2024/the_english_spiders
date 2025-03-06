// lib/users/models/user_model.dart
import 'package:the_english_spiders/core/config/database_constants.dart';

class UserModel {
  int? id;
  String name;
  String? password;
  String gender;
  String? creationDate;

  UserModel({
    this.id,
    required this.name,
    this.password,
    required this.gender,
    this.creationDate,
  });

  Map<String, dynamic> toMap() {
    return {
      Constants.userIdColumn: id,
      Constants.userNameColumn: name,
      Constants.userPasswordColumn: password,
      Constants.userGenderColumn: gender,
      Constants.userCreationDateColumn: creationDate, // إضافة هذا الحقل هنا
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map[Constants.userIdColumn],
      name: map[Constants.userNameColumn],
      password: map[Constants.userPasswordColumn],
      gender: map[Constants.userGenderColumn],
      creationDate:
          map[Constants.userCreationDateColumn], // إضافة هذا الحقل هنا
    );
  }
  UserModel copyWith({
    int? id,
    String? name,
    String? password,
    String? gender,
    String? creationDate,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      password: password ?? this.password,
      gender: gender ?? this.gender,
      creationDate: creationDate ?? this.creationDate,
    );
  }

  @override
  String toString() {
    return 'UserModel{id: $id, name: $name, gender: $gender, creationDate: $creationDate}';
  }
}
