# Forms Integration with Reminders

## 🎯 Overview
เพิ่มการรองรับ selected forms ใน Reminder system เพื่อให้สามารถเชื่อมโยงไฟล์ PDF กับ reminder ได้

## ✨ Changes Made

### 1. Updated ReminderNotifier (reminder_provider.dart)

#### addReminder Method
```dart
Future<void> addReminder(
  String title,
  String description,
  DateTime scheduledTime,
  RecurrenceType recurrenceType,
  int? dayOfWeek,
  int? dayOfMonth,
  int? monthOfYear,
  List<int>? selectedFormIds, // 🆕 New parameter
) async {
  // ...existing code...
  
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
  
  // ...rest of code...
}
```

#### updateReminder Method
```dart
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
  List<int>? selectedFormIds, // 🆕 New parameter
) async {
  // ...existing code...
  
  // Update forms relationship
  updatedReminder.forms.clear();
  if (selectedFormIds != null && selectedFormIds.isNotEmpty) {
    final formBoxManager = ObjectBoxDatabase.instance.formBoxManager;
    for (int formId in selectedFormIds) {
      final form = formBoxManager.get(formId);
      if (form != null) {
        updatedReminder.forms.add(form);
      }
    }
  }
  
  // ...rest of code...
}
```

### 2. Updated AddEditReminderNotifier (add_edit_reminder_provider_new.dart)

#### New Method: getSelectedFormIds
```dart
List<int> getSelectedFormIds() {
  return state.selectedPdfs.map((pdf) => pdf.id).toList();
}
```

#### Updated initializeForEdit
```dart
void initializeForEdit(ReminderModel reminder) {
  // ...existing code...
  
  state = state.copyWith(
    // ...existing properties...
    selectedPdfs: reminder.forms.toList(), // 🆕 Load existing selected forms
    isInitialized: true,
  );
}
```

### 3. Updated AddEditReminderScreen (add_edit_reminder_screen.dart)

#### Updated _saveReminder Method
```dart
Future<void> _saveReminder(BuildContext context, WidgetRef ref, AddEditReminderNotifier notifier) async {
  // ...existing validation...
  
  // Get selected form IDs
  final selectedFormIds = notifier.getSelectedFormIds();

  if (reminder == null) {
    // Add new reminder
    await reminderNotifier.addReminder(
      // ...existing parameters...
      selectedFormIds.isNotEmpty ? selectedFormIds : null, // 🆕 Pass selected forms
    );
  } else {
    // Update existing reminder
    await reminderNotifier.updateReminder(
      // ...existing parameters...
      selectedFormIds.isNotEmpty ? selectedFormIds : null, // 🆕 Pass selected forms
    );
  }
}
```

## 🔄 Data Flow

```
User selects PDFs → AddEditReminderState.selectedPdfs → getSelectedFormIds() → ReminderNotifier → ObjectBox ToMany relationship
```

### Flow Details:

1. **User selects PDFs**: ผู้ใช้เลือกไฟล์ PDF ใน MultiSelectPdfBottomSheet
2. **State updates**: `selectedPdfs` ใน AddEditReminderState อัปเดต
3. **Save action**: เมื่อผู้ใช้กด Save
4. **Get IDs**: `getSelectedFormIds()` แปลง FormModel เป็น List<int>
5. **Pass to provider**: ส่ง selectedFormIds ไปยัง ReminderNotifier
6. **Update database**: ObjectBox ToMany relationship ถูกอัปเดต

## 💾 Database Relationship

```dart
// In ReminderModel
final forms = ToMany<FormModel>();

// When saving/updating:
reminder.forms.clear();                    // Clear existing relationships
reminder.forms.add(selectedForm);         // Add new relationships
```

## 🔧 Usage Examples

### Creating new reminder with forms
```dart
await reminderNotifier.addReminder(
  'Review Legal Documents',
  'Review selected legal forms',
  DateTime.now().add(Duration(hours: 1)),
  RecurrenceType.none,
  null, // dayOfWeek
  null, // dayOfMonth  
  null, // monthOfYear
  [1, 2, 3], // selectedFormIds
);
```

### Updating reminder with new forms
```dart
await reminderNotifier.updateReminder(
  reminderId,
  'Updated: Review Legal Documents',
  'Updated description',
  DateTime.now().add(Duration(hours: 2)),
  true, // isActive
  RecurrenceType.daily,
  null, // dayOfWeek
  null, // dayOfMonth
  null, // monthOfYear
  [4, 5, 6], // new selectedFormIds
);
```

## ✅ Benefits

1. **Persistent Relationships**: ไฟล์ที่เลือกจะถูกบันทึกและโหลดกลับมาเมื่อแก้ไข
2. **Data Integrity**: ObjectBox ToMany relationship รับประกันความสมบูรณ์ของข้อมูล
3. **Efficient Updates**: เคลียร์และเพิ่มใหม่เมื่อมีการอัปเดต
4. **Null Safety**: รองรับกรณีที่ไม่มีไฟล์ที่เลือก

## 🧪 Testing

### Test Cases:
1. ✅ Create reminder without forms
2. ✅ Create reminder with single form
3. ✅ Create reminder with multiple forms
4. ✅ Edit reminder and change forms
5. ✅ Edit reminder and remove all forms
6. ✅ Load existing reminder with forms

## 📝 Notes

- ใช้ `selectedFormIds.isNotEmpty ? selectedFormIds : null` เพื่อส่ง null แทน empty list
- ObjectBox ToMany relationship จัดการ foreign key relationships อัตโนมัติ
- Forms ที่ถูกลบจาก database จะถูกลบออกจาก relationship อัตโนมัติ
