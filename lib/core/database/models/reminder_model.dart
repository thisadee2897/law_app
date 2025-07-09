import 'package:objectbox/objectbox.dart';
import 'form_model.dart'; // สมมติว่าคุณมี FormModel อยู่แล้ว

enum RecurrenceType {
  none,      // ไม่เกิดซ้ำ
  daily,     // ทุกวัน
  weekly,    // ทุกสัปดาห์
  monthly,   // ทุกเดือน
  yearly,    // ทุกปี
}

@Entity()
class ReminderModel {
  @Id()
  int id;
  String title;
  String description;
  String scheduledTime; // เก็บเป็น ISO 8601 String เช่น "2023-10-27T10:30:00"
  bool isActive;


  RecurrenceType recurrenceType;

  // สำหรับ RecurrenceType.weekly: เก็บวันของสัปดาห์ (Sunday = 1, Monday = 2, ...)
  // หรืออาจจะใช้ List<int> ถ้าต้องการหลายวัน (Requires custom converter or separate entity)
  // For simplicity, let's assume one day for weekly or manage multiple days via a bitmask or separate relation
  // For this example, let's use a simple int for dayOfWeek for weekly.
  // If multiple days are needed, a ToMany<WeekdayModel> or similar would be better.
  int? dayOfWeek; // เช่น 1=จันทร์, 7=อาทิตย์ (สำหรับ weekly, หรือเป็นตัวระบุวันเมื่อใช้ monthly/yearly for a specific day of month/year)

  // สำหรับ RecurrenceType.monthly: เก็บวันที่ของเดือน (1-31)
  int? dayOfMonth;

  // สำหรับ RecurrenceType.yearly: เก็บเดือน (1-12) และวันที่ (1-31)
  int? monthOfYear;

  final forms = ToMany<FormModel>();

  ReminderModel({
    this.id = 0,
    this.description = '',
    this.title = '',
    required this.scheduledTime, // Format as ISO 8601 string
    this.isActive = true,
    this.recurrenceType = RecurrenceType.none,
    this.dayOfWeek,
    this.dayOfMonth,
    this.monthOfYear,
  });

  // Method to get DateTime from scheduledTime string
  DateTime get getScheduledDateTime => DateTime.parse(scheduledTime);

  // Method to copy and update fields
  ReminderModel copyWith({
    int? id,
    String? title,
    String? description,
    String? scheduledTime,
    bool? isActive,
    RecurrenceType? recurrenceType,
    int? dayOfWeek,
    int? dayOfMonth,
    int? monthOfYear,
  }) {
    return ReminderModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      isActive: isActive ?? this.isActive,
      recurrenceType: recurrenceType ?? this.recurrenceType,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      dayOfMonth: dayOfMonth ?? this.dayOfMonth,
      monthOfYear: monthOfYear ?? this.monthOfYear,
    );
  }
}