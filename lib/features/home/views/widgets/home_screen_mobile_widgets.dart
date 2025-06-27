import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:law_app/components/document_card_widget.dart';
import 'package:law_app/components/empty_state_widget.dart';
import 'package:law_app/components/export.dart';
import 'package:law_app/core/utils/extension/async_value_sliver_extension.dart';
import 'package:law_app/features/home/views/widgets/app_bar_document.dart';
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
                            return DocumentCardWidget(document);
                          }, childCount: filteredDocuments.length),
                        ),
              );
            },
          ),
        ],
      ),
    );
  }
}
