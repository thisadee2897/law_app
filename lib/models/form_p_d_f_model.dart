
import 'package:freezed_annotation/freezed_annotation.dart';

part 'form_p_d_f_model.freezed.dart';
part 'form_p_d_f_model.g.dart';

@freezed
class FormPDFModel with _$FormPDFModel {
  const factory FormPDFModel({
  @JsonKey(name: 'hd_id') String? hdId,
  @JsonKey(name: 'form_id') String? formId,
  @JsonKey(name: 'form_name') String? formName,
  @JsonKey(name: 'form_pdf') String? formPdf,
  @JsonKey(name: 'favorite') bool? favorite,
  @JsonKey(name: 'updated_at') String? updatedAt,
  @JsonKey(name: 'description') String? description,
  @JsonKey(name: 'size') String? size,
  }) = _FormPDFModel;

  factory FormPDFModel.fromJson(Map<String, dynamic> json) => _$FormPDFModelFromJson(json);
}
