class RecordModel {
  final DateTime date;
  final String name;
  final String prescription;
  final String image;

  RecordModel({
    required this.date,
    required this.image,
    required this.name,
    required this.prescription,
  });
  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'month': date.month.toString(),
      'name': name,
      'prescription': prescription,
    };
  }

  factory RecordModel.fromMap(Map<String, dynamic> map) {
    return RecordModel(
      date: map['date'] ?? '',
      image: map['image'] ?? '',
      name: map['name'] ?? '',
      prescription: map['prescription'] ?? '',
    );
  }
}
