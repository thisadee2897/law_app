import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:law_app/core/database/models/reminder_model.dart';
import 'package:law_app/features/reminder/providers/add_edit_reminder_provider_new.dart';
import 'package:law_app/features/reminder/providers/reminder_provider.dart';
import 'package:law_app/features/reminder/widgets/custom_widgets.dart';
import 'package:law_app/features/reminder/widgets/multi_select_pdf_bottom_sheet.dart';
import 'package:law_app/features/reminder/widgets/recurrence_bottom_sheet.dart';

class AddEditReminderScreen extends ConsumerStatefulWidget {
  final ReminderModel? reminder;

  const AddEditReminderScreen({super.key, this.reminder});

  @override
  ConsumerState<AddEditReminderScreen> createState() => _AddEditReminderScreenState();
}

class _AddEditReminderScreenState extends ConsumerState<AddEditReminderScreen> {
  @override
  void initState() {
    // Initialize if editing existing reminder
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(addEditReminderProvider);
      final notifier = ref.read(addEditReminderProvider.notifier);
      print("reminder: ${widget.reminder}");
      print("isInitialized: ${state.isInitialized}");
      if (widget.reminder != null && !state.isInitialized) {
        notifier.initializeForEdit(widget.reminder!);
      } else if (widget.reminder == null && state.isInitialized) {
        notifier.initializeForAdd();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(addEditReminderProvider);
    final notifier = ref.read(addEditReminderProvider.notifier);
    final recurrenceNames = ref.watch(recurrenceNamesProvider);
    final weekdayNames = ref.watch(weekdayNamesProvider);
    final monthNames = ref.watch(monthNamesProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: theme.textTheme.titleLarge?.color,
        title: Text(
          widget.reminder == null ? 'เพิ่มเตือนความจำ' : 'แก้ไขเตือนความจำ',
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        // actions: [
        //   if (state.canSave)
        //     TextButton(
        //       onPressed: () => _saveReminder(context, ref, notifier),
        //       child: Text('บันทึก', style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.w600)),
        //     ),
        // ],
      ),
      body:
          state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title Section
                    CustomCard(
                      child: CustomTextField(
                        label: 'ชื่อเตือนความจำ',
                        hintText: 'ใส่ชื่อเตือนความจำ...',
                        controller: state.titleController,
                        prefixIcon: Icons.title,
                        errorText: state.titleError,
                        onChanged: notifier.setTitle,
                      ),
                    ),
                    // Description Section
                    CustomCard(
                      child: CustomTextField(
                        label: 'รายละเอียด (ไม่บังคับ)',
                        hintText: 'เพิ่มรายละเอียดเตือนความจำ...',
                        controller: state.descriptionController,
                        prefixIcon: Icons.description,
                        maxLines: 3,
                        onChanged: notifier.setDescription,
                      ),
                    ),

                    // PDF Selection Section
                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ไฟล์ PDF ที่เกี่ยวข้อง', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 12),
                          SelectionCard(
                            title: state.selectedPdfs.isEmpty ? 'เลือกไฟล์ PDF' : '${state.selectedPdfs.length} ไฟล์ที่เลือก',
                            icon: Icons.picture_as_pdf,
                            hasValue: state.selectedPdfs.isNotEmpty,
                            onTap: () => _showPdfSelection(context, notifier),
                          ),
                          if (state.selectedPdfs.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Wrap(
                              children:
                                  state.selectedPdfs.map((pdf) => SelectedPdfChip(fileName: pdf.formName, onRemove: () => notifier.removePdf(pdf))).toList(),
                            ),
                          ],
                        ],
                      ),
                    ),

