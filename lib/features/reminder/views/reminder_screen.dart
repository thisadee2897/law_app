import 'dart:io';

import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:alarm/model/notification_settings.dart';
import 'package:alarm/model/volume_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:law_app/components/export.dart';
import 'package:law_app/core/router/app_router.dart';
import 'package:law_app/core/router/route_config.dart';
import 'package:law_app/core/utils/extension/context_extensions.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

enum ReminderType { court, deadline, meeting, review, payment, renewal }

enum ReminderPriority { low, medium, high, urgent }

class Reminder {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final ReminderType type;
  final ReminderPriority priority;
  final bool isCompleted;
  final String? clientName;
  final String? caseNumber;

  Reminder({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.type,
    required this.priority,
    this.isCompleted = false,
    this.clientName,
    this.caseNumber,
  });
}

class ReminderScreen extends ConsumerStatefulWidget {
  const ReminderScreen({super.key});

  @override
  ConsumerState<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends ConsumerState<ReminderScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'ทั้งหมด';

  final List<String> _filters = ['ทั้งหมด', 'วันนี้', 'สัปดาห์นี้', 'เดือนนี้', 'เลยกำหนด'];

  // Mock data for demonstration
  final List<Reminder> _reminders = [
    Reminder(
      id: '1',
      title: 'นัดศาลแพ่ง',
      description: 'คดีพิพาทสัญญาซื้อขาย ห้องศาล 205',
      dueDate: DateTime.now().add(const Duration(days: 1)),
      type: ReminderType.court,
      priority: ReminderPriority.urgent,
      clientName: 'บริษัท ABC จำกัด',
      caseNumber: 'ดำ 1234/2568',
    ),
    Reminder(
      id: '2',
      title: 'ยื่นคำแก้ต่าง',
      description: 'ยื่นคำแก้ต่างคดีละเมิดลิขสิทธิ์',
      dueDate: DateTime.now().add(const Duration(days: 3)),
      type: ReminderType.deadline,
      priority: ReminderPriority.high,
      clientName: 'นาย สมชาย ใจดี',
      caseNumber: 'อ 5678/2568',
    ),
    Reminder(
      id: '3',
      title: 'ประชุมลูกค้า',
      description: 'ปรึกษาเรื่องการจดทะเบียนบริษัท',
      dueDate: DateTime.now().add(const Duration(hours: 4)),
      type: ReminderType.meeting,
      priority: ReminderPriority.medium,
      clientName: 'นางสาว มานี รวยมาก',
    ),
    Reminder(
      id: '4',
      title: 'ต่อใบอนุญาต',
      description: 'ต่อใบอนุญาตประกอบธุรกิจนำเที่ยว',
      dueDate: DateTime.now().add(const Duration(days: 7)),
      type: ReminderType.renewal,
      priority: ReminderPriority.medium,
      clientName: 'บริษัท ท่องเที่ยวดี จำกัด',
    ),
    Reminder(
      id: '5',
      title: 'ชำระค่าธรรมเนียม',
      description: 'ชำระค่าธรรมเนียมการจดทะเบียนเครื่องหมายการค้า',
      dueDate: DateTime.now().subtract(const Duration(days: 2)),
      type: ReminderType.payment,
      priority: ReminderPriority.urgent,
      clientName: 'บริษัท ดีไซน์ดี จำกัด',
    ),
    Reminder(
      id: '6',
      title: 'รีวิวสัญญา',
      description: 'ตรวจสอบร่างสัญญาจ้างที่ปรึกษา',
      dueDate: DateTime.now().add(const Duration(days: 5)),
      type: ReminderType.review,
      priority: ReminderPriority.low,
      clientName: 'บริษัท เทคโนโลยี จำกัด',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Reminder> get _filteredReminders {
    final now = DateTime.now();
    switch (_selectedFilter) {
      case 'วันนี้':
        return _reminders.where((r) => r.dueDate.year == now.year && r.dueDate.month == now.month && r.dueDate.day == now.day).toList();
      case 'สัปดาห์นี้':
        final weekStart = now.subtract(Duration(days: now.weekday - 1));
        final weekEnd = weekStart.add(const Duration(days: 6));
        return _reminders.where((r) => r.dueDate.isAfter(weekStart) && r.dueDate.isBefore(weekEnd.add(const Duration(days: 1)))).toList();
      case 'เดือนนี้':
        return _reminders.where((r) => r.dueDate.year == now.year && r.dueDate.month == now.month).toList();
      case 'เลยกำหนด':
        return _reminders.where((r) => r.dueDate.isBefore(now) && !r.isCompleted).toList();
      default:
        return _reminders;
    }
  }

  List<Reminder> get _activeReminders => _filteredReminders.where((r) => !r.isCompleted).toList();
  List<Reminder> get _completedReminders => _filteredReminders.where((r) => r.isCompleted).toList();
  final alarmSettings = AlarmSettings(
    id: 42,
    dateTime: DateTime.now().add(const Duration(seconds: 10)),
    assetAudioPath: 'assets/alarm.mp3',
    loopAudio: true,
    vibrate: true,
    warningNotificationOnKill: Platform.isIOS,
    androidFullScreenIntent: true,
    volumeSettings: VolumeSettings.fade(volume: 0.8, fadeDuration: Duration(seconds: 5), volumeEnforced: true),
    notificationSettings: const NotificationSettings(
      title: 'This is the title',
      body: 'This is the body',
      stopButton: 'Stop the alarm',
      icon: 'notification_icon',
      iconColor: Color(0xff862778),
    ),
  );
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          // Modern App Bar with Gradient
          SliverAppBar(
            // expandedHeight: isTablet ? 280.h : 240.h,
            expandedHeight: 260,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [context.primaryColor, context.primaryColor.withRed(180), context.primaryColor.withRed(150)],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: isTablet ? 40.w : 24.w, vertical: 16.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10.h),
                            // Header
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'การแจ้งเตือน',
                                        style: TextStyle(fontSize: isTablet ? 36.sp : 28.sp, fontWeight: FontWeight.bold, color: Colors.white),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        'จัดการตารางงานและการแจ้งเตือน',
                                        style: TextStyle(fontSize: isTablet ? 18.sp : 14.sp, color: Colors.white.withOpacity(0.9)),
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    await Alarm.set(alarmSettings: alarmSettings);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(isTablet ? 16.w : 12.w),
                                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(16.r)),
                                    child: Icon(Icons.notifications_active, size: isTablet ? 40.w : 32.w, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            // Stats Cards
                            _buildStatsRow(isTablet),
                            // Filter Chips
                          ],
                        ),
                      ),
                      _buildFilterChips(isTablet),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Tab Bar
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(25.r)),
              child: TabBar(
                splashBorderRadius: BorderRadius.all(Radius.circular(50)),
                dividerColor: Colors.transparent,
                controller: _tabController,
                indicator: BoxDecoration(borderRadius: BorderRadius.circular(25.r), color: Theme.of(context).colorScheme.primary),
                labelColor: Colors.white,
                unselectedLabelColor: Theme.of(context).colorScheme.onSurface,
                tabs: [
                  Tab(
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        textAlign: TextAlign.center,
                        'รอดำเนินการ (${_activeReminders.length})',
                        style: TextStyle(fontSize: isTablet ? 16.sp : 14.sp),
                      ),
                    ),
                  ),
                  Tab(
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        textAlign: TextAlign.center,
                        'เสร็จแล้ว (${_completedReminders.length})',
                        style: TextStyle(fontSize: isTablet ? 16.sp : 14.sp),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Tab Content
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [_buildReminderList(_activeReminders, isTablet, false), _buildReminderList(_completedReminders, isTablet, true)],
            ),
          ),
        ],
      ),
      //floatingActionButton add
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ref.goSubPath(Routes.createOrUpdateReminder);
        },
        icon: const Icon(Icons.add),
        label: const Text('เพิ่มการแจ้งเตือน', style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildStatsRow(bool isTablet) {
    final urgentCount = _reminders.where((r) => r.priority == ReminderPriority.urgent && !r.isCompleted).length;
    final todayCount = _reminders.where((r) => r.dueDate.day == DateTime.now().day && r.dueDate.month == DateTime.now().month && !r.isCompleted).length;
    final overdueCount = _reminders.where((r) => r.dueDate.isBefore(DateTime.now()) && !r.isCompleted).length;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildStatsCard('ด่วน', '$urgentCount', Icons.priority_high, Colors.red, isTablet),
          SizedBox(width: 12.w),
          _buildStatsCard('วันนี้', '$todayCount', Icons.today, Colors.blue, isTablet),
          SizedBox(width: 12.w),
          _buildStatsCard('เลยกำหนด', '$overdueCount', Icons.warning, Colors.orange, isTablet),
        ],
      ),
    );
  }

  Widget _buildStatsCard(String title, String value, IconData icon, Color color, bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 16.w : 12.w),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(16.r)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: isTablet ? 24.w : 20.w),
          SizedBox(width: 8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(value, style: TextStyle(fontSize: isTablet ? 20.sp : 16.sp, fontWeight: FontWeight.bold, color: Colors.white)),
              Text(title, style: TextStyle(fontSize: isTablet ? 12.sp : 10.sp, color: Colors.white.withOpacity(0.8))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(bool isTablet) {
    return SizedBox(
      height: isTablet ? 50.h : 40.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (context, index) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = _selectedFilter == filter;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedFilter = filter;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: isTablet ? 20.w : 16.w, vertical: isTablet ? 12.h : 8.h),
              decoration: BoxDecoration(color: isSelected ? Colors.white : Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20.r)),
              child: Text(
                filter,
                style: TextStyle(
                  color: isSelected ? Theme.of(context).colorScheme.primary : Colors.white,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: isTablet ? 14.sp : 12.sp,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildReminderList(List<Reminder> reminders, bool isTablet, bool isCompleted) {
    if (reminders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isCompleted ? Icons.check_circle_outline : Icons.notifications_none,
              size: isTablet ? 120.w : 80.w,
              color: Theme.of(context).colorScheme.outline,
            ),
            SizedBox(height: 16.h),
            Text(
              isCompleted ? 'ไม่มีงานที่เสร็จแล้ว' : 'ไม่มีการแจ้งเตือน',
              style: TextStyle(fontSize: isTablet ? 20.sp : 16.sp, color: Theme.of(context).colorScheme.outline),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(isTablet ? 24.w : 16.w),
      itemCount: reminders.length,
      separatorBuilder: (context, index) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final reminder = reminders[index];
        return _buildReminderCard(reminder, isTablet);
      },
    );
  }

  Widget _buildReminderCard(Reminder reminder, bool isTablet) {
    final isOverdue = reminder.dueDate.isBefore(DateTime.now()) && !reminder.isCompleted;
    final priorityColor = _getPriorityColor(reminder.priority);
    final typeIcon = _getTypeIcon(reminder.type);

    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          padding: EdgeInsets.all(isTablet ? 20.w : 16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: isOverdue ? Colors.red : priorityColor.withOpacity(0.3), width: isOverdue ? 2 : 1),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Theme.of(context).colorScheme.surface, Theme.of(context).colorScheme.surface.withOpacity(0.8)],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(isTablet ? 12.w : 8.w),
                    decoration: BoxDecoration(color: priorityColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12.r)),
                    child: Icon(typeIcon, color: priorityColor, size: isTablet ? 24.w : 20.w),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                reminder.title,
                                style: TextStyle(
                                  fontSize: isTablet ? 18.sp : 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.onSurface,
                                  decoration: reminder.isCompleted ? TextDecoration.lineThrough : null,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (isOverdue)
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12.r)),
                                child: Text('เลยกำหนด', style: TextStyle(color: Colors.white, fontSize: isTablet ? 10.sp : 8.sp, fontWeight: FontWeight.bold)),
                              ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          _getPriorityText(reminder.priority),
                          style: TextStyle(fontSize: isTablet ? 12.sp : 10.sp, color: priorityColor, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  // Action Buttons
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => _editReminder(reminder),
                        icon: Icon(Icons.edit, size: isTablet ? 20.w : 16.w, color: Theme.of(context).colorScheme.primary),
                      ),
                      IconButton(
                        onPressed: () => _toggleComplete(reminder),
                        icon: Icon(
                          reminder.isCompleted ? Icons.undo : Icons.check_circle,
                          size: isTablet ? 20.w : 16.w,
                          color: reminder.isCompleted ? Colors.orange : Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              // Description
              Text(
                reminder.description,
                style: TextStyle(fontSize: isTablet ? 14.sp : 12.sp, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7), height: 1.4),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 12.h),
              // Footer Info
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: [
                  _buildInfoChip(Icons.access_time, _formatDateTime(reminder.dueDate), isOverdue ? Colors.red : Colors.blue, isTablet),
                  if (reminder.clientName != null) _buildInfoChip(Icons.person, reminder.clientName!, Colors.green, isTablet),
                  if (reminder.caseNumber != null) _buildInfoChip(Icons.folder, reminder.caseNumber!, Colors.purple, isTablet),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color, bool isTablet) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 12.w : 8.w, vertical: isTablet ? 6.h : 4.h),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12.r)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: isTablet ? 14.w : 12.w, color: color),
          SizedBox(width: 4.w),
          Flexible(
            child: Text(
              text,
              style: TextStyle(fontSize: isTablet ? 12.sp : 10.sp, color: color, fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(ReminderPriority priority) {
    switch (priority) {
      case ReminderPriority.urgent:
        return Colors.red;
      case ReminderPriority.high:
        return Colors.orange;
      case ReminderPriority.medium:
        return Colors.blue;
      case ReminderPriority.low:
        return Colors.green;
    }
  }

  String _getPriorityText(ReminderPriority priority) {
    switch (priority) {
      case ReminderPriority.urgent:
        return 'ด่วนมาก';
      case ReminderPriority.high:
        return 'สำคัญ';
      case ReminderPriority.medium:
        return 'ปานกลาง';
      case ReminderPriority.low:
        return 'ไม่เร่งด่วน';
    }
  }

  IconData _getTypeIcon(ReminderType type) {
    switch (type) {
      case ReminderType.court:
        return Icons.gavel;
      case ReminderType.deadline:
        return Icons.schedule;
      case ReminderType.meeting:
        return Icons.meeting_room;
      case ReminderType.review:
        return Icons.rate_review;
      case ReminderType.payment:
        return Icons.payment;
      case ReminderType.renewal:
        return Icons.refresh;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now);

    if (difference.inDays > 0) {
      return '${difference.inDays} วัน';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ชั่วโมง';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} นาที';
    } else if (difference.inDays < 0) {
      return 'เลยกำหนด ${(-difference.inDays)} วัน';
    } else {
      return 'ตอนนี้';
    }
  }

  void _toggleComplete(Reminder reminder) {
    setState(() {
      final index = _reminders.indexWhere((r) => r.id == reminder.id);
      if (index != -1) {
        // In a real app, you would update this through a state management solution
        // For now, we'll just show a snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(reminder.isCompleted ? 'ยกเลิกการทำเสร็จ: ${reminder.title}' : 'ทำเสร็จแล้ว: ${reminder.title}'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
          ),
        );
      }
    });
  }

  void _editReminder(Reminder reminder) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('แก้ไขการแจ้งเตือน: ${reminder.title}'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      ),
    );
  }
}
