// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ticket_category_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TicketCategory _$TicketCategoryFromJson(Map<String, dynamic> json) {
  return _TicketCategory.fromJson(json);
}

/// @nodoc
mixin _$TicketCategory {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'routine_charges')
  int? get routineCharges => throw _privateConstructorUsedError;
  String? get image => throw _privateConstructorUsedError;
  @JsonKey(name: 'parking_lots_id')
  int? get parkingLotsId => throw _privateConstructorUsedError;
  @JsonKey(name: 'visitor_type_id')
  int? get visitorTypeId => throw _privateConstructorUsedError;

  /// Serializes this TicketCategory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TicketCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TicketCategoryCopyWith<TicketCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TicketCategoryCopyWith<$Res> {
  factory $TicketCategoryCopyWith(
          TicketCategory value, $Res Function(TicketCategory) then) =
      _$TicketCategoryCopyWithImpl<$Res, TicketCategory>;
  @useResult
  $Res call(
      {int id,
      String name,
      @JsonKey(name: 'routine_charges') int? routineCharges,
      String? image,
      @JsonKey(name: 'parking_lots_id') int? parkingLotsId,
      @JsonKey(name: 'visitor_type_id') int? visitorTypeId});
}

/// @nodoc
class _$TicketCategoryCopyWithImpl<$Res, $Val extends TicketCategory>
    implements $TicketCategoryCopyWith<$Res> {
  _$TicketCategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TicketCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? routineCharges = freezed,
    Object? image = freezed,
    Object? parkingLotsId = freezed,
    Object? visitorTypeId = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      routineCharges: freezed == routineCharges
          ? _value.routineCharges
          : routineCharges // ignore: cast_nullable_to_non_nullable
              as int?,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      parkingLotsId: freezed == parkingLotsId
          ? _value.parkingLotsId
          : parkingLotsId // ignore: cast_nullable_to_non_nullable
              as int?,
      visitorTypeId: freezed == visitorTypeId
          ? _value.visitorTypeId
          : visitorTypeId // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TicketCategoryImplCopyWith<$Res>
    implements $TicketCategoryCopyWith<$Res> {
  factory _$$TicketCategoryImplCopyWith(_$TicketCategoryImpl value,
          $Res Function(_$TicketCategoryImpl) then) =
      __$$TicketCategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      @JsonKey(name: 'routine_charges') int? routineCharges,
      String? image,
      @JsonKey(name: 'parking_lots_id') int? parkingLotsId,
      @JsonKey(name: 'visitor_type_id') int? visitorTypeId});
}

/// @nodoc
class __$$TicketCategoryImplCopyWithImpl<$Res>
    extends _$TicketCategoryCopyWithImpl<$Res, _$TicketCategoryImpl>
    implements _$$TicketCategoryImplCopyWith<$Res> {
  __$$TicketCategoryImplCopyWithImpl(
      _$TicketCategoryImpl _value, $Res Function(_$TicketCategoryImpl) _then)
      : super(_value, _then);

  /// Create a copy of TicketCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? routineCharges = freezed,
    Object? image = freezed,
    Object? parkingLotsId = freezed,
    Object? visitorTypeId = freezed,
  }) {
    return _then(_$TicketCategoryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      routineCharges: freezed == routineCharges
          ? _value.routineCharges
          : routineCharges // ignore: cast_nullable_to_non_nullable
              as int?,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      parkingLotsId: freezed == parkingLotsId
          ? _value.parkingLotsId
          : parkingLotsId // ignore: cast_nullable_to_non_nullable
              as int?,
      visitorTypeId: freezed == visitorTypeId
          ? _value.visitorTypeId
          : visitorTypeId // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TicketCategoryImpl implements _TicketCategory {
  const _$TicketCategoryImpl(
      {required this.id,
      required this.name,
      @JsonKey(name: 'routine_charges') this.routineCharges,
      this.image,
      @JsonKey(name: 'parking_lots_id') this.parkingLotsId,
      @JsonKey(name: 'visitor_type_id') this.visitorTypeId});

  factory _$TicketCategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$TicketCategoryImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  @JsonKey(name: 'routine_charges')
  final int? routineCharges;
  @override
  final String? image;
  @override
  @JsonKey(name: 'parking_lots_id')
  final int? parkingLotsId;
  @override
  @JsonKey(name: 'visitor_type_id')
  final int? visitorTypeId;

  @override
  String toString() {
    return 'TicketCategory(id: $id, name: $name, routineCharges: $routineCharges, image: $image, parkingLotsId: $parkingLotsId, visitorTypeId: $visitorTypeId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TicketCategoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.routineCharges, routineCharges) ||
                other.routineCharges == routineCharges) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.parkingLotsId, parkingLotsId) ||
                other.parkingLotsId == parkingLotsId) &&
            (identical(other.visitorTypeId, visitorTypeId) ||
                other.visitorTypeId == visitorTypeId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, routineCharges, image,
      parkingLotsId, visitorTypeId);

  /// Create a copy of TicketCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TicketCategoryImplCopyWith<_$TicketCategoryImpl> get copyWith =>
      __$$TicketCategoryImplCopyWithImpl<_$TicketCategoryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TicketCategoryImplToJson(
      this,
    );
  }
}

