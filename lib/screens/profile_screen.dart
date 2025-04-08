import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _showEmergencyAlerts = true;
  bool _showTrafficUpdates = true;
  bool _showDoneAlerts = true;
  bool _isDarkMode = false;
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Preferences'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Manage your alert preferences',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),

          SwitchListTile(
            title: const Text('Show Emergency Alerts'),
            value: _showEmergencyAlerts,
            onChanged: (bool value) {
              setState(() => _showEmergencyAlerts = value);
            },
          ),
          SwitchListTile(
            title: const Text('Show Traffic Updates'),
            value: _showTrafficUpdates,
            onChanged: (bool value) {
              setState(() => _showTrafficUpdates = value);
            },
          ),
          SwitchListTile(
            title: const Text('Show Resolved Alerts'),
            value: _showDoneAlerts,
            onChanged: (bool value) {
              setState(() => _showDoneAlerts = value);
            },
          ),

          const Divider(height: 40),
          const Text('More Settings', style: TextStyle(color: Colors.grey)),
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: _isDarkMode,
            onChanged: (bool value) {
              setState(() => _isDarkMode = value);
              // TODO: apply dark theme
            },
          ),
          ListTile(
            title: const Text('Language Options'),
            subtitle: Text(_selectedLanguage),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              _showLanguageDialog();
            },
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Language"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: const Text("English"),
                value: 'English',
                groupValue: _selectedLanguage,
                onChanged: (value) {
                  setState(() => _selectedLanguage = value!);
                  Navigator.of(context).pop();
                },
              ),
              RadioListTile<String>(
                title: const Text("French"),
                value: 'French',
                groupValue: _selectedLanguage,
                onChanged: (value) {
                  setState(() => _selectedLanguage = value!);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
