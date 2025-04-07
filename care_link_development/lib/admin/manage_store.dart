import 'package:flutter/material.dart';
import 'package:care_link_development/model/product.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ManageStore extends StatefulWidget {
  const ManageStore({super.key});

  @override
  State<ManageStore> createState() => _ManageStoreState();
}

class _ManageStoreState extends State<ManageStore> {
  final List<Product> _allProducts = [
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

  Future<File?> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      return File(image.path);
    }
    return null;
  }

  void _addNewProduct() {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final categoryController = TextEditingController();
    final descriptionController = TextEditingController();
    final quantityController = TextEditingController();
    final expiryDateController = TextEditingController();
    final manufactureDateController = TextEditingController();
    final priceController = TextEditingController();
    File? selectedImage;

    showDialog(
      context: context,
      builder:
          (dialogContext) => StatefulBuilder(
            builder:
                (context, setDialogState) => AlertDialog(
                  title: const Text('Add New Product'),
                  content: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final image = await _pickImage();
                              if (image != null) {
                                setDialogState(() => selectedImage = image);
                              }
                            },
                            child: Container(
                              height: 150,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child:
                                  selectedImage != null
                                      ? Image.file(
                                        selectedImage!,
                                        fit: BoxFit.cover,
                                      )
                                      : const Icon(
                                        Icons.add_photo_alternate,
                                        size: 50,
                                      ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              labelText: 'Product Name',
                            ),
                            validator:
                                (value) =>
                                    value?.isEmpty ?? true ? 'Required' : null,
                          ),
                          TextFormField(
                            controller: categoryController,
                            decoration: const InputDecoration(
                              labelText: 'Category',
                            ),
                            validator:
                                (value) =>
                                    value?.isEmpty ?? true ? 'Required' : null,
                          ),
                          TextFormField(
                            controller: descriptionController,
                            decoration: const InputDecoration(
                              labelText: 'Description',
                            ),
                            validator:
                                (value) =>
                                    value?.isEmpty ?? true ? 'Required' : null,
                          ),
                          TextFormField(
                            controller: quantityController,
                            decoration: const InputDecoration(
                              labelText: 'Quantity',
                            ),
                            validator:
                                (value) =>
                                    value?.isEmpty ?? true ? 'Required' : null,
                          ),
                          TextFormField(
                            controller: expiryDateController,
                            decoration: const InputDecoration(
                              labelText: 'Expiry Date',
                            ),
                            validator:
                                (value) =>
                                    value?.isEmpty ?? true ? 'Required' : null,
                          ),
                          TextFormField(
                            controller: manufactureDateController,
                            decoration: const InputDecoration(
                              labelText: 'Manufacture Date',
                            ),
                            validator:
                                (value) =>
                                    value?.isEmpty ?? true ? 'Required' : null,
                          ),
                          TextFormField(
                            controller: priceController,
                            decoration: const InputDecoration(
                              labelText: 'Price',
                            ),
                            keyboardType: TextInputType.number,
                            validator:
                                (value) =>
                                    value?.isEmpty ?? true ? 'Required' : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState?.validate() ?? false) {
                          if (selectedImage == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please select an image'),
                              ),
                            );
                            return;
                          }

                          // Use the main widget's setState
                          setState(() {
                            _allProducts.add(
                              Product(
                                name: nameController.text,
                                category: categoryController.text,
                                description: descriptionController.text,
                                quantity: quantityController.text,
                                expiryDate: expiryDateController.text,
                                manufactureDate: manufactureDateController.text,
                                price: double.parse(priceController.text),
                                imageUrl: '', // Empty since we're using file
                                imageFile: selectedImage,
                              ),
                            );
                          });

                          Navigator.pop(dialogContext);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Product added successfully'),
                            ),
                          );
                        }
                      },
                      child: const Text('Add Product'),
                    ),
                  ],
                ),
          ),
    );
  }

  void _deleteProduct(Product product) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Product'),
            content: Text('Are you sure you want to delete ${product.name}?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _allProducts.remove(product);
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Product deleted successfully'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }

  Widget _buildProductImage(Product product) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        image: DecorationImage(image: product.getImage(), fit: BoxFit.cover),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Store')),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewProduct,
        child: const Icon(Icons.add),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.55, // Changed from 0.65 to 0.55 for taller cards
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: _allProducts.length,
        itemBuilder: (context, index) {
          final product = _allProducts[index];
          return InkWell(
            onTap: () => _showProductDialog(context, product),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product image with increased height
                      _buildProductImage(product),
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
                              product.description,
                              style: const TextStyle(fontSize: 12),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Quantity: ${product.quantity}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            Text(
                              'Exp: ${product.expiryDate}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            Text(
                              'Mfg: ${product.manufactureDate}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            Text(
                              'Rs. ${product.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: Colors.blue[900],
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: const CircleBorder(),
                      ),
                      icon: const Icon(Icons.delete, color: Colors.white),
                      onPressed: () => _deleteProduct(product),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showProductDialog(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(product.name),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: AssetImage(product.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Category: ${product.category}'),
                const SizedBox(height: 8),
                Text('Description: ${product.description}'),
                const SizedBox(height: 8),
                Text('Quantity: ${product.quantity}'),
                const SizedBox(height: 8),
                Text('Expiry Date: ${product.expiryDate}'),
                const SizedBox(height: 8),
                Text('Manufacture Date: ${product.manufactureDate}'),
                const SizedBox(height: 8),
                Text(
                  'Price: Rs. ${product.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.blue[900],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