                    // Date & Time Selection
                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('วันที่และเวลา', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 12),
                          SelectionCard(
                            title:
                                state.selectedDateTime == null ? 'เลือกวันและเวลา' : DateFormat('dd MMMM yyyy, HH:mm น.', 'th').format(state.selectedDateTime!),
                            subtitle: state.selectedDateTime == null ? 'แตะเพื่อเลือกวันที่และเวลาแจ้งเตือน' : _getRelativeTimeText(state.selectedDateTime!),
                            icon: Icons.schedule,
                            hasValue: state.selectedDateTime != null,
                            errorText: state.dateTimeError,
                            onTap: () => _pickDateTime(context, ref, notifier),
                          ),
                        ],
                      ),
                    ),

                    // Recurrence Section
                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('การทำซ้ำ', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 12),
                          SelectionCard(
                            title: recurrenceNames[state.recurrenceType] ?? 'ไม่ทำซ้ำ',
                            subtitle: _getRecurrenceSubtitle(state, weekdayNames, monthNames),
                            icon: Icons.repeat,
                            hasValue: state.recurrenceType != 'none',
                            onTap: () => _showRecurrenceSelection(context, ref, notifier),
                          ),
                        ],
                      ),
                    ),

                    // Active Status (for editing only)
                    if (widget.reminder != null)
                      CustomCard(
                        child: SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text('เปิดใช้งานการแจ้งเตือน', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                          subtitle: Text(
                            state.isActive ? 'การแจ้งเตือนจะทำงานตามที่กำหนด' : 'การแจ้งเตือนถูกปิดใช้งาน',
                            style: theme.textTheme.bodyMedium?.copyWith(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7)),
                          ),
                          value: state.isActive,
                          onChanged: notifier.setIsActive,
                        ),
                      ),

                    const SizedBox(height: 32),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: state.canSave ? () => _saveReminder(context, ref, notifier) : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primaryColor,
                          foregroundColor: theme.colorScheme.onPrimary,
                          disabledBackgroundColor: theme.disabledColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: Text(
                          widget.reminder == null ? 'เพิ่มเตือนความจำ' : 'บันทึกการเปลี่ยนแปลง',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
    );
  }

  // Helper functions
  String _getRelativeTimeText(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now);

    if (difference.inMinutes < 0) {
      return 'เวลาที่ผ่านมาแล้ว';
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

  String? _getRecurrenceSubtitle(AddEditReminderState state, Map<int, String> weekdayNames, Map<int, String> monthNames) {
    switch (state.recurrenceType) {
      case 'weekly':
        if (state.selectedDayOfWeek != null) {
          return 'ทุกวัน${weekdayNames[state.selectedDayOfWeek!]}';
        }
        break;
      case 'monthly':
        if (state.selectedDayOfMonth != null) {
          return 'ทุกวันที่ ${state.selectedDayOfMonth!} ของเดือน';
        }
        break;
      case 'yearly':
        if (state.selectedDayOfMonth != null && state.selectedMonthOfYear != null) {
          return 'ทุกวันที่ ${state.selectedDayOfMonth!} ${monthNames[state.selectedMonthOfYear!]}';
        }
        break;
      case 'daily':
        return 'ทุกวันในเวลาเดียวกัน';
      case 'none':
      default:
        return 'แจ้งเตือนเพียงครั้งเดียว';
    }
    return null;
  }

  Future<void> _pickDateTime(BuildContext context, WidgetRef ref, AddEditReminderNotifier notifier) async {
    final state = ref.read(addEditReminderProvider);
    final initialDate = state.selectedDateTime ?? DateTime.now().add(const Duration(minutes: 5));

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      locale: const Locale('th'),
    );

    if (pickedDate != null && context.mounted) {
      final TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(initialDate));

      if (pickedTime != null) {
        final selectedDateTime = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, pickedTime.hour, pickedTime.minute);
        notifier.setSelectedDateTime(selectedDateTime);
      }
    }
  }

  void _showPdfSelection(BuildContext context, AddEditReminderNotifier notifier) {
    // final state = ref.read(addEditReminderProvider);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Consumer(
            builder: (context, refPdfSelection, child) {
              final state = refPdfSelection.watch(addEditReminderProvider);
              return MultiSelectPdfBottomSheet(
                availablePdfs: state.availablePdfs,
                selectedPdfs: state.selectedPdfs,
                onToggle: notifier.togglePdfSelection,
                onClearAll: notifier.clearAllPdfs,
              );
            },
          ),
    );
  }

  void _showRecurrenceSelection(BuildContext context, WidgetRef ref, AddEditReminderNotifier notifier) {
    final state = ref.read(addEditReminderProvider);

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => RecurrenceBottomSheet(currentRecurrence: state.recurrenceType, onRecurrenceChanged: notifier.setRecurrenceType),
    );
  }

  Future<void> _saveReminder(BuildContext context, WidgetRef ref, AddEditReminderNotifier notifier) async {
    if (!notifier.validateForm()) {
      return;
    }

    try {
      final state = ref.read(addEditReminderProvider);
      final reminderNotifier = ref.read(reminderNotifierProvider);

      // Calculate final recurrence values
      int? finalDayOfWeek = (state.recurrenceType == 'weekly') ? state.selectedDayOfWeek : null;
      int? finalDayOfMonth = (state.recurrenceType == 'monthly' || state.recurrenceType == 'yearly') ? state.selectedDayOfMonth : null;
      int? finalMonthOfYear = (state.recurrenceType == 'yearly') ? state.selectedMonthOfYear : null;

      // Get selected form IDs
      final selectedFormIds = notifier.getSelectedFormIds();

      if (widget.reminder == null) {
        // Add new reminder
        await reminderNotifier.addReminder(
          state.titleController.text.trim(),
          state.descriptionController.text.trim(),
          state.selectedDateTime!,
          notifier.getRecurrenceTypeEnum(),
          finalDayOfWeek,
          finalDayOfMonth,
          finalMonthOfYear,
          selectedFormIds.isNotEmpty ? selectedFormIds : null,
        );
      } else {
        // Update existing reminder
        await reminderNotifier.updateReminder(
          widget.reminder!.id,
          state.titleController.text.trim(),
          state.descriptionController.text.trim(),
          state.selectedDateTime!,
          state.isActive,
          notifier.getRecurrenceTypeEnum(),
          finalDayOfWeek,
          finalDayOfMonth,
          finalMonthOfYear,
          selectedFormIds.isNotEmpty ? selectedFormIds : null,
        );
      }

      if (context.mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('เกิดข้อผิดพลาด: $e'), backgroundColor: Theme.of(context).colorScheme.error));
      }
    }
  }
}
