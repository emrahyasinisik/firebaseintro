import 'dart:convert';

class UserModel {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  DateTime? registerDate;

  UserModel(
      {this.id, this.firstName, this.lastName, this.email, this.registerDate});

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (id != null) {
      result.addAll({'id': id});
    }
    if (firstName != null) {
      result.addAll({'firstName': firstName});
    }
    if (lastName != null) {
      result.addAll({'lastName': lastName});
    }
    if (email != null) {
      result.addAll({'email': email});
    }
    if (registerDate != null) {
      result.addAll({'registerDate': registerDate!.millisecondsSinceEpoch});
    }

    return result;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      email: map['email'],
      registerDate: map['registerDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['registerDate'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
}
