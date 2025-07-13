import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:law_app/core/database/models/form_model.dart';
import 'package:law_app/core/database/models/reminder_model.dart';
import 'package:law_app/core/database/objectbox_database.dart';

// State class
class AddEditReminderState {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final List<FormModel> availablePdfs;
  final List<FormModel> selectedPdfs;
  final DateTime? selectedDateTime;
  final String recurrenceType;
  final int? selectedDayOfWeek;
  final int? selectedDayOfMonth;
  final int? selectedMonthOfYear;
  final bool isActive;
  final bool isLoading;
  final bool isInitialized;
  final String? titleError;
  final String? dateTimeError;

  AddEditReminderState({
    required this.titleController,
    required this.descriptionController,
    required this.availablePdfs,
    required this.selectedPdfs,
    this.selectedDateTime,
    this.recurrenceType = 'none',
    this.selectedDayOfWeek,
    this.selectedDayOfMonth,
    this.selectedMonthOfYear,
    this.isActive = true,
    this.isLoading = false,
    this.isInitialized = false,
    this.titleError,
    this.dateTimeError,
  });

  bool get canSave {
    return titleController.text.trim().isNotEmpty &&
           selectedDateTime != null &&
           titleError == null &&
           dateTimeError == null &&
           !isLoading;
  }

  AddEditReminderState copyWith({
    TextEditingController? titleController,
    TextEditingController? descriptionController,
    List<FormModel>? availablePdfs,
    List<FormModel>? selectedPdfs,
    DateTime? selectedDateTime,
    String? recurrenceType,
    int? selectedDayOfWeek,
    int? selectedDayOfMonth,
    int? selectedMonthOfYear,
    bool? isActive,
    bool? isLoading,
    bool? isInitialized,
    String? titleError,
    String? dateTimeError,
    bool clearSelectedDateTime = false,
    bool clearSelectedDayOfWeek = false,
    bool clearSelectedDayOfMonth = false,
    bool clearSelectedMonthOfYear = false,
    bool clearTitleError = false,
    bool clearDateTimeError = false,
  }) {
    return AddEditReminderState(
      titleController: titleController ?? this.titleController,
      descriptionController: descriptionController ?? this.descriptionController,
      availablePdfs: availablePdfs ?? this.availablePdfs,
      selectedPdfs: selectedPdfs ?? this.selectedPdfs,
      selectedDateTime: clearSelectedDateTime ? null : (selectedDateTime ?? this.selectedDateTime),
      recurrenceType: recurrenceType ?? this.recurrenceType,
      selectedDayOfWeek: clearSelectedDayOfWeek ? null : (selectedDayOfWeek ?? this.selectedDayOfWeek),
      selectedDayOfMonth: clearSelectedDayOfMonth ? null : (selectedDayOfMonth ?? this.selectedDayOfMonth),
      selectedMonthOfYear: clearSelectedMonthOfYear ? null : (selectedMonthOfYear ?? this.selectedMonthOfYear),
      isActive: isActive ?? this.isActive,
      isLoading: isLoading ?? this.isLoading,
      isInitialized: isInitialized ?? this.isInitialized,
      titleError: clearTitleError ? null : (titleError ?? this.titleError),
      dateTimeError: clearDateTimeError ? null : (dateTimeError ?? this.dateTimeError),
    );
  }
}

// Notifier
class AddEditReminderNotifier extends StateNotifier<AddEditReminderState> {
  AddEditReminderNotifier() : super(AddEditReminderState(
    titleController: TextEditingController(),
    descriptionController: TextEditingController(),
    availablePdfs: [],
    selectedPdfs: [],
  )) {
    _loadAvailablePdfs();
  }

  @override
  void dispose() {
    state.titleController.dispose();
    state.descriptionController.dispose();
    super.dispose();
  }

  bool get isInitialized => state.isInitialized;
  set isInitialized (bool value) {
    state = state.copyWith(isInitialized: value);
  }

  void _loadAvailablePdfs() {
    try {
      final database = ObjectBoxDatabase.instance;
      final pdfs = database.formBoxManager.getAll();
      state = state.copyWith(availablePdfs: pdfs);
    } catch (e) {
      // Handle error
      print('Error loading PDFs: $e');
    }
  }

  void initializeForAdd() {
    if (state.isInitialized) return;
    final defaultDateTime = DateTime.now().add(const Duration(minutes: 5));
    state = state.copyWith(
      selectedDateTime: defaultDateTime,
      isInitialized: true,
    );
  }

  void initializeForEdit(ReminderModel reminder) {
    if (state.isInitialized) return;

    state.titleController.text = reminder.title;
    state.descriptionController.text = reminder.description;
    
    // Convert RecurrenceType enum to string
    String recurrenceType;
    switch (reminder.recurrenceType) {
      case RecurrenceType.none:
        recurrenceType = 'none';
        break;
      case RecurrenceType.daily:
        recurrenceType = 'daily';
        break;
      case RecurrenceType.weekly:
        recurrenceType = 'weekly';
        break;
      case RecurrenceType.monthly:
        recurrenceType = 'monthly';
        break;
      case RecurrenceType.yearly:
        recurrenceType = 'yearly';
        break;
    }

    state = state.copyWith(
      selectedDateTime: reminder.getScheduledDateTime,
      recurrenceType: recurrenceType,
      selectedDayOfWeek: reminder.dayOfWeek,
      selectedDayOfMonth: reminder.dayOfMonth,
      selectedMonthOfYear: reminder.monthOfYear,
      isActive: reminder.isActive,
      selectedPdfs: reminder.forms.toList(), // Load existing selected forms
      isInitialized: true,
      
    );
  }

