import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:law_app/components/export.dart';
import 'package:law_app/core/database/models/form_model.dart';
import 'package:law_app/core/database/objectbox_database.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

// ignore: must_be_immutable
class DocumentCardWidget extends ConsumerWidget {
  final FormModel document;
  final bool showFavoriteButton;
  // void Function(FormModel) onPressed;
  const DocumentCardWidget(this.document, {super.key, this.showFavoriteButton = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final database = ObjectBoxDatabase.instance;
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: InkWell(
        onTap: () {
          // _handleDocumentTap(document)
        },
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
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
                  // PDF Icon with animation
                  Hero(
                    tag: 'pdf_${document.formId}',
                    child: Container(
                      width: 50.w,
                      height: 50.w,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [Colors.red.shade400, Colors.red.shade600]),
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [BoxShadow(color: Colors.red.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2))],
                      ),
                      child: Icon(Icons.picture_as_pdf, color: Colors.white, size: 24.w),
                    ),
                  ),
                  SizedBox(width: 16),
                  // Document Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                document.formName,
                                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          database.categoryFormBoxManager.getAll().firstWhere((category) => category.categoryId == document.categoryId).categoryFormName,
                          style: TextStyle(fontSize: 12.sp, color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  // Favorite Button
                  if(showFavoriteButton)
                  IconButton(
                    onPressed: () {
                      final database = ObjectBoxDatabase.instance;
                      database.formBoxManager.toggleFavorite(document);
                    },
                    icon: Icon(
                      document.favorite == true ? Icons.favorite : Icons.favorite_border,
                      color: document.favorite == true ? Colors.red : Colors.grey,
                      size: 20.w,
                    ),
                  ),
                ],
              ),
              // Description
              Text(
                document.formName,
                style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7), height: 1.4),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              // Footer Row
              Row(
                children: [
                  // _buildInfoChip(Icons.access_time, _formatDate(document.formUpdatedAt!.toLocal()), Colors.green),
                  const Spacer(),
                  // Action Buttons
                  Row(
                    spacing: 8.w,
                    children: [
                      // open document
                      ElevatedButton(
                        onPressed: () async {
                          if (document.pdfPath.isEmpty) {
                            _showErrorDialog('ไม่พบไฟล์ PDF สำหรับเอกสารนี้', context);
                            return;
                          } else {
                            try {
                              final byteData = await rootBundle.load(document.pdfPath);
                              final bytes = byteData.buffer.asUint8List();
                              final dir = await getTemporaryDirectory();
                              final fileName = "SafeDoc_app_file_${document.code}_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}";
                              print('File name: $fileName');
                              final file = File('${dir.path}/$fileName.pdf');
                              if (await file.exists()) {
                                await file.delete();
                              }
                              await file.writeAsBytes(bytes);
                              await OpenFile.open(file.path);
                            } catch (e) {
                              // Show error dialog
                              if (context.mounted) {
                                _showErrorDialog('ไม่สามารถเปิดเอกสารได้', context);
                              }
                            }
                          }
                        },
                        child: Text('เปิด', style: TextStyle(fontSize: 12.sp)),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(String message, context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
            title: Row(children: [Icon(Icons.error_outline, color: Colors.red, size: 24.w), SizedBox(width: 8.w), const Text('เกิดข้อผิดพลาด')]),
            content: Text(message),
            actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('ตกลง'))],
          ),
    );
  }

  // String _formatDate(DateTime date) {
  //   final now = DateTime.now();
  //   final diff = now.difference(date).inDays;
  //   if (diff == 0) return 'วันนี้';
  //   if (diff == 1) return 'เมื่อวาน';
  //   if (diff < 7) return '$diff วันที่แล้ว';
  //   if (diff < 30) return '${(diff / 7).floor()} สัปดาห์ที่แล้ว';
  //   return '${date.day}/${date.month}/${date.year}';
  // }

  // Widget _buildInfoChip(IconData icon, String text, Color color) {
  //   return Container(
  //     padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
  //     decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8.r)),
  //     child: Row(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Icon(icon, size: 12.w, color: color),
  //         SizedBox(width: 4.w),
  //         Text(text, style: TextStyle(fontSize: 10.sp, color: color, fontWeight: FontWeight.w600)),
  //       ],
  //     ),
  //   );
  // }
}
