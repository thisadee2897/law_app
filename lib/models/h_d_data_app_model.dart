
import 'package:freezed_annotation/freezed_annotation.dart';

import 'form_p_d_f_model.dart';

part 'h_d_data_app_model.freezed.dart';
part 'h_d_data_app_model.g.dart';

@freezed
class HDDataAppModel with _$HDDataAppModel {
  const factory HDDataAppModel({
  @JsonKey(name: 'hd_id') String? hdId,
  @JsonKey(name: 'hd_name') String? hdName,
  @JsonKey(name: 'hd_image') String? hdImage,
  @JsonKey(name: 'hd_updated_at') String? hdUpdatedAt,
  @JsonKey(name: 'form') List<FormPDFModel>? form,
  }) = _HDDataAppModel;

  factory HDDataAppModel.fromJson(Map<String, dynamic> json) => _$HDDataAppModelFromJson(json);
}
