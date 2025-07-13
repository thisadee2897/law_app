
import 'package:objectbox/objectbox.dart';

import '../models/reminder_model.dart';
class ReminderBoxManager {
  final Box<ReminderModel> _reminderBox;
  ReminderBoxManager(Store store) : _reminderBox = Box<ReminderModel>(store);
  Box<ReminderModel> get reminderBox => _reminderBox;
  List<ReminderModel> getAll() => _reminderBox.getAll();
  Stream<List<ReminderModel>> streamAll() => _reminderBox.query().watch(triggerImmediately: true).map((e) => e.find());
  ReminderModel? get(int id) => _reminderBox.get(id);
  void add(ReminderModel reminder) => _reminderBox.put(reminder);
  void update(ReminderModel reminder) => _reminderBox.put(reminder);
  void delete(int id) => _reminderBox.remove(id);
  void deleteMany(List<int> ids) => _reminderBox.removeMany(ids);
  void removeFormsWhenIdNotInList(List<int> formIds) {
    if (formIds.isEmpty) {
      final allReminders = _reminderBox.getAll();
      for (var reminder in allReminders) {
        reminder.forms.clear();
        _reminderBox.put(reminder);
      }
      return;
    }
    final allReminders = _reminderBox.getAll();
    for (var reminder in allReminders) {
      reminder.forms.removeWhere((form) => !formIds.contains(form.id));
      _reminderBox.put(reminder);
    }
  }
}
