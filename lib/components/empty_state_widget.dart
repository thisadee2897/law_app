import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyStateDocumentWidget extends StatelessWidget {
  const EmptyStateDocumentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(Icons.search_off, size: 80.w, color: Theme.of(context).colorScheme.outline),
          SizedBox(height: 16.h),
          Text('ไม่พบเอกสารที่ค้นหา', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
          SizedBox(height: 8.h),
          Text('ลองเปลี่ยนคำค้นหาหรือหมวดหมู่', style: TextStyle(fontSize: 14.sp, color: Theme.of(context).colorScheme.outline)),
        ],
      ),
    );
  }
}
