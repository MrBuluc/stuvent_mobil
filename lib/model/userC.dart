import 'package:flutter/material.dart';

class UserC {
  String userID;
  String email;
  String userName;
  String lastName;
  String profilURL;
  bool superUser = false;
  List<dynamic> etkinlikler;

  UserC(
      {@required this.userID,
      @required this.email,
      this.userName,
      this.lastName,
      this.superUser,
      this.etkinlikler});

  Map<String, dynamic> toMap() {
    return {
      'Ad': userName,
      "Soyad": lastName,
      'E-mail': email,
      'Etkinlikler': etkinlikler,
      'SuperUser': superUser,
      "UserID": userID
    };
  }

  UserC.userfromMap(Map<String, dynamic> map)
      : userID = map['UserID'],
        email = map['E-mail'],
        userName = map['Ad'],
        lastName = map["Soyad"],
        superUser = map["SuperUser"],
        etkinlikler = map["Etkinlikler"];
  //profilURL = map['profilURL'],

  UserC.idveResim({@required this.userID, @required this.profilURL});

  @override
  String toString() {
    return 'User{userID: $userID, email: $email, userName: $userName, lastname: $lastName, superUser: $superUser}';
  }
}
