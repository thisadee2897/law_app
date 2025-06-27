// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_p_d_f_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FormPDFModelImpl _$$FormPDFModelImplFromJson(Map<String, dynamic> json) =>
    _$FormPDFModelImpl(
      hdId: json['hd_id'] as String?,
      formId: json['form_id'] as String?,
      formName: json['form_name'] as String?,
      formPdf: json['form_pdf'] as String?,
      favorite: json['favorite'] as bool?,
      updatedAt: json['updated_at'] as String?,
      description: json['description'] as String?,
      size: json['size'] as String?,
    );

Map<String, dynamic> _$$FormPDFModelImplToJson(_$FormPDFModelImpl instance) =>
    <String, dynamic>{
      'hd_id': instance.hdId,
      'form_id': instance.formId,
      'form_name': instance.formName,
      'form_pdf': instance.formPdf,
      'favorite': instance.favorite,
      'updated_at': instance.updatedAt,
      'description': instance.description,
      'size': instance.size,
    };
