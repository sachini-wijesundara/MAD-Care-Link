import 'package:care_link_development/model/order.dart';
import 'package:care_link_development/model/product.dart';
import 'package:care_link_development/providers/order_provider.dart';
import 'package:care_link_development/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final List<String> categories = const [
    'All Products',
    'Personal Care & Hygiene',
    'Medical Equipment & Devices',
    'Dietary & Special Nutrition',
    'Baby & Maternity',
  ];

  // Sample product data
  final List<Product> _allProducts = [
    // Personal Care & Hygiene
    Product(
      name: 'Hand Sanitizer',
      category: 'Personal Care & Hygiene',
      description: 'Kills 99.9% of germs without water.',
      quantity: '500ml',
      expiryDate: '2026-12-31',
      manufactureDate: '2024-01-15',
      price: 450.00,
      imageUrl: "assets/hand_sanitizer.jpg",
    ),
    Product(
      name: 'Antibacterial Soap',
      category: 'Personal Care & Hygiene',
      description: 'For daily use to prevent infections.',
      quantity: '250ml',
      expiryDate: '2026-10-15',
      manufactureDate: '2024-02-20',
      price: 350.00,
      imageUrl: "assets/soap.jpg",
    ),
    Product(
      name: 'Toothpaste',
      category: 'Personal Care & Hygiene',
      description: 'Fluoride toothpaste for cavity protection.',
      quantity: '150g',
      expiryDate: '2026-08-31',
      manufactureDate: '2024-03-05',
      price: 250.00,
      imageUrl: "assets/toothpaste.jpg",
    ),

    // Medical Equipment & Devices
    Product(
      name: 'Digital Thermometer',
      category: 'Medical Equipment & Devices',
      description: 'Fast and accurate temperature readings.',
      quantity: '1 Unit',
      expiryDate: 'N/A',
      manufactureDate: '2023-12-10',
      price: 1200.00,
      imageUrl: "assets/hand_sanitizer.jpg",
    ),
    Product(
      name: 'Blood Pressure Monitor',
      category: 'Medical Equipment & Devices',
      description: 'Automatic BP monitoring with memory storage.',
      quantity: '1 Unit',
      expiryDate: 'N/A',
      manufactureDate: '2023-11-05',
      price: 3500.00,
      imageUrl: "assets/bp.jpg",
    ),
    Product(
      name: 'Pulse Oximeter',
      category: 'Medical Equipment & Devices',
      description: 'Measures blood oxygen saturation and pulse rate.',
      quantity: '1 Unit',
      expiryDate: 'N/A',
      manufactureDate: '2024-01-20',
      price: 2200.00,
      imageUrl: "assets/pulse.jpg",
    ),

    // Dietary & Special Nutrition
    Product(
      name: 'Multivitamin Tablets',
      category: 'Dietary & Special Nutrition',
      description: 'Daily supplement for overall health.',
      quantity: '60 Tablets',
      expiryDate: '2025-11-30',
      manufactureDate: '2024-01-10',
      price: 950.00,
      imageUrl: "assets/multi.jpg",
    ),
    Product(
      name: 'Protein Powder',
      category: 'Dietary & Special Nutrition',
      description: 'Whey protein for muscle recovery and growth.',
      quantity: '500g',
      expiryDate: '2025-09-15',
      manufactureDate: '2024-02-25',
      price: 1800.00,
      imageUrl: "assets/protine.jpg",
    ),
    Product(
      name: 'Omega-3 Capsules',
      category: 'Dietary & Special Nutrition',
      description: 'Fish oil supplement for heart health.',
      quantity: '90 Capsules',
      expiryDate: '2025-10-20',
      manufactureDate: '2024-03-15',
      price: 1200.00,
      imageUrl: "assets/omega.jpg",
    ),

    // Baby & Maternity
    Product(
      name: 'Baby Wipes',
      category: 'Baby & Maternity',
      description: 'Gentle, alcohol-free wipes for sensitive skin.',
      quantity: '80 Wipes',
      expiryDate: '2026-06-30',
      manufactureDate: '2024-02-10',
      price: 300.00,
      imageUrl: "assets/baby.jpg",
    ),
    Product(
      name: 'Baby Formula',
      category: 'Baby & Maternity',
      description: 'Nutritionally complete infant formula.',
      quantity: '400g',
      expiryDate: '2025-08-15',
      manufactureDate: '2024-01-25',
      price: 1500.00,
      imageUrl: "assets/baby_formula.jpg",
    ),
    Product(
      name: 'Prenatal Vitamins',
      category: 'Baby & Maternity',
      description: 'Essential vitamins and minerals for pregnant women.',
      quantity: '30 Tablets',
      expiryDate: '2025-07-20',
      manufactureDate: '2024-03-01',
      price: 850.00,
      imageUrl: "assets/prenatal.jpg",
    ),
  ];

  List<Product> _filteredProducts = [];
  String _selectedCategory = 'All Products';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredProducts = _allProducts;

    // Add listener to search field
    _searchController.addListener(_filterProducts);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterProducts() {
    setState(() {
      if (_searchController.text.isEmpty &&
          _selectedCategory == 'All Products') {
        _filteredProducts = _allProducts;
      } else {
        _filteredProducts =
            _allProducts.where((product) {
              bool matchesSearch =
                  _searchController.text.isEmpty ||
                  product.name.toLowerCase().contains(
                    _searchController.text.toLowerCase(),
                  );

              bool matchesCategory =
                  _selectedCategory == 'All Products' ||
                  product.category == _selectedCategory;

              return matchesSearch && matchesCategory;
            }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomRight,
          end: Alignment(0.0, -0.2),
          colors: [Color(0xFFB3DFFC), Colors.white],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          //automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text("Store", style: TextStyle(color: Colors.black)),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: SizedBox(
                width: 150,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Search",
                    prefixIcon: const Icon(Icons.search),
                    contentPadding: const EdgeInsets.symmetric(vertical: 4),
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  items:
                      categories
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedCategory = val!;
                      _filterProducts();
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  hint: const Text("Product Category"),
                ),
              ),
              const SizedBox(height: 10),

              // Show results count
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Showing ${_filteredProducts.length} products',
                    style: const TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              Expanded(
                child:
                    _filteredProducts.isEmpty
                        ? const Center(
                          child: Text(
                            'No products found',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                        )
                        : _buildProductGrid(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) {
        final product = _filteredProducts[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product image or placeholder
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    image:
                        product.imageUrl.isNotEmpty
                            ? DecorationImage(
                              image: AssetImage(product.imageUrl),
                              fit: BoxFit.cover,
                            )
                            : null,
                  ),
                  width: double.infinity,
                ),
              ),

              // Product details
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rs. ${product.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.blue[900],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _showItemDialog(context, product);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[900],
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "View",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showItemDialog(BuildContext context, Product product) {
    int quantity = 1;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: Text(product.name),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: AssetImage(product.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Text("Quantity: ${product.quantity}"),
                  Text("Description: ${product.description}"),
                  Text("Expiry Date: ${product.expiryDate}"),
                  Text("Manufacture Date: ${product.manufactureDate}"),
                  Text("Price: Rs. ${product.price.toStringAsFixed(2)}"),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (quantity > 1) {
                            setState(() => quantity--);
                          }
                        },
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      Text(
                        '$quantity',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() => quantity++);
                        },
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Total price
                  Center(
                    child: Text(
                      "Total: Rs. ${(product.price * quantity).toStringAsFixed(2)}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await context.read<OrderProvider>().createOrder(
                      OrderModel(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        username: context.read<UserProvider>().user!.username,
                        userEmail: context.read<UserProvider>().user!.email,
                        product: product,
                        dateTime: DateTime.now(),
                      ),
                    );

                    context.read<OrderProvider>().printAllOrders();

                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[900],
                  ),
                  child:
                      context.watch<OrderProvider>().isLoading
                          ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                          : const Text(
                            "Place Order",
                            style: TextStyle(color: Colors.white),
                          ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
