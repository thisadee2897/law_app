
import 'package:law_app/core/database/models/category_form_model.dart';
import 'package:objectbox/objectbox.dart';
class CategoryFormBoxManager {
  final Box<CategoryFormModel> _categoryFormBox;
  CategoryFormBoxManager(Store store) : _categoryFormBox = Box<CategoryFormModel>(store);
  Box<CategoryFormModel> get categoryFormBox => _categoryFormBox;
  List<CategoryFormModel> getAll() => _categoryFormBox.getAll();
  Stream<List<CategoryFormModel>> streamAll() => _categoryFormBox.query().watch(triggerImmediately: true).map((e) => e.find());
  CategoryFormModel? get(int id) => _categoryFormBox.get(id);
  void add(CategoryFormModel categoryForm) => _categoryFormBox.put(categoryForm);
  void update(CategoryFormModel categoryForm) => _categoryFormBox.put(categoryForm);
  // void delete(int id) => _categoryFormBox.remove(id);
  // void deleteMany(List<int> ids) => _categoryFormBox.removeMany(ids);
}
