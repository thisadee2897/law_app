import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:law_app/components/export.dart';
import 'package:law_app/features/home/providers/controllers/category_controller.dart';

class TabDocumentCategory extends ConsumerWidget {
  const TabDocumentCategory({super.key ,required TextEditingController searchController})
    : _searchController = searchController;

  final TextEditingController _searchController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statedata = ref.watch(dataAppProvider);
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: SizedBox(
          height: 50,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            scrollDirection: Axis.horizontal,
            itemCount: statedata.value!.length,
            separatorBuilder: (context, index) => SizedBox(width: 8.w),
            itemBuilder: (context, index) {
              final category = statedata.value![index];
              final isSelected = ref.watch(selectedCategoryProvider) == category.hdId;
              return GestureDetector(
                onTap: () {
                  //Unfocus the keyboard when a category is selected
                  FocusScope.of(context).unfocus();
                  ref.read(selectedCategoryProvider.notifier).state = isSelected ? '0' : category.hdId!;
                  _searchController.clear();
                  ref.read(searchQueryProvider.notifier).state = '';
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
                    category.hdName ?? 'ไม่มีหมวดหมู่',
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
    );
  }
}
