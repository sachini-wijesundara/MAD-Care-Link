import 'package:care_link_development/model/record.dart';
import 'package:flutter/material.dart';

class RecordesProvider extends ChangeNotifier {
  List<RecordModel> records = [];

  void addRecord(RecordModel record) {
    // Ensure date is a valid DateTime object
    if (record.date is String) {
      try {
        record = RecordModel(
          name: record.name,
          prescription: record.prescription,
          image: record.image,
          date: DateTime.parse(record.date as String),
        );
      } catch (e) {
        debugPrint('Error parsing date: $e');
        return;
      }
    }

    records.add(record);
    notifyListeners();
  }

  void removeRecord(RecordModel record) {
    records.remove(record);
    notifyListeners();
  }
}
