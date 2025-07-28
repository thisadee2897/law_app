import 'package:law_app/core/database/current_data.dart';
import 'package:law_app/core/database/repositories/category_form_box_manager.dart';
import 'package:law_app/objectbox.g.dart';
import 'package:path_provider/path_provider.dart';
import 'repositories/form_box_manager.dart';
import 'package:path/path.dart' show join;
import 'repositories/remider_box_manager.dart';

class ObjectBoxDatabase {
  static late final ObjectBoxDatabase _instance;
  static ObjectBoxDatabase get instance => _instance;

  late final Store _store;

  late final CategoryFormBoxManager categoryFormBoxManager;
  late final FormBoxManager formBoxManager;
  late final ReminderBoxManager reminderBox;

  ObjectBoxDatabase._(this._store) {
    categoryFormBoxManager = CategoryFormBoxManager(_store);
    formBoxManager = FormBoxManager(_store);
    reminderBox = ReminderBoxManager(_store);
  }

  static Future<ObjectBoxDatabase> init() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store = await openStore(directory: join(docsDir.path, "law_app_objectbox"));
    _instance = ObjectBoxDatabase._(store);
    _instance._updateData();
    return _instance;
  }

  _updateData() {
    final currentCategoryData = CurrentCategoryData.getData().where((e) => e.categoryFormActive).toList();
    final formData = CurrentFormPDFData.getData();

    // ✅ อัปเดต Category
    for (var category in currentCategoryData) {
      final duplicates = categoryFormBoxManager.categoryFormBox
          .query(CategoryFormModel_.categoryId.equals(category.categoryId))
          .build()
          .find();

      if (duplicates.isEmpty) {
        category.id = 0;
        categoryFormBoxManager.add(category);
      } else {
        // ลบตัวที่ซ้ำ เก็บตัวแรกไว้
        for (var i = 1; i < duplicates.length; i++) {
          categoryFormBoxManager.categoryFormBox.remove(duplicates[i].id);
        }

        category.id = duplicates[0].id;
        categoryFormBoxManager.update(category);
      }

      var forms = formData.where((form) => form.categoryId == category.categoryId).toList();
      print("forms for category ${category.categoryFormName}: ${forms.length}");
    }

    // ✅ อัปเดต Form
    for (var form in formData) {
      final duplicates = formBoxManager.formBox
          .query(FormModel_.formId.equals(form.formId))
          .build()
          .find();

      if (duplicates.isEmpty) {
        form.id = 0;
        formBoxManager.formBox.put(form);
      } else {
        final existing = duplicates.first;

        // ❗️เก็บค่าสถานะที่ผู้ใช้เปลี่ยนไว้
        form.id = existing.id;
        form.favorite = existing.favorite;
        // ลบตัวอื่นที่ซ้ำ (ยกเว้นตัวแรก)
        for (var i = 1; i < duplicates.length; i++) {
          formBoxManager.formBox.remove(duplicates[i].id);
        }
        formBoxManager.formBox.put(form);
      }
    }

    // ✅ ผูก Form กับ Category
    for (var category in currentCategoryData) {
      final forms = formBoxManager.formBox
          .query(FormModel_.categoryId.equals(category.categoryId))
          .build()
          .find();

      if (forms.isNotEmpty) {
        final categoryModel = categoryFormBoxManager.categoryFormBox.get(category.id);
        if (categoryModel != null) {
          categoryModel.form.clear();
          categoryModel.form.addAll(forms);
          categoryFormBoxManager.categoryFormBox.put(categoryModel);
        }
      }
    }
  }
}
