import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:law_app/core/database/models/reminder_model.dart';
import 'package:law_app/features/reminder/providers/reminder_provider.dart';

class AddEditReminderScreen extends ConsumerStatefulWidget {
  final ReminderModel? reminder; // ถ้ามีค่าคือแก้ไข, ถ้าไม่มีคือเพิ่ม

  const AddEditReminderScreen({super.key, this.reminder});

  @override
  ConsumerState<AddEditReminderScreen> createState() =>
      _AddEditReminderScreenState();
}

class _AddEditReminderScreenState extends ConsumerState<AddEditReminderScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController(); // เพิ่ม description controller
  DateTime? _selectedDateTime;
  bool _isActive = true;
  RecurrenceType _selectedRecurrenceType = RecurrenceType.none;
  int? _selectedDayOfWeek; // 1=จันทร์, ..., 7=อาทิตย์
  int? _selectedDayOfMonth;
  int? _selectedMonthOfYear;

  @override
  void initState() {
    super.initState();
    if (widget.reminder != null) {
      _titleController.text = widget.reminder!.title;
      _descriptionController.text = widget.reminder!.description; // กำหนดค่าเริ่มต้น
      _selectedDateTime = widget.reminder!.getScheduledDateTime;
      _isActive = widget.reminder!.isActive;
      _selectedRecurrenceType = widget.reminder!.recurrenceType;
      _selectedDayOfWeek = widget.reminder!.dayOfWeek;
      _selectedDayOfMonth = widget.reminder!.dayOfMonth;
      _selectedMonthOfYear = widget.reminder!.monthOfYear;
    } else {
      _selectedDateTime = DateTime.now().add(const Duration(minutes: 5)); // Default to 5 mins from now
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose(); // Dispose controller
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime ?? DateTime.now()),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _saveReminder() {
    if (_titleController.text.isEmpty || _selectedDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('โปรดใส่ชื่อเตือนความจำและเวลา')),
      );
      return;
    }

    // Clear specific recurrence fields if not relevant for the selected type
    int? finalDayOfWeek = (_selectedRecurrenceType == RecurrenceType.weekly) ? _selectedDayOfWeek : null;
    int? finalDayOfMonth = (_selectedRecurrenceType == RecurrenceType.monthly || _selectedRecurrenceType == RecurrenceType.yearly) ? _selectedDayOfMonth : null;
    int? finalMonthOfYear = (_selectedRecurrenceType == RecurrenceType.yearly) ? _selectedMonthOfYear : null;

    // เข้าถึง ReminderNotifier
    final reminderNotifier = ref.read(reminderNotifierProvider);

    if (widget.reminder == null) {
      // เพิ่มใหม่
      reminderNotifier.addReminder(
            _titleController.text,
            _descriptionController.text, // ใช้ค่าจาก description controller
            _selectedDateTime!,
            _selectedRecurrenceType,
            finalDayOfWeek,
            finalDayOfMonth,
            finalMonthOfYear,
          );
    } else {
      // แก้ไข
      reminderNotifier.updateReminder(
            widget.reminder!.id,
            _titleController.text,
            _descriptionController.text, // ใช้ค่าจาก description controller
            _selectedDateTime!,
            _isActive,
            _selectedRecurrenceType,
            finalDayOfWeek,
            finalDayOfMonth,
            finalMonthOfYear,
          );
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.reminder == null ? 'เพิ่มเตือนความจำ' : 'แก้ไขเตือนความจำ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'ชื่อเตือนความจำ',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'รายละเอียด (ไม่บังคับ)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text(
                  _selectedDateTime == null
                      ? 'เลือกวันและเวลา'
                      : DateFormat('dd/MM/yyyy HH:mm').format(_selectedDateTime!),
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickDateTime,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<RecurrenceType>(
                value: _selectedRecurrenceType,
                decoration: const InputDecoration(
                  labelText: 'การตั้งค่าซ้ำ',
                  border: OutlineInputBorder(),
                ),
                items: RecurrenceType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(_recurrenceTypeToString(type)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRecurrenceType = value!;
                    // Reset specific recurrence fields when type changes
                    _selectedDayOfWeek = null;
                    _selectedDayOfMonth = null;
                    _selectedMonthOfYear = null;
                    // If setting to weekly, pre-select current day of week if not already set
                    if (_selectedRecurrenceType == RecurrenceType.weekly && _selectedDateTime != null) {
                      _selectedDayOfWeek = _selectedDateTime!.weekday; // Dart weekday: 1=Mon, 7=Sun
                    }
                    // If setting to monthly/yearly, pre-select current day of month/month if not already set
                    if (_selectedRecurrenceType == RecurrenceType.monthly && _selectedDateTime != null) {
                      _selectedDayOfMonth = _selectedDateTime!.day;
                    }
                     if (_selectedRecurrenceType == RecurrenceType.yearly && _selectedDateTime != null) {
                      _selectedDayOfMonth = _selectedDateTime!.day;
                      _selectedMonthOfYear = _selectedDateTime!.month;
                    }
                  });
                },
              ),
              // UI สำหรับตั้งค่าเพิ่มเติมตามประเภทการซ้ำ
              if (_selectedRecurrenceType == RecurrenceType.weekly)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: DropdownButtonFormField<int>(
                    value: _selectedDayOfWeek,
                    decoration: const InputDecoration(
                      labelText: 'ทุกวัน',
                      border: OutlineInputBorder(),
                    ),
                    items: {
                      1: 'จันทร์', 2: 'อังคาร', 3: 'พุธ', 4: 'พฤหัสบดี',
                      5: 'ศุกร์', 6: 'เสาร์', 7: 'อาทิตย์'
                    }.entries.map((entry) {
                      return DropdownMenuItem(
                        value: entry.key,
                        child: Text(entry.value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedDayOfWeek = value;
                      });
                    },
                  ),
                ),
              if (_selectedRecurrenceType == RecurrenceType.monthly || _selectedRecurrenceType == RecurrenceType.yearly)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: DropdownButtonFormField<int>(
                    value: _selectedDayOfMonth,
                    decoration: const InputDecoration(
                      labelText: 'วันที่ของเดือน',
                      border: OutlineInputBorder(),
                    ),
                    items: List.generate(31, (index) => index + 1).map((day) {
                      return DropdownMenuItem(
                        value: day,
                        child: Text('$day'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedDayOfMonth = value;
                      });
                    },
                  ),
                ),
              if (_selectedRecurrenceType == RecurrenceType.yearly)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: DropdownButtonFormField<int>(
                    value: _selectedMonthOfYear,
                    decoration: const InputDecoration(
                      labelText: 'เดือนของปี',
                      border: OutlineInputBorder(),
                    ),
                    items: {
                      1: 'มกราคม', 2: 'กุมภาพันธ์', 3: 'มีนาคม', 4: 'เมษายน',
                      5: 'พฤษภาคม', 6: 'มิถุนายน', 7: 'กรกฎาคม', 8: 'สิงหาคม',
                      9: 'กันยายน', 10: 'ตุลาคม', 11: 'พฤศจิกายน', 12: 'ธันวาคม',
                    }.entries.map((entry) {
                      return DropdownMenuItem(
                        value: entry.key,
                        child: Text(entry.value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedMonthOfYear = value;
                      });
                    },
                  ),
                ),

              if (widget.reminder != null) ...[
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('เปิดใช้งานการแจ้งเตือน'),
                  value: _isActive,
                  onChanged: (value) {
                    setState(() {
                      _isActive = value;
                    });
                  },
                ),
              ],
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveReminder,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    widget.reminder == null ? 'เพิ่มเตือนความจำ' : 'บันทึกการเปลี่ยนแปลง',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _recurrenceTypeToString(RecurrenceType type) {
    switch (type) {
      case RecurrenceType.none:
        return 'ไม่เกิดซ้ำ';
      case RecurrenceType.daily:
        return 'ทุกวัน';
      case RecurrenceType.weekly:
        return 'ทุกสัปดาห์';
      case RecurrenceType.monthly:
        return 'ทุกเดือน';
      case RecurrenceType.yearly:
        return 'ทุกปี';
    }
  }
}