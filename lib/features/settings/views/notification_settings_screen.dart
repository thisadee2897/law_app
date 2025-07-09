import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:law_app/core/utils/services/notification_service.dart';
import 'package:law_app/core/utils/helpers/battery_optimization_helper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class NotificationSettingsScreen extends ConsumerStatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  ConsumerState<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends ConsumerState<NotificationSettingsScreen> {
  bool _notificationsEnabled = false;
  bool _batteryOptimizationEnabled = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkNotificationStatus();
  }

  Future<void> _checkNotificationStatus() async {
    setState(() => _isLoading = true);
    try {
      final enabled = await NotificationService.areNotificationsEnabled();
      bool batteryOptEnabled = false;
      
      if (Platform.isAndroid) {
        batteryOptEnabled = await BatteryOptimizationHelper.isBatteryOptimizationEnabled();
      }
      
      setState(() {
        _notificationsEnabled = enabled;
        _batteryOptimizationEnabled = batteryOptEnabled;
        _isLoading = false;
      });
    } catch (e) {
      print('Error checking notification status: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _requestNotificationPermission() async {
    try {
      // Request notification permission
      final granted = await NotificationService.requestNotificationPermissions();
      
      if (!granted) {
        // If permission is denied, show dialog to go to settings
        if (mounted) {
          _showPermissionDialog();
        }
      } else {
        // Test notification
        await NotificationService.showInstantNotification();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('การแจ้งเตือนถูกเปิดใช้งานแล้ว! คุณควรเห็นการแจ้งเตือนทดสอบ')),
          );
        }
      }
      
      // Refresh status
      await _checkNotificationStatus();
    } catch (e) {
      print('Error requesting notification permission: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
        );
      }
    }
  }

  Future<void> _requestBatteryOptimizationDisable() async {
    try {
      if (Platform.isAndroid) {
        final success = await BatteryOptimizationHelper.requestDisableBatteryOptimization();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(success 
                ? 'เปิดการตั้งค่า Battery Optimization แล้ว กรุณาปิดการปรับแต่งแบตเตอรี่สำหรับแอปนี้'
                : 'ไม่สามารถเปิดการตั้งค่าได้'),
            ),
          );
        }
        // Refresh status after a delay
        await Future.delayed(const Duration(seconds: 2));
        await _checkNotificationStatus();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
        );
      }
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ต้องการอนุญาตการแจ้งเตือน'),
          content: const Text(
            'กรุณาไปที่การตั้งค่าของแอปเพื่อเปิดใช้งานการแจ้งเตือน\n\n'
            'การตั้งค่า > แอป > Law App > การแจ้งเตือน',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('ปิด'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
              child: const Text('ไปที่การตั้งค่า'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _testNotification() async {
    try {
      await NotificationService.showInstantNotification();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ส่งการแจ้งเตือนทดสอบแล้ว')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เกิดข้อผิดพลาดในการส่งการแจ้งเตือน: $e')),
        );
      }
    }
  }

  Future<void> _showPendingNotifications() async {
    try {
      final pending = await NotificationService.getPendingNotifications();
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('การแจ้งเตือนที่รอดำเนินการ'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: pending.length,
                itemBuilder: (context, index) {
                  final notification = pending[index];
                  return ListTile(
                    title: Text(notification.title ?? 'ไม่มีชื่อ'),
                    subtitle: Text(notification.body ?? 'ไม่มีรายละเอียด'),
                    trailing: Text('ID: ${notification.id}'),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('ปิด'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เกิดข้อผิดพลาดในการดูการแจ้งเตือนที่รอดำเนินการ: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('การตั้งค่าการแจ้งเตือน'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Notification Status Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                _notificationsEnabled 
                                    ? Icons.notifications_active 
                                    : Icons.notifications_off,
                                color: _notificationsEnabled 
                                    ? Colors.green 
                                    : Colors.red,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'สถานะการแจ้งเตือน',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _notificationsEnabled 
                                ? 'การแจ้งเตือนถูกเปิดใช้งาน' 
                                : 'การแจ้งเตือนถูกปิดใช้งาน',
                            style: TextStyle(
                              color: _notificationsEnabled 
                                  ? Colors.green 
                                  : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (!_notificationsEnabled) ...[
                            const SizedBox(height: 8),
                            const Text(
                              'คุณจะไม่ได้รับการแจ้งเตือนจากแอปนี้ '
                              'กรุณาเปิดใช้งานการแจ้งเตือนเพื่อให้แอปทำงานได้อย่างสมบูรณ์',
                              style: TextStyle(color: Colors.orange),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
              
                  // Battery Optimization Status Card (Android only)
                  if (Platform.isAndroid) ...[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  _batteryOptimizationEnabled 
                                      ? Icons.battery_alert 
                                      : Icons.battery_full,
                                  color: _batteryOptimizationEnabled 
                                      ? Colors.orange 
                                      : Colors.green,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'การปรับแต่งแบตเตอรี่',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _batteryOptimizationEnabled 
                                  ? 'แอปถูกปรับแต่งแบตเตอรี่ (อาจส่งผลต่อการแจ้งเตือน)' 
                                  : 'แอปไม่ถูกปรับแต่งแบตเตอรี่',
                              style: TextStyle(
                                color: _batteryOptimizationEnabled 
                                    ? Colors.orange 
                                    : Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (_batteryOptimizationEnabled) ...[
                              const SizedBox(height: 8),
                              const Text(
                                'การปรับแต่งแบตเตอรี่อาจทำให้การแจ้งเตือนไม่ทำงาน '
                                'กรุณาปิดการปรับแต่งแบตเตอรี่สำหรับแอปนี้',
                                style: TextStyle(color: Colors.orange),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  
                  // Action buttons
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _requestNotificationPermission,
                      icon: const Icon(Icons.notification_add),
                      label: const Text('ขออนุญาตการแจ้งเตือน'),
                    ),
                  ),
                  const SizedBox(height: 8),
              
                  if (Platform.isAndroid && _batteryOptimizationEnabled) ...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _requestBatteryOptimizationDisable,
                        icon: const Icon(Icons.battery_saver),
                        label: const Text('ปิดการปรับแต่งแบตเตอรี่'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _testNotification,
                      icon: const Icon(Icons.send),
                      label: const Text('ทดสอบการแจ้งเตือน'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _showPendingNotifications,
                      icon: const Icon(Icons.list),
                      label: const Text('ดูการแจ้งเตือนที่รอดำเนินการ'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _checkNotificationStatus,
                      icon: const Icon(Icons.refresh),
                      label: const Text('รีเฟรชสถานะ'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Information card
                  Card(
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.info, color: Colors.blue.shade700),
                              const SizedBox(width: 8),
                              Text(
                                'ข้อมูลเพิ่มเติม',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '• การแจ้งเตือนจะทำงานแม้ว่าแอปจะถูกปิด\n'
                            '• หากแอปถูกฆ่าโดยระบบ การแจ้งเตือนอาจไม่ทำงาน\n'
                            '• สำหรับ Android: ตรวจสอบการตั้งค่า Battery Optimization\n'
                            '• สำหรับ iOS: ตรวจสอบการตั้งค่าการแจ้งเตือนในแอป\n'
                            '• หากการแจ้งเตือนยังไม่ทำงาน ลองรีสตาร์ทแอป',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
