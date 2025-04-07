import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String username;
  final String email;
  final String contactNumber;
  final String address;
  final String bloodType;
  final String dateOfBirth;

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    required this.contactNumber,
    this.address = '',
    this.bloodType = '',
    this.dateOfBirth = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'contactNumber': contactNumber,
      'address': address,
      'bloodType': bloodType,
      'dateOfBirth': dateOfBirth,
    };
  }

  factory UserModel.fromMap(DocumentSnapshot doc) {
    if (!doc.exists) {
      throw StateError('Document does not exist');
    }

    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return UserModel(
      uid: data['uid'] ?? '',
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      contactNumber: data['contactNumber'] ?? '',
      address: data['address'] ?? '',
      bloodType: data['bloodType'] ?? '',
      dateOfBirth: data['dateOfBirth'] ?? '',
    );
  }

  factory UserModel.fromMapData(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] ?? '',
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      contactNumber: data['contactNumber'] ?? '',
      address: data['address'] ?? '',
      bloodType: data['bloodType'] ?? '',
      dateOfBirth: data['dateOfBirth'] ?? '',
    );
  }
}
