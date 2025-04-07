import 'dart:io';
import 'dart:math';
import 'package:care_link_development/model/user.dart';
import 'package:care_link_development/services/firebase_services.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider extends ChangeNotifier {
  UserModel? user;

  File? profileImage;
  UserModel? updatedUser;
  bool isLoading = false;
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  int currentProfileNumber = 0;

  List<UserModel> userList = [];

  final FirebaseService _firebaseService = FirebaseService();

  Future<void> registerUser(UserModel newUser, String password) async {
    try {
      isLoading = true;
      notifyListeners();
      final authResult = await _auth.createUserWithEmailAndPassword(
        email: newUser.email,
        password: password,
      );

      String userId = authResult.user!.uid;

      user = UserModel(
        uid: authResult.user!.uid,
        username: newUser.username,
        email: newUser.email,
        contactNumber: newUser.contactNumber,
      );

      await _firebaseService.uploadDocument("Users", user!, userId);
    } catch (error) {
      print("Error registering user: $error");
      throw error;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loginUser(String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();

      final userCredential = await auth.FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      final userDoc =
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(userCredential.user!.uid)
              .get();

      if (userDoc.exists) {
        user = UserModel.fromMap(userDoc);
        notifyListeners();
      } else {
        throw Exception("User profile data not found");
      }
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      isLoading = true;
      notifyListeners();

      await _auth.signOut();

      user = null;
      profileImage = null;

      print("User logged out successfully");
    } catch (error) {
      print("Error logging out: $error");
      throw error;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getUserData() async {
    try {
      isLoading = true;
      notifyListeners();

      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception("No user is logged in");
      }

      final userDoc = await _firebaseService.getDocumentDetails(
        "Users",
        currentUser.uid,
      );

      final random = Random();
      currentProfileNumber = random.nextInt(100) + 1;

      if (userDoc.exists) {
        user = UserModel.fromMap(userDoc);
      } else {
        throw Exception("User profile data not found");
      }
    } catch (error) {
      print("Error fetching user data: $error");
      throw error;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateUserDetails(UserModel userUpdated) async {
    try {
      isLoading = true;
      notifyListeners();

      final currentUser = _auth.currentUser;

      await _firebaseService.updateField(
        "Users",
        userUpdated,
        currentUser!.uid,
      );
      user = userUpdated;

      notifyListeners();

      print("User details updated successfully");
    } catch (error) {
      print("Error updating user details: $error");
      throw error;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updatePassword(String newPassword) async {
    try {
      isLoading = true;
      notifyListeners();

      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception("No user is logged in");
      }

      await _firebaseService.updatePassword(newPassword);

      print("Password updated successfully");
    } catch (error) {
      print("Error updating password: $error");
      throw error;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getAllUsers() async {
    try {
      isLoading = true;
      notifyListeners();

      final userDocs = await _firebaseService.getDocuments("Users");

      userList = userDocs.docs.map((doc) => UserModel.fromMap(doc)).toList();
      print('Fetched Users:');
      for (var user in userList) {
        print(user.username);
      }
    } catch (error) {
      print("Error fetching all users: $error");
      throw error;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void toggleLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }
}
