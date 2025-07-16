import 'package:flutter/material.dart';
import 'package:law_app/components/document_card_widget.dart';
import 'package:law_app/components/export.dart';
import 'package:law_app/core/database/models/form_model.dart';
import 'package:law_app/core/database/objectbox_database.dart';
import 'package:law_app/features/home/providers/controllers/category_controller.dart';

final favoriteFormsProvider = Provider.autoDispose<List<FormModel>>((ref) {
  final database = ObjectBoxDatabase.instance;
  return database.formBoxManager.getAll().where((form) => form.favorite).toList();
});

class AppBarDocument extends ConsumerWidget {
  const AppBarDocument({super.key, required TextEditingController searchController}) : _searchController = searchController;

  final TextEditingController _searchController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverAppBar(
      expandedHeight: 160, // Increased from 158
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
              colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.primary.withOpacity(0.8), Theme.of(context).colorScheme.secondary],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header with Stats
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('เอกสารกฎหมาย', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                            SizedBox(height: 4),
                            Text('จัดการเอกสาร PDF ทางกฎหมาย', style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.9))),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // showModalBottomSheet list data form feverite
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return SizedBox(
                                height: MediaQuery.of(context).size.height * 0.6,
                                child: Column(
                                  children: [
                                    Text('Favorite Forms', style: TextStyle(fontSize: 24)),
                                    Expanded(
                                      child: Consumer(
                                        builder: (context, ref, child) {
                                          final favoriteForms = ref.watch(favoriteFormsProvider);
                                          return ListView.builder(
                                            itemCount: favoriteForms.length,
                                            itemBuilder: (context, index) {
                                              final form = favoriteForms[index];
                                              return DocumentCardWidget(showFavoriteButton: false, form);
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(16)),
                          child: Icon(Icons.folder_special, size: 32, color: Colors.yellow),
                        ),
                      ),
                    ],
                  ),
                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2))],
                    ),
                    child: TextField(
                      onTapOutside: (event) {
                        FocusScope.of(context).unfocus();
                      },
                      controller: _searchController,
                      onChanged: (value) {
                        ref.read(searchQueryProvider.notifier).state = value;
                      },
                      decoration: InputDecoration(
                        hintText: 'ค้นหาเอกสาร...',
                        prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
                        suffixIcon:
                            ref.watch(searchQueryProvider).isNotEmpty
                                ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    ref.read(searchQueryProvider.notifier).state = '';
                                    FocusScope.of(context).unfocus();
                                  },
                                )
                                : null,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
