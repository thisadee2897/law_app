import 'package:law_app/core/database/models/category_form_model.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class FormModel {
  @Id()
  int id = 0;
  int formId = 0; // Assuming this is needed for linking to a category
  int categoryId = 0; // Assuming this is needed for linking to a category
  String code = '';
  String formName;
  String? formImage;
  @Property(type: PropertyType.date)
  DateTime? formUpdatedAt;
  bool formActive = true;
  String pdfPath = '';
  bool favorite = false;
  final categoryForm = ToOne<CategoryFormModel>();
  FormModel({
    this.id = 0,
    this.formId = 0,
    this.code = '',
    this.categoryId = 0, // Initialize with a default value
    this.formName = '',
    this.formImage,
    this.formUpdatedAt,
    this.formActive = true,
    this.pdfPath = '',
    this.favorite = false,
  });
}
