import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:law_app/components/export.dart';
import 'package:law_app/core/database/models/reminder_model.dart';
import 'package:law_app/features/reminder/providers/reminder_provider.dart';
import 'package:law_app/features/reminder/views/add_edit_reminder_screen.dart';

class ReminderScreen extends ConsumerWidget {
  const ReminderScreen({super.key});

  String _getRecurrenceText(ReminderModel reminder) {
    switch (reminder.recurrenceType) {
      case RecurrenceType.none:
        return DateFormat('dd/MM/yyyy HH:mm').format(reminder.getScheduledDateTime.toLocal());
      case RecurrenceType.daily:
        return 'ทุกวัน เวลา ${DateFormat('HH:mm').format(reminder.getScheduledDateTime.toLocal())}';
      case RecurrenceType.weekly:
        // Adjust for Dart's weekday (1=Mon, 7=Sun)
        final dayName = DateFormat('EEEE', 'th').format(
          DateTime(2023, 1, 1).add(Duration(days: (reminder.dayOfWeek ?? 1) - 1)) // Jan 1 2023 was a Sunday
        );
        return 'ทุก$dayName เวลา ${DateFormat('HH:mm').format(reminder.getScheduledDateTime.toLocal())}';
      case RecurrenceType.monthly:
        return 'ทุกวันที่ ${reminder.dayOfMonth ?? reminder.getScheduledDateTime.toLocal().day} เวลา ${DateFormat('HH:mm').format(reminder.getScheduledDateTime.toLocal())}';
      case RecurrenceType.yearly:
        final monthName = DateFormat('MMMM', 'th').format(
          DateTime(2023, (reminder.monthOfYear ?? 1), 1)
        );
        return 'ทุกวันที่ ${reminder.dayOfMonth ?? reminder.getScheduledDateTime.toLocal().day} $monthName เวลา ${DateFormat('HH:mm').format(reminder.getScheduledDateTime.toLocal())}';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the StreamProvider for reminders
    final reminderListAsync = ref.watch(reminderListProvider);
    // Watch the ReminderNotifier for calling methods (add, update, delete)
    final reminderNotifier = ref.watch(reminderNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('แอปเตือนความจำ'),
        actions: [
          // testNotificationButton
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Call the method to test notifications
              reminderNotifier.testNotification();
            },
          ),
        ],
      ),
      body: reminderListAsync.when(
        data: (reminders) {
          if (reminders.isEmpty) {
            return const Center(
              child: Text('ยังไม่มีการเตือนความจำ'),
            );
          }
          return ListView.builder(
            itemCount: reminders.length,
            itemBuilder: (context, index) {
              final reminder = reminders[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                color: reminder.isActive ? Colors.white : Colors.grey[300],
                child: ListTile(
                  title: Text(
                    reminder.title,
                    style: TextStyle(
                      decoration: reminder.isActive
                          ? TextDecoration.none
                          : TextDecoration.lineThrough,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_getRecurrenceText(reminder)),
                      if (reminder.description.isNotEmpty)
                        Text(reminder.description),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          reminder.isActive
                              ? Icons.notifications_active
                              : Icons.notifications_off,
                          color: reminder.isActive ? Colors.green : Colors.red,
                        ),
                        onPressed: () {
                          // เรียกใช้เมธอดจาก reminderNotifier
                          reminderNotifier.toggleReminderActiveStatus(reminder.id);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AddEditReminderScreen(
                                reminder: reminder,
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          // เรียกใช้เมธอดจาก reminderNotifier
                          reminderNotifier.deleteReminder(reminder.id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddEditReminderScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}