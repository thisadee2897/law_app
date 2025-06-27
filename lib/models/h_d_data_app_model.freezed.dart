// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'h_d_data_app_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

HDDataAppModel _$HDDataAppModelFromJson(Map<String, dynamic> json) {
  return _HDDataAppModel.fromJson(json);
}

/// @nodoc
mixin _$HDDataAppModel {
  @JsonKey(name: 'hd_id')
  String? get hdId => throw _privateConstructorUsedError;
  @JsonKey(name: 'hd_name')
  String? get hdName => throw _privateConstructorUsedError;
  @JsonKey(name: 'hd_image')
  String? get hdImage => throw _privateConstructorUsedError;
  @JsonKey(name: 'hd_updated_at')
  String? get hdUpdatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'form')
  List<FormPDFModel>? get form => throw _privateConstructorUsedError;

  /// Serializes this HDDataAppModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HDDataAppModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HDDataAppModelCopyWith<HDDataAppModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HDDataAppModelCopyWith<$Res> {
  factory $HDDataAppModelCopyWith(
    HDDataAppModel value,
    $Res Function(HDDataAppModel) then,
  ) = _$HDDataAppModelCopyWithImpl<$Res, HDDataAppModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'hd_id') String? hdId,
    @JsonKey(name: 'hd_name') String? hdName,
    @JsonKey(name: 'hd_image') String? hdImage,
    @JsonKey(name: 'hd_updated_at') String? hdUpdatedAt,
    @JsonKey(name: 'form') List<FormPDFModel>? form,
  });
}

/// @nodoc
class _$HDDataAppModelCopyWithImpl<$Res, $Val extends HDDataAppModel>
    implements $HDDataAppModelCopyWith<$Res> {
  _$HDDataAppModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HDDataAppModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hdId = freezed,
    Object? hdName = freezed,
    Object? hdImage = freezed,
    Object? hdUpdatedAt = freezed,
    Object? form = freezed,
  }) {
    return _then(
      _value.copyWith(
            hdId:
                freezed == hdId
                    ? _value.hdId
                    : hdId // ignore: cast_nullable_to_non_nullable
                        as String?,
            hdName:
                freezed == hdName
                    ? _value.hdName
                    : hdName // ignore: cast_nullable_to_non_nullable
                        as String?,
            hdImage:
                freezed == hdImage
                    ? _value.hdImage
                    : hdImage // ignore: cast_nullable_to_non_nullable
                        as String?,
            hdUpdatedAt:
                freezed == hdUpdatedAt
                    ? _value.hdUpdatedAt
                    : hdUpdatedAt // ignore: cast_nullable_to_non_nullable
                        as String?,
            form:
                freezed == form
                    ? _value.form
                    : form // ignore: cast_nullable_to_non_nullable
                        as List<FormPDFModel>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HDDataAppModelImplCopyWith<$Res>
    implements $HDDataAppModelCopyWith<$Res> {
  factory _$$HDDataAppModelImplCopyWith(
    _$HDDataAppModelImpl value,
    $Res Function(_$HDDataAppModelImpl) then,
  ) = __$$HDDataAppModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'hd_id') String? hdId,
    @JsonKey(name: 'hd_name') String? hdName,
    @JsonKey(name: 'hd_image') String? hdImage,
    @JsonKey(name: 'hd_updated_at') String? hdUpdatedAt,
    @JsonKey(name: 'form') List<FormPDFModel>? form,
  });
}

