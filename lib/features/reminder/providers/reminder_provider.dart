// providers/reminder_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:law_app/core/database/models/reminder_model.dart';
import 'package:law_app/core/database/objectbox_database.dart';
import 'package:law_app/core/utils/services/notification_service.dart';
import 'package:timezone/timezone.dart' as tz;

// เปลี่ยน reminderListProvider เป็น StreamProvider
final reminderListProvider = StreamProvider<List<ReminderModel>>((ref) {
  // เข้าถึง instance ของ ObjectBoxDatabase ที่ถูก init แล้ว
  final reminderBoxManager = ObjectBoxDatabase.instance.reminderBox;

  // ส่ง Stream ของ List<ReminderModel> จาก ObjectBox
  return reminderBoxManager.streamAll();
});

// ReminderNotifier (หากยังต้องการใช้สำหรับการจัดการ Logic เพิ่ม/ลบ/แก้ไข)
// คุณยังสามารถเก็บ ReminderListNotifier ไว้ได้ หากต้องการมีเมธอดสำหรับการเพิ่ม/แก้ไข/ลบ
// และให้ UI watch ทั้ง StreamProvider และเรียกเมธอดของ Notifier
class ReminderNotifier {
  // เปลี่ยนเป็น class ปกติ ไม่ต้องเป็น StateNotifier เพราะ UI จะ watch stream แทน
  final _reminderBoxManager = ObjectBoxDatabase.instance.reminderBox;

  Future<void> addReminder(
    String title,
    String description,
    DateTime scheduledTime,
    RecurrenceType recurrenceType,
    int? dayOfWeek,
    int? dayOfMonth,
    int? monthOfYear,
    List<int>? selectedFormIds,
  ) async {
    //     final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    // // current time's offset in milliseconds from UTC
    // final int offsetMilliseconds = now.timeZoneOffset.inMilliseconds;
    // // Convert to hours
    // final double offsetHours = offsetMilliseconds / 1000 / 60 / 60;
    // DateTime dateTimeToDefault = scheduledTime.add(Duration(hours: -offsetHours.toInt()));
    final newReminder = ReminderModel(
      title: title,
      description: description,
      scheduledTime: scheduledTime.toIso8601String(),
      isActive: true,
      recurrenceType: recurrenceType,
      dayOfWeek: dayOfWeek,
      dayOfMonth: dayOfMonth,
      monthOfYear: monthOfYear,
    );

    // Clear existing forms and add selected forms
    newReminder.forms.clear();
    if (selectedFormIds != null && selectedFormIds.isNotEmpty) {
      final formBoxManager = ObjectBoxDatabase.instance.formBoxManager;
      for (int formId in selectedFormIds) {
        final form = formBoxManager.get(formId);
        if (form != null) {
          newReminder.forms.add(form);
        }
      }
    }

    _reminderBoxManager.add(newReminder);

    if (newReminder.isActive) {
      await NotificationService.scheduleNotification(newReminder);
    }
  }

