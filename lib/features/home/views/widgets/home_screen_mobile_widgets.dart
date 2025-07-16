import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:law_app/components/document_card_widget.dart';
import 'package:law_app/components/export.dart';
import 'package:law_app/core/database/models/form_model.dart';
import 'package:law_app/core/database/objectbox_database.dart';
import 'package:law_app/core/utils/extension/async_value_sliver_extension.dart';
import 'package:law_app/features/home/views/widgets/app_bar_document.dart';
import 'package:law_app/shared/widgets/common_widgets.dart';
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
                  stream: database.formBoxManager.streamBySelectCate(ref.watch(selectedCategoryProvider), ref.watch(searchQueryProvider)),
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
                        return DocumentCardWidget(form);
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
}
