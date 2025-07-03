import 'package:law_app/core/database/current_data.dart';
import 'package:law_app/core/database/repositories/category_form_box_manager.dart';
import 'package:law_app/objectbox.g.dart';
import 'package:path_provider/path_provider.dart';
import 'repositories/form_box_manager.dart';
import 'package:path/path.dart' show join;

class ObjectBoxDatabase {
  static late final ObjectBoxDatabase _instance;
  static ObjectBoxDatabase get instance => _instance;

  late final Store _store;

  late final CategoryFormBoxManager categoryFormBoxManager;
  late final FormBoxManager formBoxManager;
  // late final UnitBoxManager units;
  // late final PropertyBoxManager properties;
  // late final PropertyValueBoxManager propertyValues;
  // late final PropertyForProductBoxManager propertyForProducts;
  // late final JobHDBoxManager jobHDBoxManager;
  // late final JobItemBoxManager jobItemBoxManager;

  ObjectBoxDatabase._(this._store) {
    categoryFormBoxManager = CategoryFormBoxManager(_store);
    formBoxManager = FormBoxManager(_store);
  }

  static Future<ObjectBoxDatabase> init() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store = await openStore(directory: join(docsDir.path, "law_app_objectbox"));
    _instance = ObjectBoxDatabase._(store);
    _instance._updateData();
    return _instance;
  }

  _updateData() {
    final currentCategoryData = CurrentCategoryData.getData();
    final formData = CurrentFormPDFData.getData();
    // Update only if there are existing records
    for (var category in currentCategoryData) {
      final existingCategory = categoryFormBoxManager.categoryFormBox.query(CategoryFormModel_.categoryId.equals(category.categoryId)).build().findFirst();

      if (existingCategory == null) {
        category.id = 0;
        categoryFormBoxManager.categoryFormBox.put(category);
      } else {
        category.id = existingCategory.id;
        categoryFormBoxManager.categoryFormBox.put(category);
      }
    }
    for (var form in formData) {
      final existingForm = formBoxManager.formBox.query(FormModel_.formId.equals(form.formId)).build().findFirst();

      if (existingForm == null) {
        form.id = 0;
        formBoxManager.formBox.put(form);
      } else {
        form.id = existingForm.id;
        formBoxManager.formBox.put(form);
      }
    }
  }
}
