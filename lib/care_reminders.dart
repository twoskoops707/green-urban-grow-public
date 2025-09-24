import 'package:flutter/material.dart';

class CareReminders extends StatefulWidget {
  const CareReminders({super.key});

  @override
  _CareRemindersState createState() => _CareRemindersState();
}

class _CareRemindersState extends State<CareReminders> {
  final List<Reminder> _reminders = [
    Reminder('Water tomatoes', 'Daily', true),
    Reminder('Check basil moisture', 'Every 2 days', false),
    Reminder('Fertilize plants', 'Weekly', false),
    Reminder('Harvest lettuce', 'When leaves are 3-4 inches', true),
    Reminder('Prune herbs', 'As needed to encourage growth', false),
    Reminder('Check for pests', 'Weekly inspection', true),
  ];

  void _toggleReminder(int index) {
    setState(() {
      _reminders[index].isActive = !_reminders[index].isActive;
    });
  }

  void _scheduleAllReminders() {
    final activeCount = _reminders.where((r) => r.isActive).length;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Scheduled $activeCount active reminder(s)'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Care Reminders')),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue[50],
            child: const Column(
              children: [
                Text(
                  'Never forget plant care tasks!', 
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('Set reminders for watering, fertilizing, and harvesting'),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _reminders.length,
              itemBuilder: (context, index) {
                final reminder = _reminders[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: ListTile(
                    leading: Icon(
                      reminder.isActive ? Icons.notifications_active : Icons.notifications_off,
                      color: reminder.isActive ? Colors.green : Colors.grey,
                    ),
                    title: Text(reminder.task),
                    subtitle: Text(reminder.schedule),
                    trailing: Switch(
                      value: reminder.isActive,
                      onChanged: (value) => _toggleReminder(index),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: _scheduleAllReminders,
              icon: const Icon(Icons.notification_add),
              label: const Text('Schedule Active Reminders'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Reminder {
  final String task;
  final String schedule;
  bool isActive;

  Reminder(this.task, this.schedule, this.isActive);
}