/// @nodoc
class __$$HDDataAppModelImplCopyWithImpl<$Res>
    extends _$HDDataAppModelCopyWithImpl<$Res, _$HDDataAppModelImpl>
    implements _$$HDDataAppModelImplCopyWith<$Res> {
  __$$HDDataAppModelImplCopyWithImpl(
    _$HDDataAppModelImpl _value,
    $Res Function(_$HDDataAppModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HDDataAppModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hdId = freezed,
    Object? hdName = freezed,
    Object? hdImage = freezed,
    Object? hdUpdatedAt = freezed,
    Object? form = freezed,
  }) {
    return _then(
      _$HDDataAppModelImpl(
        hdId:
            freezed == hdId
                ? _value.hdId
                : hdId // ignore: cast_nullable_to_non_nullable
                    as String?,
        hdName:
            freezed == hdName
                ? _value.hdName
                : hdName // ignore: cast_nullable_to_non_nullable
                    as String?,
        hdImage:
            freezed == hdImage
                ? _value.hdImage
                : hdImage // ignore: cast_nullable_to_non_nullable
                    as String?,
        hdUpdatedAt:
            freezed == hdUpdatedAt
                ? _value.hdUpdatedAt
                : hdUpdatedAt // ignore: cast_nullable_to_non_nullable
                    as String?,
        form:
            freezed == form
                ? _value._form
                : form // ignore: cast_nullable_to_non_nullable
                    as List<FormPDFModel>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$HDDataAppModelImpl implements _HDDataAppModel {
  const _$HDDataAppModelImpl({
    @JsonKey(name: 'hd_id') this.hdId,
    @JsonKey(name: 'hd_name') this.hdName,
    @JsonKey(name: 'hd_image') this.hdImage,
    @JsonKey(name: 'hd_updated_at') this.hdUpdatedAt,
    @JsonKey(name: 'form') final List<FormPDFModel>? form,
  }) : _form = form;

  factory _$HDDataAppModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$HDDataAppModelImplFromJson(json);

  @override
  @JsonKey(name: 'hd_id')
  final String? hdId;
  @override
  @JsonKey(name: 'hd_name')
  final String? hdName;
  @override
  @JsonKey(name: 'hd_image')
  final String? hdImage;
  @override
  @JsonKey(name: 'hd_updated_at')
  final String? hdUpdatedAt;
  final List<FormPDFModel>? _form;
  @override
  @JsonKey(name: 'form')
  List<FormPDFModel>? get form {
    final value = _form;
    if (value == null) return null;
    if (_form is EqualUnmodifiableListView) return _form;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'HDDataAppModel(hdId: $hdId, hdName: $hdName, hdImage: $hdImage, hdUpdatedAt: $hdUpdatedAt, form: $form)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HDDataAppModelImpl &&
            (identical(other.hdId, hdId) || other.hdId == hdId) &&
            (identical(other.hdName, hdName) || other.hdName == hdName) &&
            (identical(other.hdImage, hdImage) || other.hdImage == hdImage) &&
            (identical(other.hdUpdatedAt, hdUpdatedAt) ||
                other.hdUpdatedAt == hdUpdatedAt) &&
            const DeepCollectionEquality().equals(other._form, _form));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    hdId,
    hdName,
    hdImage,
    hdUpdatedAt,
    const DeepCollectionEquality().hash(_form),
  );

  /// Create a copy of HDDataAppModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HDDataAppModelImplCopyWith<_$HDDataAppModelImpl> get copyWith =>
      __$$HDDataAppModelImplCopyWithImpl<_$HDDataAppModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$HDDataAppModelImplToJson(this);
  }
}

abstract class _HDDataAppModel implements HDDataAppModel {
  const factory _HDDataAppModel({
    @JsonKey(name: 'hd_id') final String? hdId,
    @JsonKey(name: 'hd_name') final String? hdName,
    @JsonKey(name: 'hd_image') final String? hdImage,
    @JsonKey(name: 'hd_updated_at') final String? hdUpdatedAt,
    @JsonKey(name: 'form') final List<FormPDFModel>? form,
  }) = _$HDDataAppModelImpl;

  factory _HDDataAppModel.fromJson(Map<String, dynamic> json) =
      _$HDDataAppModelImpl.fromJson;

  @override
  @JsonKey(name: 'hd_id')
  String? get hdId;
  @override
  @JsonKey(name: 'hd_name')
  String? get hdName;
  @override
  @JsonKey(name: 'hd_image')
  String? get hdImage;
  @override
  @JsonKey(name: 'hd_updated_at')
  String? get hdUpdatedAt;
  @override
  @JsonKey(name: 'form')
  List<FormPDFModel>? get form;

  /// Create a copy of HDDataAppModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HDDataAppModelImplCopyWith<_$HDDataAppModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
