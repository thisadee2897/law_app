import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:law_app/features/home/providers/apis/data_api.dart';
import 'package:law_app/models/form_p_d_f_model.dart';
import 'package:law_app/models/h_d_data_app_model.dart';

class DataAppNotifier extends StateNotifier<AsyncValue<List<HDDataAppModel>>> {
  DataAppNotifier(this.ref) : super(const AsyncValue.loading());
  final Ref ref;

  Future<void> get() async {
    state = const AsyncValue.loading();
    // await Future.delayed(const Duration(seconds: 2));
    state = await AsyncValue.guard(() async {
      List<HDDataAppModel> response = await ref.read(apiDataApp).get();
      return response;
    });
  }
}

final dataAppProvider = StateNotifierProvider<DataAppNotifier, AsyncValue<List<HDDataAppModel>>>((ref) => DataAppNotifier(ref));

final searchQueryProvider = StateProvider<String>((ref) => '');
final selectedCategoryProvider = StateProvider<String>((ref) => '0');
final filteredProvider = FutureProvider.autoDispose<List<FormPDFModel>>((ref) async {
  final searchQuery = ref.watch(searchQueryProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);
  final data = ref.watch(dataAppProvider).value ?? [];
  List<FormPDFModel> filteredDocuments = [];
  for (var item in data) {
    filteredDocuments.addAll(item.form ?? []);
  }
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
    count += item.form?.length ?? 0;
  }
  return count;
});

final categoriesProvider = Provider<List<HDDataAppModel>>((ref) {
  final data = ref.watch(dataAppProvider).value ?? [];
  return data;
});
