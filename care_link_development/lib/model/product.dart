import 'dart:io';

import 'package:flutter/material.dart';

class Product {
  final String name;
  final String category;
  final String description;
  final String quantity;
  final String expiryDate;
  final String manufactureDate;
  final double price;
  final String imageUrl;
  final File? imageFile; // Add this property

  Product({
    required this.name,
    required this.category,
    required this.description,
    required this.quantity,
    required this.expiryDate,
    required this.manufactureDate,
    required this.price,
    required this.imageUrl,
    this.imageFile, // Add this parameter
  });

  // Convert to a map for database operations
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'description': description,
      'quantity': quantity,
      'expiryDate': expiryDate,
      'manufactureDate': manufactureDate,
      'price': price,
      'imageUrl': imageUrl,
    };
  }

  // Create a Product from a map
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      description: map['description'] ?? '',
      quantity: map['quantity'] ?? '',
      expiryDate: map['expiryDate'] ?? '',
      manufactureDate: map['manufactureDate'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  // Add helper method to determine image source
  ImageProvider getImage() {
    if (imageFile != null) {
      return FileImage(imageFile!);
    }
    return AssetImage(imageUrl);
  }
}
