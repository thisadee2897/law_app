
import 'package:law_app/core/database/models/form_model.dart' show FormModel;
import 'package:objectbox/objectbox.dart';

@Entity()
class CategoryFormModel {
  @Id()
  int id = 0;
  @Unique()
  int  categoryId = 0; // Assuming this is needed for linking to a category
  String categoryFormName;
  String categoryFormFullName;
  String? categoryFormImage;
  @Property(type: PropertyType.date)
  DateTime? categoryFormUpdatedAt;
  bool categoryFormActive = true;
  @Backlink('categoryForm')
  final form = ToMany<FormModel>();

  CategoryFormModel({
    this.id = 0,
    this.categoryId = 0, // Initialize with a default value
    this.categoryFormName = '',
    this.categoryFormFullName = '',
    this.categoryFormImage,
    this.categoryFormUpdatedAt,
    this.categoryFormActive = true,
  });
}
