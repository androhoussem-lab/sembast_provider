import 'package:flutter/foundation.dart';

class User{
  int id;
  final int userId;
  final String name ;
  final String email;
  final String phone;
  final bool isAdmin;

  User({
    @required this.userId,
    @required this.name,
    @required this.email,
    @required this.phone,
    @required this.isAdmin});

  Map<String,dynamic> toMap(){
    return {
      'userId' : this.userId,
      'name' : this.name ,
      'email' : this.email ,
      'phone' : this.phone ,
      'isAdmin' : this.isAdmin
    };
  }

  static User  fromMap(Map<String,dynamic> map){
    return User(userId: map['userId'], name: map['name'], email: map['email'],phone: map['phone'] , isAdmin: map['isAdmin']);
  }
}