  void setTitle(String title) {
    state = state.copyWith(
      titleError: title.trim().isEmpty ? 'กรุณาใส่ชื่อเตือนความจำ' : null,
      clearTitleError: title.trim().isNotEmpty,
    );
  }

  void setDescription(String description) {
    // Description is optional, no validation needed
  }

  void setSelectedDateTime(DateTime dateTime) {
    state = state.copyWith(
      selectedDateTime: dateTime,
      clearDateTimeError: true,
    );
  }

  void setRecurrenceType(String type) {
    state = state.copyWith(
      recurrenceType: type,
      clearSelectedDayOfWeek: type != 'weekly',
      clearSelectedDayOfMonth: type != 'monthly' && type != 'yearly',
      clearSelectedMonthOfYear: type != 'yearly',
    );

    // Auto-set values based on selected date
    if (state.selectedDateTime != null) {
      switch (type) {
        case 'weekly':
          state = state.copyWith(selectedDayOfWeek: state.selectedDateTime!.weekday);
          break;
        case 'monthly':
          state = state.copyWith(selectedDayOfMonth: state.selectedDateTime!.day);
          break;
        case 'yearly':
          state = state.copyWith(
            selectedDayOfMonth: state.selectedDateTime!.day,
            selectedMonthOfYear: state.selectedDateTime!.month,
          );
          break;
      }
    }
  }

  void setSelectedDayOfWeek(int? dayOfWeek) {
    state = state.copyWith(selectedDayOfWeek: dayOfWeek);
  }

  void setSelectedDayOfMonth(int? dayOfMonth) {
    state = state.copyWith(selectedDayOfMonth: dayOfMonth);
  }

  void setSelectedMonthOfYear(int? monthOfYear) {
    state = state.copyWith(selectedMonthOfYear: monthOfYear);
  }

  void setIsActive(bool isActive) {
    state = state.copyWith(isActive: isActive);
  }

  void addPdf(FormModel pdf) {
    if (!state.selectedPdfs.any((p) => p.id == pdf.id)) {
      final updatedPdfs = [...state.selectedPdfs, pdf];
      state = state.copyWith(selectedPdfs: updatedPdfs);
    }
  }

  void removePdf(FormModel pdf) {
    final updatedPdfs = state.selectedPdfs.where((p) => p.id != pdf.id).toList();
    state = state.copyWith(selectedPdfs: updatedPdfs);
  }

  void togglePdfSelection(FormModel pdf) {
    if (state.selectedPdfs.any((p) => p.id == pdf.id)) {
      removePdf(pdf);
    } else {
      addPdf(pdf);
    }
  }

  void clearAllPdfs() {
    state = state.copyWith(selectedPdfs: []);
  }

  bool validateForm() {
    String? titleError;
    String? dateTimeError;

    if (state.titleController.text.trim().isEmpty) {
      titleError = 'กรุณาใส่ชื่อเตือนความจำ';
    }

    if (state.selectedDateTime == null) {
      dateTimeError = 'กรุณาเลือกวันที่และเวลา';
    } else if (state.selectedDateTime!.isBefore(DateTime.now())) {
      dateTimeError = 'กรุณาเลือกเวลาในอนาคต';
    }

    state = state.copyWith(
      titleError: titleError,
      dateTimeError: dateTimeError,
    );

    return titleError == null && dateTimeError == null;
  }

  RecurrenceType getRecurrenceTypeEnum() {
    switch (state.recurrenceType) {
      case 'daily':
        return RecurrenceType.daily;
      case 'weekly':
        return RecurrenceType.weekly;
      case 'monthly':
        return RecurrenceType.monthly;
      case 'yearly':
        return RecurrenceType.yearly;
      default:
        return RecurrenceType.none;
    }
  }

  List<int> getSelectedFormIds() {
    return state.selectedPdfs.map((pdf) => pdf.id).toList();
  }
}

// Provider
final addEditReminderProvider = StateNotifierProvider<AddEditReminderNotifier, AddEditReminderState>((ref) {
  return AddEditReminderNotifier();
});

// Helper providers
final recurrenceNamesProvider = Provider<Map<String, String>>((ref) {
  return {
    'none': 'ไม่ต้องทำซ้ำ',
    'daily': 'ทุกวัน',
    'weekly': 'ทุกสัปดาห์',
    'monthly': 'ทุกเดือน',
    'yearly': 'ทุกปี',
  };
});

final weekdayNamesProvider = Provider<Map<int, String>>((ref) {
  return {
    1: 'จันทร์',
    2: 'อังคาร',
    3: 'พุธ',
    4: 'พฤหัสบดี',
    5: 'ศุกร์',
    6: 'เสาร์',
    7: 'อาทิตย์',
  };
});

final monthNamesProvider = Provider<Map<int, String>>((ref) {
  return {
    1: 'มกราคม',
    2: 'กุมภาพันธ์',
    3: 'มีนาคม',
    4: 'เมษายน',
    5: 'พฤษภาคม',
    6: 'มิถุนายน',
    7: 'กรกฎาคม',
    8: 'สิงหาคม',
    9: 'กันยายน',
    10: 'ตุลาคม',
    11: 'พฤศจิกายน',
    12: 'ธันวาคม',
  };
});
