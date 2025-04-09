import 'package:care_link_development/model/appoinment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:care_link_development/model/order.dart';

import 'package:care_link_development/model/user.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<DocumentSnapshot> getDocumentDetails(
    String collection,
    String document,
  ) async {
    try {
      return await _db.collection(collection).doc(document).get();
    } catch (e) {
      throw Exception('Failed to fetch document: $e');
    }
  }

  Future<QuerySnapshot> getDocuments(String collection) async {
    try {
      return await _db.collection(collection).get();
    } catch (e) {
      throw Exception('Failed to fetch documents: $e');
    }
  }

  Future<QuerySnapshot> getDocumentsWithField({
    required String collection,
    required String fieldName,
    required dynamic fieldValue,
  }) async {
    try {
      return await _db
          .collection(collection)
          .where(fieldName, isEqualTo: fieldValue)
          .get();
    } catch (e) {
      throw Exception('Failed to fetch documents with field $fieldName: $e');
    }
  }

  Future<DocumentReference> uploadDocument(
    String collection,
    UserModel userData,
    String documentId,
  ) async {
    try {
      final docRef = _db.collection(collection).doc(documentId);
      await docRef.set(userData.toMap());
      return docRef;
    } catch (e) {
      throw Exception('Failed to upload document: $e');
    }
  }

  Future<DocumentReference> uploadOrder(
    String collection,
    OrderModel userData,
    String documentId,
  ) async {
    try {
      final docRef = _db.collection(collection).doc(documentId);
      await docRef.set(userData.toMap());
      return docRef;
    } catch (e) {
      throw Exception('Failed to upload document: $e');
    }
  }

  Future<DocumentReference> uploadAppoinment(
    String collection,
    AppointmentModel userData,
    String documentId,
  ) async {
    try {
      final docRef = _db.collection(collection).doc(documentId);
      await docRef.set(userData.toMap());
      return docRef;
    } catch (e) {
      throw Exception('Failed to upload document: $e');
    }
  }

  Future<DocumentReference> updateField(
    String collection,
    UserModel userData,
    String documentId,
  ) async {
    try {
      final docRef = _db.collection(collection).doc(documentId);
      await docRef.update(userData.toMap());
      return docRef;
    } catch (e) {
      throw Exception('Failed to upload document: $e');
    }
  }

  Future<void> updatePassword(String newPassword) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('No user is currently signed in');
      }
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'requires-recent-login':
          throw Exception('Please sign in again before updating your password');
        case 'weak-password':
          throw Exception('The password provided is too weak');
        default:
          throw Exception('Failed to update password: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to update password: $e');
    }
  }

  Future<void> deleteDocument(String collection, String documentId) async {
    try {
      await _db.collection(collection).doc(documentId).delete();
    } catch (e) {
      throw Exception('Failed to delete document: $e');
    }
  }
}
