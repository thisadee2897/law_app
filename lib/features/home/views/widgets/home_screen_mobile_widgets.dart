import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:law_app/components/document_card_widget.dart';
import 'package:law_app/components/export.dart';
import 'package:law_app/core/database/models/form_model.dart';
import 'package:law_app/core/database/objectbox_database.dart';
import 'package:law_app/core/utils/extension/async_value_sliver_extension.dart';
import 'package:law_app/features/home/views/widgets/app_bar_document.dart';
import 'package:law_app/shared/widgets/common_widgets.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import '../../providers/controllers/category_controller.dart';
import 'tab_document_category.dart';

class HomeScreenMobileWidgets extends ConsumerStatefulWidget {
  const HomeScreenMobileWidgets({super.key});

  @override
  ConsumerState<HomeScreenMobileWidgets> createState() => _HomeScreenMobileWidgetsState();
}

class _HomeScreenMobileWidgetsState extends ConsumerState<HomeScreenMobileWidgets> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final database = ObjectBoxDatabase.instance;
    final statedata = ref.watch(dataAppProvider);
    // final filteredDocuments = ref.watch(filteredProvider).value ?? [];
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          AppBarDocument(searchController: _searchController),
          TabDocumentCategory(searchController: _searchController),
          statedata.appSliverWhen(
            dataBuilder: (data) {
              return SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                sliver: StreamBuilder(
                  stream: database.formBoxManager.streamBySelectCate(ref.watch(selectedCategoryProvider),ref.watch(searchQueryProvider)),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return SliverToBoxAdapter(
                        child: EmptyStateWidget(
                          icon: Icons.error_outline,
                          title: 'เกิดข้อผิดพลาด',
                          message: 'ไม่สามารถโหลดข้อมูลได้',
                          // onRetry: () => _showErrorDialog(snapshot.error.toString()),
                        ),
                      );
                    }
                    final forms = snapshot.data ?? [];
                    if (forms.isEmpty) {
                      return SliverToBoxAdapter(
                        child: EmptyStateWidget(icon: Icons.folder_open, title: 'ไม่มีเอกสาร', message: 'ไม่พบเอกสารที่ตรงกับการค้นหา'),
                      );
                    }
                    return SliverList.builder(
                      itemCount: forms.length,
                      itemBuilder: (context, index) {
                        FormModel form = forms[index];
                        return DocumentCardWidget(
                          form,
                          onPressed: (item) async {
                            if (item.pdfPath.isEmpty) {
                              _showErrorDialog('ไม่พบไฟล์ PDF สำหรับเอกสารนี้');
                              return;
                            } else {
                              try {
                                final byteData = await rootBundle.load(item.pdfPath);
                                final bytes = byteData.buffer.asUint8List();
                                final dir = await getTemporaryDirectory();
                                final fileName = "SafeDoc_app_file_${item.code}_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}";
                                print('File name: $fileName');
                                final file = File('${dir.path}/$fileName.pdf');
                                if (await file.exists()) {
                                  await file.delete();
                                }
                                await file.writeAsBytes(bytes);
                                await OpenFile.open(file.path);
                              } catch (e) {
                                // Show error dialog
                                _showErrorDialog('ไม่สามารถเปิดเอกสารได้');
                              }
                            }
                          },
                        );
                      },
                    );
                  },
                ),
              );
            },
          ),
        ],
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
