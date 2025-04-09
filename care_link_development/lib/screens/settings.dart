import 'package:care_link_development/auth/reset.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SettingsScreen(),
    ),
  );
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool textMessages = true;
  bool phoneCalls = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE5F3FF), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text("Settings", style: TextStyle(color: Colors.black)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Account settings",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ResetPasswordScreen(),
                    ),
                  );
                },
                child: _settingsItem(Icons.lock, "Change Password", Colors.red),
              ),
              _settingsItem(Icons.notifications, "Notifications", Colors.green),
              _settingsItem(Icons.bar_chart, "Statistics", Colors.blue),
              _settingsItem(Icons.group, "About us", Colors.orange),
              const Divider(height: 32),
              const Text(
                "More options",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              _toggleItem("Text messages", textMessages, (value) {
                setState(() {
                  textMessages = value;
                });
              }),
              _toggleItem("Phone calls", phoneCalls, (value) {
                setState(() {
                  phoneCalls = value;
                });
              }),
              _arrowItem("Languages", "English"),
              _arrowItem("Currency", "\$-USD"),
              _arrowItem("Linked accounts", "Facebook, Google"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _settingsItem(IconData icon, String title, Color bgColor) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: bgColor.withOpacity(0.2),
        child: Icon(icon, color: bgColor),
      ),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }

  Widget _toggleItem(String label, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      value: value,
      activeColor: Colors.blue,
      onChanged: onChanged,
    );
  }

  Widget _arrowItem(String title, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value, style: const TextStyle(color: Colors.grey)),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
      onTap: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$title tapped')));
      },
    );
  }
}
