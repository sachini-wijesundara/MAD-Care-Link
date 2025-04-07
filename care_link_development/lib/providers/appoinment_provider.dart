import 'package:care_link_development/model/appoinment.dart';
import 'package:care_link_development/services/firebase_services.dart';
import 'package:flutter/material.dart';

class AppoinmentProvider extends ChangeNotifier {
  List<AppointmentModel> _appointments = [];
  bool isLoading = false;
  final FirebaseService _firebaseService = FirebaseService();

  List<AppointmentModel> get appointments => _appointments;

  Future<void> fetchAppoinments() async {
    try {
      _appointments = [];
      isLoading = true;
      notifyListeners();
      final snapshot = await _firebaseService.getDocuments("Appoinments");

      if (snapshot.docs.isNotEmpty) {
        _appointments =
            snapshot.docs
                .map(
                  (doc) => AppointmentModel.fromMap(
                    doc.data() as Map<String, dynamic>,
                  ),
                )
                .toList();
      }
      notifyListeners();
    } catch (error) {
      print("Error fetching appoinments: $error");
      throw error;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createAppoinment(AppointmentModel appoinment) async {
    try {
      isLoading = true;
      notifyListeners();

      await _firebaseService.uploadAppoinment(
        "Appoinments",
        appoinment,
        appoinment.id,
      );

      addAppointment(appoinment);
    } catch (error) {
      print("Error creating order: $error");
      throw error;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteAppoinment(AppointmentModel appoinmentDelete) async {
    try {
      isLoading = true;
      notifyListeners();

      await _firebaseService.deleteDocument("Appoinments", appoinmentDelete.id);
      _appointments.removeWhere(
        (appoinment) => appoinment.id == appoinmentDelete.id,
      );
    } catch (error) {
      print("Error deleting order: $error");
      throw error;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void addAppointment(AppointmentModel appointment) {
    _appointments.add(appointment);
    notifyListeners();
  }

  void removeAppointment(AppointmentModel appointment) {
    _appointments.remove(appointment);
    notifyListeners();
  }

  void printAllAppoinments() {
    print('\n=== All Appoinmnets ===');
    for (var order in _appointments) {
      print('Appionment: ${order.doctorName}');
      print('By: ${order.user.username} (${order.appointmentDay})');
      print('Date: ${order.bookedDateTime}');
      print('---');
    }
    print('================\n');
  }
}
