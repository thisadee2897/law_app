// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'h_d_data_app_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HDDataAppModelImpl _$$HDDataAppModelImplFromJson(Map<String, dynamic> json) =>
    _$HDDataAppModelImpl(
      hdId: json['hd_id'] as String?,
      hdName: json['hd_name'] as String?,
      hdImage: json['hd_image'] as String?,
      hdUpdatedAt: json['hd_updated_at'] as String?,
      form:
          (json['form'] as List<dynamic>?)
              ?.map((e) => FormPDFModel.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$$HDDataAppModelImplToJson(
  _$HDDataAppModelImpl instance,
) => <String, dynamic>{
  'hd_id': instance.hdId,
  'hd_name': instance.hdName,
  'hd_image': instance.hdImage,
  'hd_updated_at': instance.hdUpdatedAt,
  'form': instance.form,
};
