import 'package:law_app/core/database/models/form_model.dart';
import 'package:law_app/core/database/objectbox_database.dart';
import 'package:law_app/objectbox.g.dart';

class FormBoxManager {
  final Box<FormModel> _formBox;
  FormBoxManager(Store store) : _formBox = Box<FormModel>(store);
  Box<FormModel> get formBox => _formBox;
  List<FormModel> getAll() => _formBox.getAll();
  Stream<List<FormModel>> streamAll() => _formBox.query().watch(triggerImmediately: true).map((e) => e.find());
  // Stream<List<FormModel>> streamBySelectCate(int categoryId, String searchText) {
  //   if (categoryId == 1) {
  //     return _formBox.query(FormModel_.formName.contains(searchText, caseSensitive: false) ).watch(triggerImmediately: true).map((e) => e.find());
  //   } else {
  //     return _formBox
  //         .query(FormModel_.categoryId.equals(categoryId).and(FormModel_.formName.contains(searchText, caseSensitive: false)))
  //         .watch(triggerImmediately: true)
  //         .map((e) => e.find());
  //   }
  // }
  Stream<List<FormModel>> streamBySelectCate(int categoryId, String searchText) {
    final condition = FormModel_.formName.contains(searchText, caseSensitive: false).or(FormModel_.categoryName.contains(searchText, caseSensitive: false));

    if (categoryId == 1) {
      return _formBox.query(condition).watch(triggerImmediately: true).map((query) => query.find());
    } else {
      return _formBox.query(FormModel_.categoryId.equals(categoryId).and(condition)).watch(triggerImmediately: true).map((query) => query.find());
    }
  }

  //toggleFavorite
  Future<void> toggleFavorite(FormModel form) async {
    final database = ObjectBoxDatabase.instance;
    final existingForm = database.formBoxManager.formBox.query(FormModel_.formId.equals(form.formId)).build().findFirst();
    if (existingForm != null) {
      existingForm.favorite = !existingForm.favorite;
      database.formBoxManager.formBox.put(existingForm);
    }
    var categoryItem = database.categoryFormBoxManager.categoryFormBox.query(CategoryFormModel_.categoryId.equals(form.categoryId)).build().findFirst();
    if (categoryItem != null) {
      database.categoryFormBoxManager.categoryFormBox.put(categoryItem);
    }
  }

  FormModel? get(int id) => _formBox.get(id);
  void add(FormModel form) => _formBox.put(form);
  void update(FormModel form) => _formBox.put(form);
  // void delete(int id) => _formBox.remove(id);
  // void deleteMany(List<int> ids) => _formBox.removeMany(ids);
}
