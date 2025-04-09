import 'package:care_link_development/main.dart';
import 'package:care_link_development/model/user.dart';
import 'package:care_link_development/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'reset.dart';

class FourDigitsCodeScreen extends StatefulWidget {
  const FourDigitsCodeScreen({
    super.key,
    required this.email,
    required this.contactNumber,
    required this.name,
    required this.password,
    required this.code,
  });

  final String email;
  final String contactNumber;
  final String name;
  final String password;
  final int code;

  @override
  State<FourDigitsCodeScreen> createState() => _FourDigitsCodeScreenState();
}

class _FourDigitsCodeScreenState extends State<FourDigitsCodeScreen> {
  final List<TextEditingController> controllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  String completeCode = '';
  bool hasError = false;
  String errorMessage = '';

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    print("Email: ${widget.email}");
    print("Pin: ${widget.code}");
    super.initState();
  }

  void displayCode() async {
    completeCode = controllers.map((e) => e.text).join();
    if (completeCode.length == 4) {
      if (widget.code == int.parse(completeCode)) {
        await _register();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const DoctorFinderApp()),
          (route) => false,
        );
      } else {
        setState(() {
          hasError = true;
          errorMessage = 'Invalid code. Please try again.';
        });
      }
    }
  }

  bool validateCode() {
    if (controllers.any((controller) => controller.text.isEmpty)) {
      setState(() {
        hasError = true;
        errorMessage = 'Please enter all digits';
      });
      return false;
    }

    if (controllers.any(
      (controller) => !RegExp(r'^[0-9]$').hasMatch(controller.text),
    )) {
      setState(() {
        hasError = true;
        errorMessage = 'Please enter numbers only';
      });
      return false;
    }

    setState(() {
      hasError = false;
      errorMessage = '';
    });
    return true;
  }

  Future<void> _register() async {
    print('Name: ${widget.name}');
    print('Contact Number: ${widget.contactNumber}');
    print('Email: ${widget.email}');
    print('Password: ${widget.password}');

    try {
      UserModel user = UserModel(
        uid: "",
        username: widget.name,
        email: widget.email,
        contactNumber: widget.contactNumber,
        address: "",
        bloodType: "",
        dateOfBirth: "",
      );

      await context.read<UserProvider>().registerUser(user, widget.password);

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const DoctorFinderApp()),
        (route) => false,
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Registration failed: ${error.toString()}',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color.fromARGB(255, 207, 79, 79),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 60),

            // Back Button and Title
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 20),
                const Text(
                  "Enter 4 Digits Code",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Instruction Text
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Enter the 4 digits code that you received on your email.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
              ),
            ),

            const SizedBox(height: 40),

            // 4 Digits Code Input Fields
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) => _buildDigitField(index)),
            ),

            // Error message
            if (hasError) ...[
              const SizedBox(height: 20),
              Text(
                errorMessage,
                style: const TextStyle(color: Colors.red, fontSize: 14),
              ),
            ],

            const SizedBox(height: 40),

            // Continue Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (validateCode()) {
                    displayCode();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      context.watch<UserProvider>().isLoading
                          ? Colors.blue[900]
                          : Colors.blue[700],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child:
                    context.watch<UserProvider>().isLoading
                        ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                        : Text(
                          "Continue",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to create a single digit input field
  Widget _buildDigitField(int index) {
    return SizedBox(
      width: 60,
      child: TextField(
        controller: controllers[index],
        textAlign: TextAlign.center,
        maxLength: 1,
        keyboardType: TextInputType.number,
        onChanged: (value) {
          // Clear error when user starts typing
          if (hasError) {
            setState(() {
              hasError = false;
              errorMessage = '';
            });
          }

          // Only allow numbers
          if (value.isNotEmpty && !RegExp(r'^[0-9]$').hasMatch(value)) {
            controllers[index].text = '';
            return;
          }

          if (value.length == 1 && index < 3) {
            FocusScope.of(context).nextFocus();
          }
          displayCode();
        },
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: hasError ? Colors.red : Colors.transparent,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: hasError ? Colors.red : Colors.transparent,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
