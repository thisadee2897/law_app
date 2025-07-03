import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:law_app/components/document_card_widget.dart';
import 'package:law_app/components/empty_state_widget.dart';
import 'package:law_app/components/export.dart';
import 'package:law_app/core/router/app_router.dart';
import 'package:law_app/core/router/route_config.dart';
import 'package:law_app/core/utils/extension/async_value_sliver_extension.dart';
import 'package:law_app/features/form/providers/pdf_controller.dart';
import 'package:law_app/features/home/views/widgets/app_bar_document.dart';
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
    final statedata = ref.watch(dataAppProvider);
    final filteredDocuments = ref.watch(filteredProvider).value ?? [];

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
                sliver:
                    filteredDocuments.isEmpty
                        ? SliverToBoxAdapter(child: EmptyStateDocumentWidget())
                        : SliverList(
                          delegate: SliverChildBuilderDelegate((context, index) {
                            final document = filteredDocuments[index];
                            return DocumentCardWidget(
                              document,
                              onPressed: (item) async {
                                if (item.formPdf == null || item.formPdf!.isEmpty) {
                                  _showErrorDialog('ไม่พบไฟล์ PDF สำหรับเอกสารนี้');
                                  return;
                                } else {
                                  try {
                                    final byteData = await rootBundle.load(item.formPdf ?? '');
                                    final bytes = byteData.buffer.asUint8List();
                                    final dir = await getTemporaryDirectory();
                                    final file = File('${dir.path}/temp.pdf');
                                    await file.writeAsBytes(bytes);
                                    ref.read(pdfTempFilePathProvider.notifier).state = file.path;
                                    ref.goSubPath(Routes.pdf);
                                  } catch (e) {
                                    // Show error dialog
                                    _showErrorDialog('ไม่สามารถเปิดเอกสารได้');
                                  }
                                }
                              },
                            );
                          }, childCount: filteredDocuments.length),
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
