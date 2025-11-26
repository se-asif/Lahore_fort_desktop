// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PostResponseModel _$PostResponseModelFromJson(Map<String, dynamic> json) {
  return _PostResponseModel.fromJson(json);
}

/// @nodoc
mixin _$PostResponseModel {
  String? get success =>
      throw _privateConstructorUsedError; // ✅ Changed to bool? if the API returns true/false
  String? get error => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;

  /// Serializes this PostResponseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PostResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PostResponseModelCopyWith<PostResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostResponseModelCopyWith<$Res> {
  factory $PostResponseModelCopyWith(
          PostResponseModel value, $Res Function(PostResponseModel) then) =
      _$PostResponseModelCopyWithImpl<$Res, PostResponseModel>;
  @useResult
  $Res call({String? success, String? error, String? message});
}

/// @nodoc
class _$PostResponseModelCopyWithImpl<$Res, $Val extends PostResponseModel>
    implements $PostResponseModelCopyWith<$Res> {
  _$PostResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PostResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = freezed,
    Object? error = freezed,
    Object? message = freezed,
  }) {
    return _then(_value.copyWith(
      success: freezed == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as String?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PostResponseModelImplCopyWith<$Res>
    implements $PostResponseModelCopyWith<$Res> {
  factory _$$PostResponseModelImplCopyWith(_$PostResponseModelImpl value,
          $Res Function(_$PostResponseModelImpl) then) =
      __$$PostResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? success, String? error, String? message});
}

/// @nodoc
class __$$PostResponseModelImplCopyWithImpl<$Res>
    extends _$PostResponseModelCopyWithImpl<$Res, _$PostResponseModelImpl>
    implements _$$PostResponseModelImplCopyWith<$Res> {
  __$$PostResponseModelImplCopyWithImpl(_$PostResponseModelImpl _value,
      $Res Function(_$PostResponseModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of PostResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = freezed,
    Object? error = freezed,
    Object? message = freezed,
  }) {
    return _then(_$PostResponseModelImpl(
      success: freezed == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as String?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PostResponseModelImpl implements _PostResponseModel {
  const _$PostResponseModelImpl({this.success, this.error, this.message});

  factory _$PostResponseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PostResponseModelImplFromJson(json);

  @override
  final String? success;
// ✅ Changed to bool? if the API returns true/false
  @override
  final String? error;
  @override
  final String? message;

  @override
  String toString() {
    return 'PostResponseModel(success: $success, error: $error, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostResponseModelImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, success, error, message);

  /// Create a copy of PostResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PostResponseModelImplCopyWith<_$PostResponseModelImpl> get copyWith =>
      __$$PostResponseModelImplCopyWithImpl<_$PostResponseModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PostResponseModelImplToJson(
      this,
    );
  }
}

abstract class _PostResponseModel implements PostResponseModel {
  const factory _PostResponseModel(
      {final String? success,
      final String? error,
      final String? message}) = _$PostResponseModelImpl;

  factory _PostResponseModel.fromJson(Map<String, dynamic> json) =
      _$PostResponseModelImpl.fromJson;

  @override
  String? get success; // ✅ Changed to bool? if the API returns true/false
  @override
  String? get error;
  @override
  String? get message;

  /// Create a copy of PostResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PostResponseModelImplCopyWith<_$PostResponseModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
