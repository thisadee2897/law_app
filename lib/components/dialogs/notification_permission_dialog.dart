import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:law_app/core/utils/services/notification_service.dart';

class NotificationPermissionDialog extends ConsumerWidget {
  const NotificationPermissionDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.notifications_active, color: Theme.of(context).primaryColor),
          const SizedBox(width: 8),
          const Text('ขออนุญาตการแจ้งเตือน'),
        ],
      ),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'แอปนี้ต้องการขออนุญาตส่งการแจ้งเตือนเพื่อ:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.schedule, size: 20, color: Colors.green),
              SizedBox(width: 8),
              Expanded(child: Text('แจ้งเตือนเมื่อถึงเวลาที่กำหนด')),
            ],
          ),
          SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.repeat, size: 20, color: Colors.blue),
              SizedBox(width: 8),
              Expanded(child: Text('แจ้งเตือนตามรอบที่ตั้งไว้')),
            ],
          ),
          SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.important_devices, size: 20, color: Colors.orange),
              SizedBox(width: 8),
              Expanded(child: Text('ทำงานแม้ว่าแอปจะถูกปิด')),
            ],
          ),
          SizedBox(height: 16),
          Text(
            'หากไม่อนุญาต แอปจะไม่สามารถส่งการแจ้งเตือนได้',
            style: TextStyle(
              color: Colors.red,
              fontSize: 12,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text('ไม่อนุญาต'),
        ),
        ElevatedButton(
          onPressed: () async {
            Navigator.of(context).pop(true);
          },
          child: const Text('อนุญาต'),
        ),
      ],
    );
  }

  /// Show the permission dialog and handle the result
  static Future<bool> show(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const NotificationPermissionDialog(),
    );
    
    if (result == true) {
      // User agreed, request permission
      return await NotificationService.requestNotificationPermissions();
    }
    
    return false;
  }
}
