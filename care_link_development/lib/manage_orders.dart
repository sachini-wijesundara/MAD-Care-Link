import 'package:care_link_development/model/order.dart';
import 'package:care_link_development/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManageOrdersScreen extends StatefulWidget {
  const ManageOrdersScreen({super.key});

  @override
  State<ManageOrdersScreen> createState() => _ManageOrdersScreenState();
}

class _ManageOrdersScreenState extends State<ManageOrdersScreen> {
  @override
  void initState() {
    _refreshOrders();
    super.initState();
  }

  Future<void> _refreshOrders() async {
    await context.read<OrderProvider>().fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Manage Orders'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment(0.0, -0.2),
            colors: [Color(0xFFB3DFFC), Colors.white],
          ),
        ),
        child:
            context.watch<OrderProvider>().isLoading
                ? Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(),
                  ),
                )
                : SafeArea(
                  child: Column(
                    children: [
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(
                      //     horizontal: 16,
                      //     vertical: 4,
                      //   ),
                      //   child: Row(
                      //     children: [
                      //       Expanded(
                      //         child: TextField(
                      //           decoration: InputDecoration(
                      //             hintText: 'Order_ID',
                      //             prefixIcon: const Icon(Icons.search),
                      //             contentPadding: const EdgeInsets.symmetric(
                      //               horizontal: 12,
                      //             ),
                      //             border: OutlineInputBorder(
                      //               borderRadius: BorderRadius.circular(8),
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      const SizedBox(height: 12),

                      // Orders List
                      Expanded(
                        child: Consumer<OrderProvider>(
                          builder: (context, orderProvider, child) {
                            if (orderProvider.orders.isEmpty) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'No orders placed yet',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                            return ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: orderProvider.orders.length,
                              itemBuilder: (context, index) {
                                return OrderCard(
                                  order: orderProvider.orders[index],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final OrderModel order;

  const OrderCard({super.key, required this.order});

  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Order'),
          content: const Text('Are you sure you want to cancel this order?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                context.read<OrderProvider>().deleteOrder(order);
                Navigator.of(context).pop();
              },
              child:
                  context.watch<OrderProvider>().isLoading
                      ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : const Text('Yes', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    order.product.imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[200],
                        child: const Icon(Icons.image_not_supported),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                // Order Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order #${order.dateTime}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Chip(
                            label: Text(
                              "Pending",
                              style: const TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.blue,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
            Text('Customer: ${order.username}'),
            Text('Date: ${order.dateTime}'),
            Text('Total: LKR ${order.product.price.toStringAsFixed(2)}'),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => _showDeleteConfirmationDialog(context),
                  child: const Text('Cancel Details'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