abstract class _TicketCategory implements TicketCategory {
  const factory _TicketCategory(
          {required final int id,
          required final String name,
          @JsonKey(name: 'routine_charges') final int? routineCharges,
          final String? image,
          @JsonKey(name: 'parking_lots_id') final int? parkingLotsId,
          @JsonKey(name: 'visitor_type_id') final int? visitorTypeId}) =
      _$TicketCategoryImpl;

  factory _TicketCategory.fromJson(Map<String, dynamic> json) =
      _$TicketCategoryImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  @JsonKey(name: 'routine_charges')
  int? get routineCharges;
  @override
  String? get image;
  @override
  @JsonKey(name: 'parking_lots_id')
  int? get parkingLotsId;
  @override
  @JsonKey(name: 'visitor_type_id')
  int? get visitorTypeId;

  /// Create a copy of TicketCategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TicketCategoryImplCopyWith<_$TicketCategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TicketCategoriesResponse _$TicketCategoriesResponseFromJson(
    Map<String, dynamic> json) {
  return _TicketCategoriesResponse.fromJson(json);
}

/// @nodoc
mixin _$TicketCategoriesResponse {
  List<TicketCategory> get catagories => throw _privateConstructorUsedError;

  /// Serializes this TicketCategoriesResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TicketCategoriesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TicketCategoriesResponseCopyWith<TicketCategoriesResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TicketCategoriesResponseCopyWith<$Res> {
  factory $TicketCategoriesResponseCopyWith(TicketCategoriesResponse value,
          $Res Function(TicketCategoriesResponse) then) =
      _$TicketCategoriesResponseCopyWithImpl<$Res, TicketCategoriesResponse>;
  @useResult
  $Res call({List<TicketCategory> catagories});
}

/// @nodoc
class _$TicketCategoriesResponseCopyWithImpl<$Res,
        $Val extends TicketCategoriesResponse>
    implements $TicketCategoriesResponseCopyWith<$Res> {
  _$TicketCategoriesResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TicketCategoriesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? catagories = null,
  }) {
    return _then(_value.copyWith(
      catagories: null == catagories
          ? _value.catagories
          : catagories // ignore: cast_nullable_to_non_nullable
              as List<TicketCategory>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TicketCategoriesResponseImplCopyWith<$Res>
    implements $TicketCategoriesResponseCopyWith<$Res> {
  factory _$$TicketCategoriesResponseImplCopyWith(
          _$TicketCategoriesResponseImpl value,
          $Res Function(_$TicketCategoriesResponseImpl) then) =
      __$$TicketCategoriesResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<TicketCategory> catagories});
}

/// @nodoc
class __$$TicketCategoriesResponseImplCopyWithImpl<$Res>
    extends _$TicketCategoriesResponseCopyWithImpl<$Res,
        _$TicketCategoriesResponseImpl>
    implements _$$TicketCategoriesResponseImplCopyWith<$Res> {
  __$$TicketCategoriesResponseImplCopyWithImpl(
      _$TicketCategoriesResponseImpl _value,
      $Res Function(_$TicketCategoriesResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of TicketCategoriesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? catagories = null,
  }) {
    return _then(_$TicketCategoriesResponseImpl(
      catagories: null == catagories
          ? _value._catagories
          : catagories // ignore: cast_nullable_to_non_nullable
              as List<TicketCategory>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TicketCategoriesResponseImpl implements _TicketCategoriesResponse {
  const _$TicketCategoriesResponseImpl(
      {required final List<TicketCategory> catagories})
      : _catagories = catagories;

  factory _$TicketCategoriesResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$TicketCategoriesResponseImplFromJson(json);

  final List<TicketCategory> _catagories;
  @override
  List<TicketCategory> get catagories {
    if (_catagories is EqualUnmodifiableListView) return _catagories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_catagories);
  }

  @override
  String toString() {
    return 'TicketCategoriesResponse(catagories: $catagories)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TicketCategoriesResponseImpl &&
            const DeepCollectionEquality()
                .equals(other._catagories, _catagories));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_catagories));

  /// Create a copy of TicketCategoriesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TicketCategoriesResponseImplCopyWith<_$TicketCategoriesResponseImpl>
      get copyWith => __$$TicketCategoriesResponseImplCopyWithImpl<
          _$TicketCategoriesResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TicketCategoriesResponseImplToJson(
      this,
    );
  }
}

abstract class _TicketCategoriesResponse implements TicketCategoriesResponse {
  const factory _TicketCategoriesResponse(
          {required final List<TicketCategory> catagories}) =
      _$TicketCategoriesResponseImpl;

  factory _TicketCategoriesResponse.fromJson(Map<String, dynamic> json) =
      _$TicketCategoriesResponseImpl.fromJson;

  @override
  List<TicketCategory> get catagories;

  /// Create a copy of TicketCategoriesResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TicketCategoriesResponseImplCopyWith<_$TicketCategoriesResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
