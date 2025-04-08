import 'package:flutter/material.dart';
import '../app_style.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String selectedFilter = 'all';

  final List<Map<String, dynamic>> allAlerts = [
    {
      'type': 'emergency',
      'title': 'Accident on Route A1',
      'message': 'Severe collision ahead. Expect delays.',
      'icon': Icons.warning,
      'color': Colors.red,
    },
    {
      'type': 'traffic',
      'title': 'Heavy traffic near exit 4',
      'message': 'Estimated delay: 15 mins',
      'icon': Icons.traffic,
      'color': Colors.orange,
    },
    {
      'type': 'done',
      'title': 'Clear route',
      'message': 'Traffic back to normal',
      'icon': Icons.check_circle,
      'color': Colors.green,
    },
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredAlerts =
        selectedFilter == 'all'
            ? allAlerts
            : allAlerts
                .where((alert) => alert['type'] == selectedFilter)
                .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications & Alerts"),
        backgroundColor: indigoColor,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              setState(() {
                selectedFilter = value;
              });
            },
            itemBuilder:
                (context) => [
                  const PopupMenuItem(value: 'all', child: Text("All")),
                  const PopupMenuItem(
                    value: 'emergency',
                    child: Text("Emergency"),
                  ),
                  const PopupMenuItem(value: 'traffic', child: Text("Traffic")),
                  const PopupMenuItem(value: 'done', child: Text("Done")),
                ],
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: filteredAlerts.length,
        itemBuilder: (context, index) {
          final alert = filteredAlerts[index];
          return Card(
            color: alert['color'].withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Icon(alert['icon'], color: alert['color'], size: 32),
              title: Text(
                alert['title'],
                style: Style.headLineStyle5.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(alert['message']),
            ),
          );
        },
      ),
    );
  }
}
