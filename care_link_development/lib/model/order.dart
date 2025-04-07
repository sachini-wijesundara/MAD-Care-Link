import 'package:care_link_development/model/product.dart';

class OrderModel {
  final String id;
  final String username;
  final String userEmail;
  final Product product;
  final DateTime dateTime;

  OrderModel({
    required this.id,
    required this.username,
    required this.userEmail,
    required this.product,
    required this.dateTime,
  });

  // Convert to a map for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'userEmail': userEmail,
      'product': product.toMap(),
      'dateTime': dateTime.toIso8601String(),
    };
  }

  // Create an Order from a map
  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] ?? '',
      username: map['username'] ?? '',
      userEmail: map['userEmail'] ?? '',
      product: Product.fromMap(map['product'] ?? {}),
      dateTime: DateTime.parse(
        map['dateTime'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}
