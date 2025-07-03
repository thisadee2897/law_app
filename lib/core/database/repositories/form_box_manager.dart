import 'package:law_app/core/database/models/form_model.dart';
import 'package:objectbox/objectbox.dart';

class FormBoxManager {
  final Box<FormModel> _formBox;
  FormBoxManager(Store store) : _formBox = Box<FormModel>(store);
  Box<FormModel> get formBox => _formBox;
  List<FormModel> getAll() => _formBox.getAll();
  Stream<List<FormModel>> streamAll() => _formBox.query().watch(triggerImmediately: true).map((e) => e.find());
  FormModel? get(int id) => _formBox.get(id);
  void add(FormModel form) => _formBox.put(form);
  void update(FormModel form) => _formBox.put(form);
  // void delete(int id) => _formBox.remove(id);
  // void deleteMany(List<int> ids) => _formBox.removeMany(ids);
}
