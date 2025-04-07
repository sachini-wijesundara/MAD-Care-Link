import 'package:care_link_development/model/order.dart';
import 'package:care_link_development/services/firebase_services.dart';
import 'package:flutter/widgets.dart';

class OrderProvider extends ChangeNotifier {
  List<OrderModel> _orders = [];
  bool isLoading = false;
  final FirebaseService _firebaseService = FirebaseService();

  List<OrderModel> get orders => _orders;

  Future<void> createOrder(OrderModel order) async {
    try {
      isLoading = true;
      notifyListeners();

      await _firebaseService.uploadOrder("Orders", order, order.id);

      addOrder(order);
    } catch (error) {
      print("Error creating order: $error");
      throw error;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchOrders() async {
    try {
      isLoading = true;
      notifyListeners();
      await _firebaseService.getDocuments("Orders").then((value) {
        _orders =
            value.docs
                .map(
                  (doc) =>
                      OrderModel.fromMap(doc.data() as Map<String, dynamic>),
                )
                .toList();
      });
      notifyListeners();
    } catch (error) {
      print("Error fetching orders: $error");
      throw error;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteOrder(OrderModel orderDelete) async {
    try {
      isLoading = true;
      notifyListeners();

      await _firebaseService.deleteDocument("Orders", orderDelete.id);
      _orders.removeWhere((order) => order.id == orderDelete.id);
      notifyListeners();
    } catch (error) {
      print("Error deleting order: $error");
      throw error;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void addOrder(OrderModel order) {
    _orders.add(order);
    printAllOrders(); // Add this line
    notifyListeners();
  }

  void removeOrder(OrderModel order) {
    _orders.remove(order);
    notifyListeners();
  }

  void clearOrders() {
    _orders.clear();
    notifyListeners();
  }

  void printAllOrders() {
    print('\n=== All Orders ===');
    for (var order in _orders) {
      print('Order: ${order.product.name}');
      print('By: ${order.username} (${order.userEmail})');
      print('Date: ${order.dateTime}');
      print('---');
    }
    print('================\n');
  }
}