  Future<void> updateReminder(
    int id,
    String newTitle,
    String newDescription,
    DateTime newScheduledTime,
    bool newIsActive,
    RecurrenceType newRecurrenceType,
    int? newDayOfWeek,
    int? newDayOfMonth,
    int? newMonthOfYear,
    List<int>? selectedFormIds,
  ) async {
    //         final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    // // current time's offset in milliseconds from UTC
    // final int offsetMilliseconds = now.timeZoneOffset.inMilliseconds;
    // // Convert to hours
    // final double offsetHours = offsetMilliseconds / 1000 / 60 / 60;
    // DateTime dateTimeToDefault = newScheduledTime.add(Duration(hours: -offsetHours.toInt()));
    // print("dateTimeToDefault.toIso8601String(): ${dateTimeToDefault.toIso8601String()}");
    // print("newScheduledTime : ${newScheduledTime.toIso8601String()}");
    // print("newScheduledTime.toLocal() : ${newScheduledTime.toLocal().toIso8601String()}");
    final existingReminder = _reminderBoxManager.get(id);
    if (existingReminder != null) {
      final updatedReminder = existingReminder.copyWith(
        title: newTitle,
        description: newDescription,
        scheduledTime: newScheduledTime.toIso8601String(),
        isActive: newIsActive,
        recurrenceType: newRecurrenceType,
        dayOfWeek: newDayOfWeek,
        dayOfMonth: newDayOfMonth,
        monthOfYear: newMonthOfYear,
      );

      // Update forms relationship
      updatedReminder.forms.clear();
      _reminderBoxManager.removeFormsWhenIdNotInList(selectedFormIds?.map((e) => e).toList() ?? []);
      if (selectedFormIds != null && selectedFormIds.isNotEmpty) {
        final formBoxManager = ObjectBoxDatabase.instance.formBoxManager;
        for (int formId in selectedFormIds) {
          final form = formBoxManager.get(formId);
          if (form != null) {
            updatedReminder.forms.add(form);
          }
        }
      }
      _reminderBoxManager.update(updatedReminder);

      // Cancel old notification first
      try {
        await NotificationService.cancelNotification(updatedReminder.id);
        print('🗑️ Cancelled old notification for reminder ID: ${updatedReminder.id}');
      } catch (e) {
        print('⚠️ Warning: Could not cancel old notification: $e');
      }

      // Schedule new notification if active
      if (updatedReminder.isActive) {
        try {
          await NotificationService.scheduleNotification(updatedReminder);
          print('✅ Rescheduled notification for updated reminder: ${updatedReminder.title}');
        } catch (e) {
          print('❌ Error scheduling notification for updated reminder: $e');
        }
      }
    }
  }

  Future<void> toggleReminderActiveStatus(int id) async {
    final existingReminder = _reminderBoxManager.get(id);
    if (existingReminder != null) {
      final updatedReminder = existingReminder.copyWith(isActive: false);
      _reminderBoxManager.update(updatedReminder);

      if (updatedReminder.isActive) {
        try {
          await NotificationService.scheduleNotification(updatedReminder);
          print('✅ Enabled notification for reminder: ${updatedReminder.title}');
        } catch (e) {
          print('❌ Error enabling notification: $e');
        }
      } else {
        try {
          await NotificationService.cancelNotification(updatedReminder.id);
          print('🔕 Disabled notification for reminder: ${updatedReminder.title}');
        } catch (e) {
          print('⚠️ Warning: Could not disable notification: $e');
        }
      }
    }
  }
  


  Future<void> deleteReminder(int id) async {
    try {
      await NotificationService.cancelNotification(id);
      print('🗑️ Cancelled notification for deleted reminder ID: $id');
    } catch (e) {
      print('⚠️ Warning: Could not cancel notification for deleted reminder: $e');
    }
    
    _reminderBoxManager.delete(id);
    print('✅ Deleted reminder from database ID: $id');
  }

  testNotification() async {
    // DateTime.now()
    //dateTimeToDefault ลบ ตามจำนวนชั่วโมงของไทม์โซนที่ต้องการ
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    // current time's offset in milliseconds from UTC
    final int offsetMilliseconds = now.timeZoneOffset.inMilliseconds;
    // Convert to hours
    final double offsetHours = offsetMilliseconds / 1000 / 60 / 60;
    DateTime dateTimeToDefault = DateTime.now().add(Duration(hours: -offsetHours.toInt()));
    // ทดสอบการแจ้งเตือน
    final testReminder = ReminderModel(
      title: 'ทดสอบการแจ้งเตือน',
      description: 'นี่คือการทดสอบการแจ้งเตือน',
      scheduledTime: dateTimeToDefault.add(const Duration(seconds: 3)).toIso8601String(),
      isActive: true,
      recurrenceType: RecurrenceType.none,
    );
    print("testReminder: ${testReminder.scheduledTime}");
    await NotificationService.scheduleNotification(testReminder);
  }
}

// Provider สำหรับเข้าถึง ReminderNotifier
// นี่คือตัวจัดการ Logic, ไม่ใช่ตัวถือ State ของ List อีกต่อไป
final reminderNotifierProvider = Provider((ref) => ReminderNotifier());
