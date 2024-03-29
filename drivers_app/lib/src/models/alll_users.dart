import 'package:firebase_database/firebase_database.dart';

class Users {
  String? id;
  String? email;
  String? name;
  String? lastName;
  String? phone;

  Users({
    this.id,
    this.email,
    this.name,
    this.lastName,
    this.phone,
  });

  Users.fromSnapshot(DataSnapshot dataSnapshot) {
    id = dataSnapshot.key;
    email = dataSnapshot.value["email"];
    name = dataSnapshot.value["name"];
    lastName = dataSnapshot.value["lastName"];
    phone = dataSnapshot.value["phone"];
  }
}
