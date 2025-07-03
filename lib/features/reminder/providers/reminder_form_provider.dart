import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/reminder_model.dart';

// State for the reminder form
class ReminderFormState {
  final ReminderModel? editingReminder;
  final String title;
  final String description;
  final DateTime dueDate;
  final TimeOfDay? reminderTime;
  final ReminderType type;
  final ReminderPriority priority;
  final RepeatType repeatType;
  final String clientName;
  final String caseNumber;
  final bool isLoading;
  final String? error;

  const ReminderFormState({
    this.editingReminder,
    this.title = '',
    this.description = '',
    required this.dueDate,
    this.reminderTime,
    this.type = ReminderType.deadline,
    this.priority = ReminderPriority.medium,
    this.repeatType = RepeatType.never,
    this.clientName = '',
    this.caseNumber = '',
    this.isLoading = false,
    this.error,
  });

  ReminderFormState copyWith({
    ReminderModel? editingReminder,
    String? title,
    String? description,
    DateTime? dueDate,
    TimeOfDay? reminderTime,
    ReminderType? type,
    ReminderPriority? priority,
    RepeatType? repeatType,
    String? clientName,
    String? caseNumber,
    bool? isLoading,
    String? error,
  }) {
    return ReminderFormState(
      editingReminder: editingReminder ?? this.editingReminder,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      reminderTime: reminderTime ?? this.reminderTime,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      repeatType: repeatType ?? this.repeatType,
      clientName: clientName ?? this.clientName,
      caseNumber: caseNumber ?? this.caseNumber,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  bool get isEditing => editingReminder != null;
  
  bool get isValid => title.trim().isNotEmpty && description.trim().isNotEmpty;
  
  ReminderModel toReminderModel() {
    final now = DateTime.now();
    return ReminderModel(
      id: editingReminder?.id,
      title: title.trim(),
      description: description.trim(),
      dueDate: dueDate,
      reminderTime: reminderTime,
      type: type,
      priority: priority,
      repeatType: repeatType,
      clientName: clientName.trim().isEmpty ? null : clientName.trim(),
      caseNumber: caseNumber.trim().isEmpty ? null : caseNumber.trim(),
      createdAt: editingReminder?.createdAt ?? now,
      updatedAt: now,
    );
  }
}

// Form state notifier
class ReminderFormNotifier extends StateNotifier<ReminderFormState> {
  ReminderFormNotifier([ReminderModel? initialReminder]) : super(
    ReminderFormState(
      editingReminder: initialReminder,
      title: initialReminder?.title ?? '',
      description: initialReminder?.description ?? '',
      dueDate: initialReminder?.dueDate ?? DateTime.now(),
      reminderTime: initialReminder?.reminderTime,
      type: initialReminder?.type ?? ReminderType.deadline,
      priority: initialReminder?.priority ?? ReminderPriority.medium,
      repeatType: initialReminder?.repeatType ?? RepeatType.never,
      clientName: initialReminder?.clientName ?? '',
      caseNumber: initialReminder?.caseNumber ?? '',
    ),
  );

  void updateTitle(String title) {
    state = state.copyWith(title: title, error: null);
  }

  void updateDescription(String description) {
    state = state.copyWith(description: description, error: null);
  }

  void updateDueDate(DateTime dueDate) {
    state = state.copyWith(dueDate: dueDate, error: null);
  }

  void updateReminderTime(TimeOfDay? time) {
    state = state.copyWith(reminderTime: time, error: null);
  }

  void updateType(ReminderType type) {
    state = state.copyWith(type: type, error: null);
  }

  void updatePriority(ReminderPriority priority) {
    state = state.copyWith(priority: priority, error: null);
  }

  void updateRepeatType(RepeatType repeatType) {
    state = state.copyWith(repeatType: repeatType, error: null);
  }

  void updateClientName(String clientName) {
    state = state.copyWith(clientName: clientName, error: null);
  }

  void updateCaseNumber(String caseNumber) {
    state = state.copyWith(caseNumber: caseNumber, error: null);
  }

  Future<bool> saveReminder() async {
    if (!state.isValid) {
      state = state.copyWith(error: 'กรุณากรอกข้อมูลให้ครบถ้วน');
      return false;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 1500));
      
      // In real implementation, save to database/API here
      // final reminder = state.toReminderModel();
      
      // Mock success
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'เกิดข้อผิดพลาดในการบันทึกข้อมูล',
      );
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Providers
final reminderFormProvider = StateNotifierProvider.family<ReminderFormNotifier, ReminderFormState, ReminderModel?>(
  (ref, initialReminder) => ReminderFormNotifier(initialReminder),
);
