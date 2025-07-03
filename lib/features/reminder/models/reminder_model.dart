import 'package:flutter/material.dart';

enum ReminderType {
  court('court', 'นัดศาล', Icons.gavel),
  deadline('deadline', 'กำหนดเสร็จ', Icons.schedule),
  meeting('meeting', 'ประชุม', Icons.meeting_room),
  review('review', 'รีวิว', Icons.rate_review),
  payment('payment', 'ชำระเงิน', Icons.payment),
  renewal('renewal', 'ต่ออายุ', Icons.refresh);

  const ReminderType(this.value, this.displayName, this.icon);
  final String value;
  final String displayName;
  final IconData icon;
}

enum ReminderPriority {
  low('low', 'ไม่เร่งด่วน', Colors.green),
  medium('medium', 'ปานกลาง', Colors.blue),
  high('high', 'สำคัญ', Colors.orange),
  urgent('urgent', 'ด่วนมาก', Colors.red);

  const ReminderPriority(this.value, this.displayName, this.color);
  final String value;
  final String displayName;
  final Color color;
}

enum RepeatType {
  never('never', 'ไม่ทำซ้ำ'),
  daily('daily', 'ทุกวัน'),
  weekly('weekly', 'ทุกสัปดาห์'),
  monthly('monthly', 'ทุกเดือน'),
  yearly('yearly', 'ทุกปี');

  const RepeatType(this.value, this.displayName);
  final String value;
  final String displayName;
}

class ReminderModel {
  final String? id;
  final String title;
  final String description;
  final DateTime dueDate;
  final TimeOfDay? reminderTime;
  final ReminderType type;
  final ReminderPriority priority;
  final RepeatType repeatType;
  final bool isCompleted;
  final String? clientName;
  final String? caseNumber;
  final List<String> attachments;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ReminderModel({
    this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    this.reminderTime,
    required this.type,
    required this.priority,
    this.repeatType = RepeatType.never,
    this.isCompleted = false,
    this.clientName,
    this.caseNumber,
    this.attachments = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  ReminderModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    TimeOfDay? reminderTime,
    ReminderType? type,
    ReminderPriority? priority,
    RepeatType? repeatType,
    bool? isCompleted,
    String? clientName,
    String? caseNumber,
    List<String>? attachments,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ReminderModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      reminderTime: reminderTime ?? this.reminderTime,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      repeatType: repeatType ?? this.repeatType,
      isCompleted: isCompleted ?? this.isCompleted,
      clientName: clientName ?? this.clientName,
      caseNumber: caseNumber ?? this.caseNumber,
      attachments: attachments ?? this.attachments,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'reminderTime': reminderTime != null 
        ? '${reminderTime!.hour}:${reminderTime!.minute}' 
        : null,
      'type': type.value,
      'priority': priority.value,
      'repeatType': repeatType.value,
      'isCompleted': isCompleted,
      'clientName': clientName,
      'caseNumber': caseNumber,
      'attachments': attachments,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory ReminderModel.fromJson(Map<String, dynamic> json) {
    return ReminderModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dueDate: DateTime.parse(json['dueDate']),
      reminderTime: json['reminderTime'] != null 
        ? TimeOfDay(
            hour: int.parse(json['reminderTime'].split(':')[0]),
            minute: int.parse(json['reminderTime'].split(':')[1]),
          )
        : null,
      type: ReminderType.values.firstWhere(
        (e) => e.value == json['type'],
        orElse: () => ReminderType.deadline,
      ),
      priority: ReminderPriority.values.firstWhere(
        (e) => e.value == json['priority'],
        orElse: () => ReminderPriority.medium,
      ),
      repeatType: RepeatType.values.firstWhere(
        (e) => e.value == json['repeatType'],
        orElse: () => RepeatType.never,
      ),
      isCompleted: json['isCompleted'] ?? false,
      clientName: json['clientName'],
      caseNumber: json['caseNumber'],
      attachments: List<String>.from(json['attachments'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
