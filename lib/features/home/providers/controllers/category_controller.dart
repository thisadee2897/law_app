import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:law_app/core/database/models/category_form_model.dart';
import 'package:law_app/core/database/objectbox_database.dart';
import 'package:law_app/models/form_p_d_f_model.dart';

class DataAppNotifier extends StateNotifier<AsyncValue<List<CategoryFormModel>>> {
  DataAppNotifier(this.ref) : super(const AsyncValue.loading());
  final Ref ref;

  Future<void> get() async {
    state = const AsyncValue.loading();
    // await Future.delayed(const Duration(seconds: 2));
    state = await AsyncValue.guard(() async {
          final database = ObjectBoxDatabase.instance;
      List<CategoryFormModel> response = database.categoryFormBoxManager.getAll();
      print('DataAppNotifier get response: ${response.length} categories');
      return response;
    });
  }
}

final dataAppProvider = StateNotifierProvider<DataAppNotifier, AsyncValue<List<CategoryFormModel>>>((ref) => DataAppNotifier(ref));

final searchQueryProvider = StateProvider<String>((ref) => '');
final selectedCategoryProvider = StateProvider<String>((ref) => '0');
final filteredProvider = FutureProvider.autoDispose<List<FormPDFModel>>((ref) async {
  final searchQuery = ref.watch(searchQueryProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);
  // final data = ref.watch(dataAppProvider).value ?? [];
  List<FormPDFModel> filteredDocuments = [];
  // for (var item in data) {
  //   // filteredDocuments.addAll(item.form ?? []);
  // }
  return filteredDocuments.where((doc) {
    final matchesSearch = searchQuery.isEmpty || doc.formName!.toLowerCase().contains(searchQuery.toLowerCase());
    final matchesCategory = selectedCategory == '0' || doc.hdId == selectedCategory;
    return matchesSearch && matchesCategory;
  }).toList();
});
final formpdfCountProvider = Provider<int>((ref) {
  final data = ref.watch(dataAppProvider).value ?? [];
  int count = 0;
  for (var item in data) {
    count += item.form.length;
  }
  return count;
});

final categoriesProvider = Provider<List<CategoryFormModel>>((ref) {
  final data = ref.watch(dataAppProvider).value ?? [];
  return data;
});
