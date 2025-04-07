import 'package:cloud_firestore/cloud_firestore.dart';
import 'user.dart';

class AppointmentModel {
  final String id;
  final UserModel user;
  final String doctorName;
  final double price;
  final DateTime bookedDateTime;
  final String appointmentDay;
  final String appointmentTime;
  final String specialty;
  final String appointmentNo;

  AppointmentModel({
    required this.id,
    required this.user,
    required this.doctorName,
    required this.price,
    required this.bookedDateTime,
    required this.appointmentDay,
    required this.appointmentTime,
    required this.specialty,
    required this.appointmentNo,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user': user.toMap(),
      'doctorName': doctorName,
      'price': price,
      'bookedDateTime': Timestamp.fromDate(bookedDateTime),
      'appointmentDay': appointmentDay,
      'appointmentTime': appointmentTime,
      'specialty': specialty,
      'appointmentNo': appointmentNo,
    };
  }

  factory AppointmentModel.fromMap(Map<String, dynamic> map) {
    return AppointmentModel(
      id: map['id'] ?? '',
      user: UserModel.fromMapData(map['user']), // Use the new method
      doctorName: map['doctorName'] ?? '',
      price: map['price'] ?? 0.0,
      bookedDateTime: (map['bookedDateTime'] as Timestamp).toDate(),
      appointmentDay: map['appointmentDay'] ?? '',
      appointmentTime: map['appointmentTime'] ?? '',
      specialty: map['specialty'] ?? '',
      appointmentNo: map['appointmentNo'] ?? '',
    );
  }
}
