import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:law_app/core/database/models/category_form_model.dart';
import 'package:law_app/core/database/objectbox_database.dart';

class DataAppNotifier extends StateNotifier<AsyncValue<List<CategoryFormModel>>> {
  DataAppNotifier(this.ref) : super(const AsyncValue.loading());
  final Ref ref;

  Future<void> get() async {
    state = const AsyncValue.loading();
    // await Future.delayed(const Duration(seconds: 2));
    state = await AsyncValue.guard(() async {
          final database = ObjectBoxDatabase.instance;
      List<CategoryFormModel> response = database.categoryFormBoxManager.getAll().where((e) => e.categoryFormActive).toList();
      response.sort((a, b) => a.categoryId.compareTo(b.categoryId));
      print('DataAppNotifier get response: ${response.length} categories');
      return response;
    });
  }
}

final dataAppProvider = StateNotifierProvider<DataAppNotifier, AsyncValue<List<CategoryFormModel>>>((ref) => DataAppNotifier(ref));

final searchQueryProvider = StateProvider<String>((ref) => '');
final selectedCategoryProvider = StateProvider<int>((ref) => 1);
