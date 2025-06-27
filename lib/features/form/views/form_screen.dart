import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:law_app/core/router/app_router.dart';
import 'package:law_app/core/router/route_config.dart';
import 'package:law_app/features/form/providers/pdf_controller.dart';
import 'package:path_provider/path_provider.dart';

class FormScreen extends ConsumerStatefulWidget {
  const FormScreen({super.key});

  @override
  ConsumerState<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends ConsumerState<FormScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All';

  final List<String> _categories = ['All', 'Contract', 'Legal Document', 'Court Filing', 'Agreement', 'Policy', 'Regulation'];

  final List<Map<String, dynamic>> _pdfDocuments = List.generate(50, (index) {
    final categories = ['Contract', 'Legal Document', 'Court Filing', 'Agreement', 'Policy', 'Regulation'];
    final titles = [
      'สัญญาจ้างงาน',
      'หนังสือมอบอำนาจ',
      'ใบคำร้องต่อศาล',
      'สัญญาเช่าอสังหาริมทรัพย์',
      'นโยบายความเป็นส่วนตัว',
      'ข้อบังคับบริษัท',
      'สัญญาซื้อขาย',
      'หนังสือรับรอง',
      'คำขอใบอนุญาต',
      'แบบฟอร์มภาษี',
    ];

    return {
      'id': index,
      'title': '${titles[index % titles.length]} ${index + 1}',
      'category': categories[index % categories.length],
      'description': 'เอกสารสำคัญทางกฎหมายที่จำเป็นสำหรับการดำเนินงาน',
      'size': '${(index % 10 + 1) * 0.5}MB',
      'date': DateTime.now().subtract(Duration(days: index)),
      'isNew': index < 5,
      'isFavorite': index % 7 == 0,
      'downloadCount': index * 10 + (index % 50),
    };
  });

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredDocuments {
    return _pdfDocuments.where((doc) {
      final matchesSearch =
          _searchQuery.isEmpty ||
          doc['title'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
          doc['description'].toString().toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesCategory = _selectedCategory == 'All' || doc['category'] == _selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Modern App Bar with Gradient
          SliverAppBar(
            expandedHeight: 260.h,
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
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.primary.withOpacity(0.8),
                      Theme.of(context).colorScheme.secondary,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 10.h),
                        // Header with Stats
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('เอกสารกฎหมาย', style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold, color: Colors.white)),
                                  SizedBox(height: 4.h),
                                  Text('จัดการเอกสาร PDF ทางกฎหมาย', style: TextStyle(fontSize: 14.sp, color: Colors.white.withOpacity(0.9))),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(12.w),
                              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(16.r)),
                              child: Icon(Icons.folder_special, size: 32.w, color: Colors.white),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        // Stats Cards
                        Row(
                          children: [
                            Expanded(child: _buildStatsCard('เอกสารทั้งหมด', '${_pdfDocuments.length}', Icons.description, Colors.white.withOpacity(0.2))),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: _buildStatsCard(
                                'เอกสารใหม่',
                                '${_pdfDocuments.where((doc) => doc['isNew']).length}',
                                Icons.fiber_new,
                                Colors.white.withOpacity(0.2),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        // Search Bar
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2))],
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'ค้นหาเอกสาร...',
                              prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
                              suffixIcon:
                                  _searchQuery.isNotEmpty
                                      ? IconButton(
                                        icon: const Icon(Icons.clear),
                                        onPressed: () {
                                          _searchController.clear();
                                          setState(() {
                                            _searchQuery = '';
                                          });
                                        },
                                      )
                                      : null,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Category Filter
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: SizedBox(
                height: 50.h,
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  separatorBuilder: (context, index) => SizedBox(width: 8.w),
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final isSelected = _selectedCategory == category;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                        decoration: BoxDecoration(
                          color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(25.r),
                          border: Border.all(color: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent),
                        ),
                        child: Text(
                          category,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // Documents List
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            sliver:
                _filteredDocuments.isEmpty
                    ? SliverToBoxAdapter(child: _buildEmptyState())
                    : SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final document = _filteredDocuments[index];
                        return _buildDocumentCard(document, index);
                      }, childCount: _filteredDocuments.length),
                    ),
          ),
          // Bottom Padding
          SliverToBoxAdapter(child: SizedBox(height: 100.h)),
        ],
      ),
    );
  }

  Widget _buildStatsCard(String title, String value, IconData icon, Color backgroundColor) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(12.r)),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20.w),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(value, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.white)),
                Text(title, style: TextStyle(fontSize: 10.sp, color: Colors.white.withOpacity(0.8))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(40.w),
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

  Widget _buildDocumentCard(Map<String, dynamic> document, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(20.r),
        child: InkWell(
          onTap: () => _handleDocumentTap(document),
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
                      tag: 'pdf_${document['id']}',
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
                    SizedBox(width: 16.w),
                    // Document Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  document['title'],
                                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (document['isNew'])
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                  decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(12.r)),
                                  child: Text('ใหม่', style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.bold)),
                                ),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            document['category'],
                            style: TextStyle(fontSize: 12.sp, color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    // Favorite Button
                    IconButton(
                      onPressed: () {
                        // Toggle favorite logic here
                      },
                      icon: Icon(
                        document['isFavorite'] ? Icons.favorite : Icons.favorite_border,
                        color: document['isFavorite'] ? Colors.red : Colors.grey,
                        size: 20.w,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                // Description
                Text(
                  document['description'],
                  style: TextStyle(fontSize: 14.sp, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7), height: 1.4),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 16.h),
                // Footer Row
                Row(
                  children: [
                    _buildInfoChip(Icons.file_download, '${document['downloadCount']}', Colors.blue),
                    SizedBox(width: 8.w),
                    _buildInfoChip(Icons.data_usage, document['size'], Colors.orange),
                    SizedBox(width: 8.w),
                    _buildInfoChip(Icons.access_time, _formatDate(document['date']), Colors.green),
                    const Spacer(),
                    // Action Buttons
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => _shareDocument(document),
                          icon: Icon(Icons.share, size: 20.w),
                          style: IconButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primaryContainer),
                        ),
                        SizedBox(width: 8.w),
                        IconButton(
                          onPressed: () => _downloadDocument(document),
                          icon: Icon(Icons.download, size: 20.w),
                          style: IconButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.secondaryContainer),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8.r)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.w, color: color),
          SizedBox(width: 4.w),
          Text(text, style: TextStyle(fontSize: 10.sp, color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date).inDays;

    if (diff == 0) return 'วันนี้';
    if (diff == 1) return 'เมื่อวาน';
    if (diff < 7) return '$diff วันที่แล้ว';
    if (diff < 30) return '${(diff / 7).floor()} สัปดาห์ที่แล้ว';
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _handleDocumentTap(Map<String, dynamic> document) async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => Center(
            child: Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(12.r)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [CircularProgressIndicator(strokeWidth: 3.w), SizedBox(height: 16.h), Text('กำลังเปิดเอกสาร...', style: TextStyle(fontSize: 14.sp))],
              ),
            ),
          ),
    );

    try {
      final byteData = await rootBundle.load('assets/pdfs/test.pdf');
      final bytes = byteData.buffer.asUint8List();

      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/temp.pdf');
      await file.writeAsBytes(bytes);

      ref.read(pdfTempFilePathProvider.notifier).state = file.path;

      // Close loading dialog
      if (mounted) Navigator.of(context).pop();

      // Navigate to PDF viewer
      ref.goSubPath(Routes.pdf);
    } catch (e) {
      // Close loading dialog
      if (mounted) Navigator.of(context).pop();

      // Show error dialog
      _showErrorDialog('ไม่สามารถเปิดเอกสารได้');
    }
  }

  void _shareDocument(Map<String, dynamic> document) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('แชร์เอกสาร: ${document['title']}'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      ),
    );
  }

  void _downloadDocument(Map<String, dynamic> document) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('ดาวน์โหลด: ${document['title']}'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        action: SnackBarAction(label: 'ดู', onPressed: () => _handleDocumentTap(document)),
      ),
    );
  }

  void _showErrorDialog(String message) {
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
}
