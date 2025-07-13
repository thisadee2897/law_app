import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:law_app/core/database/models/reminder_model.dart';
import 'package:law_app/features/reminder/providers/add_edit_reminder_provider_new.dart';
import 'package:law_app/features/reminder/providers/reminder_provider.dart';
import 'package:law_app/features/reminder/views/add_edit_reminder_screen.dart';
import 'package:law_app/features/settings/views/notification_settings_screen.dart';

class ReminderScreen extends ConsumerStatefulWidget {
  const ReminderScreen({super.key});

  @override
  ConsumerState<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends ConsumerState<ReminderScreen> {
  String _getRecurrenceText(ReminderModel reminder) {
    switch (reminder.recurrenceType) {
      case RecurrenceType.none:
        return DateFormat('dd/MM/yyyy HH:mm').format(reminder.getScheduledDateTime.toLocal());
      case RecurrenceType.daily:
        return 'ทุกวัน เวลา ${DateFormat('HH:mm').format(reminder.getScheduledDateTime.toLocal())}';
      case RecurrenceType.weekly:
        final weekdays = ['', 'จันทร์', 'อังคาร', 'พุธ', 'พฤหัสบดี', 'ศุกร์', 'เสาร์', 'อาทิตย์'];
        final dayName = weekdays[reminder.dayOfWeek ?? 1];
        return 'ทุก$dayName เวลา ${DateFormat('HH:mm').format(reminder.getScheduledDateTime.toLocal())}';
      case RecurrenceType.monthly:
        return 'ทุกวันที่ ${reminder.dayOfMonth ?? reminder.getScheduledDateTime.toLocal().day} เวลา ${DateFormat('HH:mm').format(reminder.getScheduledDateTime.toLocal())}';
      case RecurrenceType.yearly:
        final months = [
          '',
          'มกราคม',
          'กุมภาพันธ์',
          'มีนาคม',
          'เมษายน',
          'พฤษภาคม',
          'มิถุนายน',
          'กรกฎาคม',
          'สิงหาคม',
          'กันยายน',
          'ตุลาคม',
          'พฤศจิกายน',
          'ธันวาคม',
        ];
        final monthName = months[reminder.monthOfYear ?? 1];
        return 'ทุกวันที่ ${reminder.dayOfMonth ?? reminder.getScheduledDateTime.toLocal().day} $monthName เวลา ${DateFormat('HH:mm').format(reminder.getScheduledDateTime.toLocal())}';
    }
  }

  String _getRelativeTime(DateTime scheduledTime) {
    final now = DateTime.now();
    final difference = scheduledTime.difference(now);

    if (difference.isNegative) {
      return 'เลยเวลาแล้ว';
    } else if (difference.inMinutes < 60) {
      return 'ในอีก ${difference.inMinutes} นาที';
    } else if (difference.inHours < 24) {
      return 'ในอีก ${difference.inHours} ชั่วโมง';
    } else if (difference.inDays < 7) {
      return 'ในอีก ${difference.inDays} วัน';
    } else {
      return 'ในอีก ${(difference.inDays / 7).floor()} สัปดาห์';
    }
  }

  IconData _getRecurrenceIcon(RecurrenceType type) {
    switch (type) {
      case RecurrenceType.none:
        return Icons.schedule;
      case RecurrenceType.daily:
        return Icons.today;
      case RecurrenceType.weekly:
        return Icons.view_week;
      case RecurrenceType.monthly:
        return Icons.calendar_month;
      case RecurrenceType.yearly:
        return Icons.event_repeat;
    }
  }

  Color _getPriorityColor(ReminderModel reminder, BuildContext context) {
    if (!reminder.isActive) return Colors.grey;

    final now = DateTime.now();
    final scheduledTime = reminder.getScheduledDateTime;
    final difference = scheduledTime.difference(now);

    if (difference.isNegative) {
      return Colors.red; // เลยเวลาแล้ว
    } else if (difference.inMinutes < 60) {
      return Colors.orange; // ใกล้ถึงเวลา
    } else if (difference.inHours < 24) {
      return Theme.of(context).primaryColor; // วันนี้
    } else {
      return Colors.green; // ยังไกล
    }
  }

  Widget _buildReminderCard(BuildContext context, ReminderModel reminder, ReminderNotifier notifier) {
    final theme = Theme.of(context);
    final priorityColor = _getPriorityColor(reminder, context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: priorityColor.withOpacity(0.3), width: 2),
        boxShadow: [BoxShadow(color: theme.shadowColor.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _navigateToEdit(context, reminder),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with status and priority
              Row(
                children: [
                  Container(width: 4, height: 40, decoration: BoxDecoration(color: priorityColor, borderRadius: BorderRadius.circular(2))),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reminder.title,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            decoration: reminder.isActive ? TextDecoration.none : TextDecoration.lineThrough,
                            color: reminder.isActive ? null : theme.disabledColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(_getRecurrenceIcon(reminder.recurrenceType), size: 16, color: priorityColor),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                _getRecurrenceText(reminder),
                                style: theme.textTheme.bodyMedium?.copyWith(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Active status badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: reminder.isActive ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          reminder.isActive ? Icons.notifications_active : Icons.notifications_off,
                          size: 16,
                          color: reminder.isActive ? Colors.green : Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          reminder.isActive ? 'เปิด' : 'ปิด',
                          style: theme.textTheme.bodySmall?.copyWith(color: reminder.isActive ? Colors.green : Colors.grey, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Description (if exists)
              if (reminder.description.isNotEmpty) ...[
                Text(
                  reminder.description,
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7)),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
              ],

              // Bottom info and actions
              Row(
                children: [
                  // Time info
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: priorityColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      _getRelativeTime(reminder.getScheduledDateTime),
                      style: theme.textTheme.bodySmall?.copyWith(color: priorityColor, fontWeight: FontWeight.w600),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Forms count
                  if (reminder.forms.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: theme.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.picture_as_pdf, size: 14, color: theme.primaryColor),
                          const SizedBox(width: 4),
                          Text(
                            '${reminder.forms.length} ไฟล์',
                            style: theme.textTheme.bodySmall?.copyWith(color: theme.primaryColor, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),

                  const Spacer(),

                  // Action buttons
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => notifier.toggleReminderActiveStatus(reminder.id),
                        icon: Icon(reminder.isActive ? Icons.pause : Icons.play_arrow, color: reminder.isActive ? Colors.orange : Colors.green),
                        tooltip: reminder.isActive ? 'ปิดการแจ้งเตือน' : 'เปิดการแจ้งเตือน',
                        style: IconButton.styleFrom(backgroundColor: (reminder.isActive ? Colors.orange : Colors.green).withOpacity(0.1)),
                      ),
                      IconButton(
                        onPressed: () => _navigateToEdit(context, reminder),
                        icon: const Icon(Icons.edit),
                        tooltip: 'แก้ไข',
                        style: IconButton.styleFrom(backgroundColor: theme.primaryColor.withOpacity(0.1), foregroundColor: theme.primaryColor),
                      ),
                      IconButton(
                        onPressed: () => _showDeleteDialog(context, reminder, notifier),
                        icon: const Icon(Icons.delete),
                        tooltip: 'ลบ',
                        style: IconButton.styleFrom(backgroundColor: Colors.red.withOpacity(0.1), foregroundColor: Colors.red),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_none, size: 80, color: theme.disabledColor),
            const SizedBox(height: 16),
            Text('ยังไม่มีการเตือนความจำ', style: theme.textTheme.headlineSmall?.copyWith(color: theme.disabledColor, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(
              'แตะปุ่ม + เพื่อเพิ่มการเตือนความจำใหม่',
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _navigateToAdd(context),
              icon: const Icon(Icons.add),
              label: const Text('เพิ่มการเตือนความจำ'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: theme.colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToAdd(BuildContext context) {
    ref.read(addEditReminderProvider.notifier).isInitialized = true;
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AddEditReminderScreen(reminder: null,)));
  }

  void _navigateToEdit(BuildContext context, ReminderModel reminder) {
    ref.read(addEditReminderProvider.notifier).isInitialized = false;
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddEditReminderScreen(reminder: reminder)));
  }

  void _showDeleteDialog(BuildContext context, ReminderModel reminder, ReminderNotifier notifier) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('ยืนยันการลบ'),
            content: Text('คุณต้องการลบการเตือนความจำ "${reminder.title}" หรือไม่?'),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('ยกเลิก')),
              ElevatedButton(
                onPressed: () {
                  notifier.deleteReminder(reminder.id);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ลบการเตือนความจำเรียบร้อยแล้ว')));
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                child: const Text('ลบ'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final reminderListAsync = ref.watch(reminderListProvider);
    final reminderNotifier = ref.watch(reminderNotifierProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: theme.textTheme.titleLarge?.color,
        title: Text('การเตือนความจำ', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationSettingsScreen()));
            },
            tooltip: 'ตั้งค่าการแจ้งเตือน',
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              reminderNotifier.testNotification();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ส่งการแจ้งเตือนทดสอบแล้ว')));
            },
            tooltip: 'ทดสอบการแจ้งเตือน',
          ),
        ],
      ),
      body: reminderListAsync.when(
        data: (reminders) {
          if (reminders.isEmpty) {
            return _buildEmptyState(context);
          }

          // Sort reminders by scheduled time
          final sortedReminders = List<ReminderModel>.from(reminders)..sort((a, b) => a.getScheduledDateTime.compareTo(b.getScheduledDateTime));

          return ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 100),
            itemCount: sortedReminders.length,
            itemBuilder: (context, index) {
              final reminder = sortedReminders[index];
              return _buildReminderCard(context, reminder, reminderNotifier);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (err, stack) => Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red.withOpacity(0.6)),
                    const SizedBox(height: 16),
                    Text('เกิดข้อผิดพลาด', style: theme.textTheme.headlineSmall?.copyWith(color: Colors.red, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Text(
                      '$err',
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7)),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(onPressed: () => ref.refresh(reminderListProvider), child: const Text('ลองใหม่')),
                  ],
                ),
              ),
            ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAdd(context),
        icon: const Icon(Icons.add),
        label: const Text('เพิ่มเตือนความจำ'),
        backgroundColor: theme.primaryColor,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
    );
  }
}
