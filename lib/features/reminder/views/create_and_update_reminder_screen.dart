import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/reminder_model.dart';
import '../providers/reminder_form_provider.dart';

class CreateAndUpdateReminderScreen extends ConsumerStatefulWidget {
  final ReminderModel? initialReminder;
  
  const CreateAndUpdateReminderScreen({
    super.key,
    this.initialReminder,
  });

  @override
  ConsumerState<CreateAndUpdateReminderScreen> createState() => _CreateAndUpdateReminderScreenState();
}

class _CreateAndUpdateReminderScreenState extends ConsumerState<CreateAndUpdateReminderScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _clientNameController;
  late final TextEditingController _caseNumberController;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialReminder?.title ?? '');
    _descriptionController = TextEditingController(text: widget.initialReminder?.description ?? '');
    _clientNameController = TextEditingController(text: widget.initialReminder?.clientName ?? '');
    _caseNumberController = TextEditingController(text: widget.initialReminder?.caseNumber ?? '');
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _clientNameController.dispose();
    _caseNumberController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(reminderFormProvider(widget.initialReminder));
    final formNotifier = ref.read(reminderFormProvider(widget.initialReminder).notifier);
    
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: _buildAppBar(context, formState, formNotifier, isTablet),
      body: _buildBody(context, formState, formNotifier, isTablet),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context, 
    ReminderFormState formState, 
    ReminderFormNotifier formNotifier,
    bool isTablet,
  ) {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.surface,
      leading: TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: Text(
          'ยกเลิก',
          style: TextStyle(
            fontSize: isTablet ? 18.sp : 16.sp,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      leadingWidth: 80.w,
      title: Text(
        formState.isEditing ? 'แก้ไขการแจ้งเตือน' : 'การแจ้งเตือนใหม่',
        style: TextStyle(
          fontSize: isTablet ? 20.sp : 18.sp,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      centerTitle: true,
      actions: [
        TextButton(
          onPressed: formState.isValid && !formState.isLoading 
            ? () => _saveReminder(formNotifier) 
            : null,
          child: formState.isLoading
            ? SizedBox(
                width: 20.w,
                height: 20.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2.w,
                  color: Theme.of(context).colorScheme.primary,
                ),
              )
            : Text(
                'บันทึก',
                style: TextStyle(
                  fontSize: isTablet ? 18.sp : 16.sp,
                  fontWeight: FontWeight.w600,
                  color: formState.isValid 
                    ? Theme.of(context).colorScheme.primary 
                    : Theme.of(context).colorScheme.outline,
                ),
              ),
        ),
        SizedBox(width: 8.w),
      ],
    );
  }

  Widget _buildBody(
    BuildContext context, 
    ReminderFormState formState, 
    ReminderFormNotifier formNotifier,
    bool isTablet,
  ) {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: EdgeInsets.all(isTablet ? 24.w : 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Error Banner
          if (formState.error != null) _buildErrorBanner(formState.error!, isTablet),
          
          // Basic Information Section
          _buildSectionHeader('ข้อมูลพื้นฐาน', Icons.info_outline, isTablet),
          SizedBox(height: 16.h),
          _buildBasicInfoSection(formState, formNotifier, isTablet),
          
          SizedBox(height: 32.h),
          
          // Date & Time Section
          _buildSectionHeader('วันที่และเวลา', Icons.schedule, isTablet),
          SizedBox(height: 16.h),
          _buildDateTimeSection(formState, formNotifier, isTablet),
          
          SizedBox(height: 32.h),
          
          // Settings Section
          _buildSectionHeader('การตั้งค่า', Icons.settings, isTablet),
          SizedBox(height: 16.h),
          _buildSettingsSection(formState, formNotifier, isTablet),
          
          SizedBox(height: 32.h),
          
          // Client Information Section
          _buildSectionHeader('ข้อมูลลูกค้า', Icons.person_outline, isTablet),
          SizedBox(height: 16.h),
          _buildClientInfoSection(formState, formNotifier, isTablet),
          
          SizedBox(height: 100.h), // Bottom padding
        ],
      ),
    );
  }

  Widget _buildErrorBanner(String error, bool isTablet) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.all(isTablet ? 16.w : 12.w),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red.shade600,
            size: isTablet ? 24.w : 20.w,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              error,
              style: TextStyle(
                fontSize: isTablet ? 16.sp : 14.sp,
                color: Colors.red.shade800,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, bool isTablet) {
    return Row(
      children: [
        Icon(
          icon,
          size: isTablet ? 24.w : 20.w,
          color: Theme.of(context).colorScheme.primary,
        ),
        SizedBox(width: 8.w),
        Text(
          title,
          style: TextStyle(
            fontSize: isTablet ? 20.sp : 18.sp,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildBasicInfoSection(
    ReminderFormState formState, 
    ReminderFormNotifier formNotifier,
    bool isTablet,
  ) {
    return Column(
      children: [
        // Title Field
        _buildTextField(
          controller: _titleController,
          label: 'หัวข้อการแจ้งเตือน',
          hint: 'เช่น นัดศาลแพ่ง, ยื่นเอกสาร',
          icon: Icons.title,
          isRequired: true,
          isTablet: isTablet,
          onChanged: formNotifier.updateTitle,
        ),
        
        SizedBox(height: 20.h),
        
        // Description Field
        _buildTextField(
          controller: _descriptionController,
          label: 'รายละเอียด',
          hint: 'อธิบายรายละเอียดการแจ้งเตือน',
          icon: Icons.description,
          isRequired: true,
          maxLines: 3,
          isTablet: isTablet,
          onChanged: formNotifier.updateDescription,
        ),
      ],
    );
  }

  Widget _buildDateTimeSection(
    ReminderFormState formState, 
    ReminderFormNotifier formNotifier,
    bool isTablet,
  ) {
    return Column(
      children: [
        // Due Date
        _buildDateTimeCard(
          title: 'วันที่กำหนด',
          subtitle: _formatDate(formState.dueDate),
          icon: Icons.calendar_today,
          onTap: () => _selectDate(formNotifier),
          isTablet: isTablet,
        ),
        
        SizedBox(height: 16.h),
        
        // Reminder Time
        _buildDateTimeCard(
          title: 'เวลาแจ้งเตือน',
          subtitle: formState.reminderTime != null 
            ? _formatTime(formState.reminderTime!) 
            : 'ไม่ได้ตั้งเวลา',
          icon: Icons.access_time,
          onTap: () => _selectTime(formNotifier),
          trailing: formState.reminderTime != null 
            ? IconButton(
                icon: Icon(Icons.clear, size: isTablet ? 20.w : 18.w),
                onPressed: () => formNotifier.updateReminderTime(null),
              ) 
            : null,
          isTablet: isTablet,
        ),
      ],
    );
  }

  Widget _buildSettingsSection(
    ReminderFormState formState, 
    ReminderFormNotifier formNotifier,
    bool isTablet,
  ) {
    return Column(
      children: [
        // Type Selection
        _buildSelectionCard(
          title: 'ประเภทการแจ้งเตือน',
          subtitle: formState.type.displayName,
          icon: formState.type.icon,
          iconColor: Theme.of(context).colorScheme.primary,
          onTap: () => _showTypeSelector(formNotifier, isTablet),
          isTablet: isTablet,
        ),
        
        SizedBox(height: 16.h),
        
        // Priority Selection
        _buildSelectionCard(
          title: 'ระดับความสำคัญ',
          subtitle: formState.priority.displayName,
          icon: Icons.priority_high,
          iconColor: formState.priority.color,
          onTap: () => _showPrioritySelector(formNotifier, isTablet),
          isTablet: isTablet,
        ),
        
        SizedBox(height: 16.h),
        
        // Repeat Selection
        _buildSelectionCard(
          title: 'การทำซ้ำ',
          subtitle: formState.repeatType.displayName,
          icon: Icons.repeat,
          iconColor: Theme.of(context).colorScheme.secondary,
          onTap: () => _showRepeatSelector(formNotifier, isTablet),
          isTablet: isTablet,
        ),
      ],
    );
  }

  Widget _buildClientInfoSection(
    ReminderFormState formState, 
    ReminderFormNotifier formNotifier,
    bool isTablet,
  ) {
    return Column(
      children: [
        // Client Name Field
        _buildTextField(
          controller: _clientNameController,
          label: 'ชื่อลูกค้า',
          hint: 'ชื่อบุคคล หรือ บริษัท',
          icon: Icons.person,
          isTablet: isTablet,
          onChanged: formNotifier.updateClientName,
        ),
        
        SizedBox(height: 20.h),
        
        // Case Number Field
        _buildTextField(
          controller: _caseNumberController,
          label: 'หมายเลขคดี',
          hint: 'เช่น ดำ 1234/2568',
          icon: Icons.folder,
          isTablet: isTablet,
          onChanged: formNotifier.updateCaseNumber,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required bool isTablet,
    required Function(String) onChanged,
    bool isRequired = false,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: isTablet ? 16.sp : 14.sp,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            if (isRequired) ...[
              SizedBox(width: 4.w),
              Text(
                '*',
                style: TextStyle(
                  fontSize: isTablet ? 16.sp : 14.sp,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            ),
          ),
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            maxLines: maxLines,
            style: TextStyle(
              fontSize: isTablet ? 16.sp : 14.sp,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                fontSize: isTablet ? 16.sp : 14.sp,
                color: Theme.of(context).colorScheme.outline,
              ),
              prefixIcon: Icon(
                icon,
                size: isTablet ? 24.w : 20.w,
                color: Theme.of(context).colorScheme.outline,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: isTablet ? 16.h : 12.h,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateTimeCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    required bool isTablet,
    Widget? trailing,
  }) {
    return _buildCard(
      child: ListTile(
        leading: Icon(
          icon,
          size: isTablet ? 24.w : 20.w,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: isTablet ? 16.sp : 14.sp,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: isTablet ? 14.sp : 12.sp,
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
        trailing: trailing ?? Icon(
          Icons.chevron_right,
          size: isTablet ? 24.w : 20.w,
          color: Theme.of(context).colorScheme.outline,
        ),
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(
          horizontal: isTablet ? 20.w : 16.w,
          vertical: isTablet ? 8.h : 4.h,
        ),
      ),
      isTablet: isTablet,
    );
  }

  Widget _buildSelectionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
    required bool isTablet,
  }) {
    return _buildCard(
      child: ListTile(
        leading: Icon(
          icon,
          size: isTablet ? 24.w : 20.w,
          color: iconColor,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: isTablet ? 16.sp : 14.sp,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: isTablet ? 14.sp : 12.sp,
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          size: isTablet ? 24.w : 20.w,
          color: Theme.of(context).colorScheme.outline,
        ),
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(
          horizontal: isTablet ? 20.w : 16.w,
          vertical: isTablet ? 8.h : 4.h,
        ),
      ),
      isTablet: isTablet,
    );
  }

  Widget _buildCard({
    required Widget child,
    required bool isTablet,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  // Helper Methods
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(date.year, date.month, date.day);
    
    if (targetDate == today) {
      return 'วันนี้ (${date.day}/${date.month}/${date.year})';
    } else if (targetDate == today.add(const Duration(days: 1))) {
      return 'พรุ่งนี้ (${date.day}/${date.month}/${date.year})';
    } else if (targetDate == today.subtract(const Duration(days: 1))) {
      return 'เมื่อวาน (${date.day}/${date.month}/${date.year})';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute น.';
  }

  // Action Methods
  Future<void> _selectDate(ReminderFormNotifier formNotifier) async {
    final date = await showDatePicker(
      context: context,
      initialDate: ref.read(reminderFormProvider(widget.initialReminder)).dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Theme.of(context).colorScheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (date != null) {
      formNotifier.updateDueDate(date);
    }
  }

  Future<void> _selectTime(ReminderFormNotifier formNotifier) async {
    final time = await showTimePicker(
      context: context,
      initialTime: ref.read(reminderFormProvider(widget.initialReminder)).reminderTime ?? 
                   TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Theme.of(context).colorScheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (time != null) {
      formNotifier.updateReminderTime(time);
    }
  }

  void _showTypeSelector(ReminderFormNotifier formNotifier, bool isTablet) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildSelectionBottomSheet(
        title: 'เลือกประเภทการแจ้งเตือน',
        items: ReminderType.values
          .map((type) => _SelectionItem(
            title: type.displayName,
            icon: type.icon,
            color: Theme.of(context).colorScheme.primary,
            onTap: () {
              formNotifier.updateType(type);
              Navigator.pop(context);
            },
          ))
          .toList(),
        isTablet: isTablet,
      ),
    );
  }

  void _showPrioritySelector(ReminderFormNotifier formNotifier, bool isTablet) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildSelectionBottomSheet(
        title: 'เลือกระดับความสำคัญ',
        items: ReminderPriority.values
          .map((priority) => _SelectionItem(
            title: priority.displayName,
            icon: Icons.priority_high,
            color: priority.color,
            onTap: () {
              formNotifier.updatePriority(priority);
              Navigator.pop(context);
            },
          ))
          .toList(),
        isTablet: isTablet,
      ),
    );
  }

  void _showRepeatSelector(ReminderFormNotifier formNotifier, bool isTablet) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildSelectionBottomSheet(
        title: 'เลือกการทำซ้ำ',
        items: RepeatType.values
          .map((repeat) => _SelectionItem(
            title: repeat.displayName,
            icon: Icons.repeat,
            color: Theme.of(context).colorScheme.secondary,
            onTap: () {
              formNotifier.updateRepeatType(repeat);
              Navigator.pop(context);
            },
          ))
          .toList(),
        isTablet: isTablet,
      ),
    );
  }

  Widget _buildSelectionBottomSheet({
    required String title,
    required List<_SelectionItem> items,
    required bool isTablet,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40.w,
            height: 4.h,
            margin: EdgeInsets.symmetric(vertical: 12.h),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          
          // Title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            child: Text(
              title,
              style: TextStyle(
                fontSize: isTablet ? 20.sp : 18.sp,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          
          // Divider
          Divider(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            thickness: 1,
          ),
          
          // Items
          ...items.map((item) => ListTile(
            leading: Icon(
              item.icon,
              color: item.color,
              size: isTablet ? 24.w : 20.w,
            ),
            title: Text(
              item.title,
              style: TextStyle(
                fontSize: isTablet ? 16.sp : 14.sp,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            onTap: item.onTap,
          )),
          
          SizedBox(height: MediaQuery.of(context).padding.bottom + 20.h),
        ],
      ),
    );
  }

  Future<void> _saveReminder(ReminderFormNotifier formNotifier) async {
    final success = await formNotifier.saveReminder();
    
    if (success && mounted) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ref.read(reminderFormProvider(widget.initialReminder)).isEditing 
              ? 'แก้ไขการแจ้งเตือนสำเร็จ'
              : 'สร้างการแจ้งเตือนสำเร็จ',
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
      );
      
      // Navigate back
      Navigator.of(context).pop(true);
    }
  }
}

class _SelectionItem {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SelectionItem({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}