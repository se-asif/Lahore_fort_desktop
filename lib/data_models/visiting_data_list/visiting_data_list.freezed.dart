// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'visiting_data_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

VisitingDataList _$VisitingDataListFromJson(Map<String, dynamic> json) {
  return _VisitingDataList.fromJson(json);
}

/// @nodoc
mixin _$VisitingDataList {
  int? get id => throw _privateConstructorUsedError;
  List<Map<String, dynamic>>? get typeWiseData =>
      throw _privateConstructorUsedError;
  String? get paymentId => throw _privateConstructorUsedError;
  String? get totalPersons => throw _privateConstructorUsedError;
  String? get totalAmount => throw _privateConstructorUsedError;
  String? get gateId => throw _privateConstructorUsedError;
  String? get parkingLotId => throw _privateConstructorUsedError;
  String? get userId => throw _privateConstructorUsedError;
  String? get date => throw _privateConstructorUsedError;
  String? get userName => throw _privateConstructorUsedError;
  String? get gateName => throw _privateConstructorUsedError;
  String? get ticketingPoint => throw _privateConstructorUsedError;
  String? get transactionUniqueId => throw _privateConstructorUsedError;
  String? get userMacId => throw _privateConstructorUsedError;
  int get isUploaded => throw _privateConstructorUsedError;
  String? get billNo => throw _privateConstructorUsedError;

  /// Serializes this VisitingDataList to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VisitingDataList
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VisitingDataListCopyWith<VisitingDataList> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VisitingDataListCopyWith<$Res> {
  factory $VisitingDataListCopyWith(
          VisitingDataList value, $Res Function(VisitingDataList) then) =
      _$VisitingDataListCopyWithImpl<$Res, VisitingDataList>;
  @useResult
  $Res call(
      {int? id,
      List<Map<String, dynamic>>? typeWiseData,
      String? paymentId,
      String? totalPersons,
      String? totalAmount,
      String? gateId,
      String? parkingLotId,
      String? userId,
      String? date,
      String? userName,
      String? gateName,
      String? ticketingPoint,
      String? transactionUniqueId,
      String? userMacId,
      int isUploaded,
      String? billNo});
}

/// @nodoc
class _$VisitingDataListCopyWithImpl<$Res, $Val extends VisitingDataList>
    implements $VisitingDataListCopyWith<$Res> {
  _$VisitingDataListCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VisitingDataList
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? typeWiseData = freezed,
    Object? paymentId = freezed,
    Object? totalPersons = freezed,
    Object? totalAmount = freezed,
    Object? gateId = freezed,
    Object? parkingLotId = freezed,
    Object? userId = freezed,
    Object? date = freezed,
    Object? userName = freezed,
    Object? gateName = freezed,
    Object? ticketingPoint = freezed,
    Object? transactionUniqueId = freezed,
    Object? userMacId = freezed,
    Object? isUploaded = null,
    Object? billNo = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      typeWiseData: freezed == typeWiseData
          ? _value.typeWiseData
          : typeWiseData // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>?,
      paymentId: freezed == paymentId
          ? _value.paymentId
          : paymentId // ignore: cast_nullable_to_non_nullable
              as String?,
      totalPersons: freezed == totalPersons
          ? _value.totalPersons
          : totalPersons // ignore: cast_nullable_to_non_nullable
              as String?,
      totalAmount: freezed == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as String?,
      gateId: freezed == gateId
          ? _value.gateId
          : gateId // ignore: cast_nullable_to_non_nullable
              as String?,
      parkingLotId: freezed == parkingLotId
          ? _value.parkingLotId
          : parkingLotId // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String?,
      userName: freezed == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String?,
      gateName: freezed == gateName
          ? _value.gateName
          : gateName // ignore: cast_nullable_to_non_nullable
              as String?,
      ticketingPoint: freezed == ticketingPoint
          ? _value.ticketingPoint
          : ticketingPoint // ignore: cast_nullable_to_non_nullable
              as String?,
      transactionUniqueId: freezed == transactionUniqueId
          ? _value.transactionUniqueId
          : transactionUniqueId // ignore: cast_nullable_to_non_nullable
              as String?,
      userMacId: freezed == userMacId
          ? _value.userMacId
          : userMacId // ignore: cast_nullable_to_non_nullable
              as String?,
      isUploaded: null == isUploaded
          ? _value.isUploaded
          : isUploaded // ignore: cast_nullable_to_non_nullable
              as int,
      billNo: freezed == billNo
          ? _value.billNo
          : billNo // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VisitingDataListImplCopyWith<$Res>
    implements $VisitingDataListCopyWith<$Res> {
  factory _$$VisitingDataListImplCopyWith(_$VisitingDataListImpl value,
          $Res Function(_$VisitingDataListImpl) then) =
      __$$VisitingDataListImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      List<Map<String, dynamic>>? typeWiseData,
      String? paymentId,
      String? totalPersons,
      String? totalAmount,
      String? gateId,
      String? parkingLotId,
      String? userId,
      String? date,
      String? userName,
      String? gateName,
      String? ticketingPoint,
      String? transactionUniqueId,
      String? userMacId,
      int isUploaded,
      String? billNo});
}

/// @nodoc
class __$$VisitingDataListImplCopyWithImpl<$Res>
    extends _$VisitingDataListCopyWithImpl<$Res, _$VisitingDataListImpl>
    implements _$$VisitingDataListImplCopyWith<$Res> {
  __$$VisitingDataListImplCopyWithImpl(_$VisitingDataListImpl _value,
      $Res Function(_$VisitingDataListImpl) _then)
      : super(_value, _then);

  /// Create a copy of VisitingDataList
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? typeWiseData = freezed,
    Object? paymentId = freezed,
    Object? totalPersons = freezed,
    Object? totalAmount = freezed,
    Object? gateId = freezed,
    Object? parkingLotId = freezed,
    Object? userId = freezed,
    Object? date = freezed,
    Object? userName = freezed,
    Object? gateName = freezed,
    Object? ticketingPoint = freezed,
    Object? transactionUniqueId = freezed,
    Object? userMacId = freezed,
    Object? isUploaded = null,
    Object? billNo = freezed,
  }) {
    return _then(_$VisitingDataListImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      typeWiseData: freezed == typeWiseData
          ? _value._typeWiseData
          : typeWiseData // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>?,
      paymentId: freezed == paymentId
          ? _value.paymentId
          : paymentId // ignore: cast_nullable_to_non_nullable
              as String?,
      totalPersons: freezed == totalPersons
          ? _value.totalPersons
          : totalPersons // ignore: cast_nullable_to_non_nullable
              as String?,
      totalAmount: freezed == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as String?,
      gateId: freezed == gateId
          ? _value.gateId
          : gateId // ignore: cast_nullable_to_non_nullable
              as String?,
      parkingLotId: freezed == parkingLotId
          ? _value.parkingLotId
          : parkingLotId // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String?,
      userName: freezed == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String?,
      gateName: freezed == gateName
          ? _value.gateName
          : gateName // ignore: cast_nullable_to_non_nullable
              as String?,
      ticketingPoint: freezed == ticketingPoint
          ? _value.ticketingPoint
          : ticketingPoint // ignore: cast_nullable_to_non_nullable
              as String?,
      transactionUniqueId: freezed == transactionUniqueId
          ? _value.transactionUniqueId
          : transactionUniqueId // ignore: cast_nullable_to_non_nullable
              as String?,
      userMacId: freezed == userMacId
          ? _value.userMacId
          : userMacId // ignore: cast_nullable_to_non_nullable
              as String?,
      isUploaded: null == isUploaded
          ? _value.isUploaded
          : isUploaded // ignore: cast_nullable_to_non_nullable
              as int,
      billNo: freezed == billNo
          ? _value.billNo
          : billNo // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VisitingDataListImpl implements _VisitingDataList {
  const _$VisitingDataListImpl(
      {this.id,
      final List<Map<String, dynamic>>? typeWiseData,
      this.paymentId,
      this.totalPersons,
      this.totalAmount,
      this.gateId,
      this.parkingLotId,
      this.userId,
      this.date,
      this.userName,
      this.gateName,
      this.ticketingPoint,
      this.transactionUniqueId,
      this.userMacId,
      required this.isUploaded,
      this.billNo})
      : _typeWiseData = typeWiseData;

  factory _$VisitingDataListImpl.fromJson(Map<String, dynamic> json) =>
      _$$VisitingDataListImplFromJson(json);

  @override
  final int? id;
  final List<Map<String, dynamic>>? _typeWiseData;
  @override
  List<Map<String, dynamic>>? get typeWiseData {
    final value = _typeWiseData;
    if (value == null) return null;
    if (_typeWiseData is EqualUnmodifiableListView) return _typeWiseData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? paymentId;
  @override
  final String? totalPersons;
  @override
  final String? totalAmount;
  @override
  final String? gateId;
  @override
  final String? parkingLotId;
  @override
  final String? userId;
  @override
  final String? date;
  @override
  final String? userName;
  @override
  final String? gateName;
  @override
  final String? ticketingPoint;
  @override
  final String? transactionUniqueId;
  @override
  final String? userMacId;
  @override
  final int isUploaded;
  @override
  final String? billNo;

  @override
  String toString() {
    return 'VisitingDataList(id: $id, typeWiseData: $typeWiseData, paymentId: $paymentId, totalPersons: $totalPersons, totalAmount: $totalAmount, gateId: $gateId, parkingLotId: $parkingLotId, userId: $userId, date: $date, userName: $userName, gateName: $gateName, ticketingPoint: $ticketingPoint, transactionUniqueId: $transactionUniqueId, userMacId: $userMacId, isUploaded: $isUploaded, billNo: $billNo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VisitingDataListImpl &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality()
                .equals(other._typeWiseData, _typeWiseData) &&
            (identical(other.paymentId, paymentId) ||
                other.paymentId == paymentId) &&
            (identical(other.totalPersons, totalPersons) ||
                other.totalPersons == totalPersons) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.gateId, gateId) || other.gateId == gateId) &&
            (identical(other.parkingLotId, parkingLotId) ||
                other.parkingLotId == parkingLotId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.gateName, gateName) ||
                other.gateName == gateName) &&
            (identical(other.ticketingPoint, ticketingPoint) ||
                other.ticketingPoint == ticketingPoint) &&
            (identical(other.transactionUniqueId, transactionUniqueId) ||
                other.transactionUniqueId == transactionUniqueId) &&
            (identical(other.userMacId, userMacId) ||
                other.userMacId == userMacId) &&
            (identical(other.isUploaded, isUploaded) ||
                other.isUploaded == isUploaded) &&
            (identical(other.billNo, billNo) || other.billNo == billNo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      const DeepCollectionEquality().hash(_typeWiseData),
      paymentId,
      totalPersons,
      totalAmount,
      gateId,
      parkingLotId,
      userId,
      date,
      userName,
      gateName,
      ticketingPoint,
      transactionUniqueId,
      userMacId,
      isUploaded,
      billNo);

  /// Create a copy of VisitingDataList
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VisitingDataListImplCopyWith<_$VisitingDataListImpl> get copyWith =>
      __$$VisitingDataListImplCopyWithImpl<_$VisitingDataListImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VisitingDataListImplToJson(
      this,
    );
  }
}

abstract class _VisitingDataList implements VisitingDataList {
  const factory _VisitingDataList(
      {final int? id,
      final List<Map<String, dynamic>>? typeWiseData,
      final String? paymentId,
      final String? totalPersons,
      final String? totalAmount,
      final String? gateId,
      final String? parkingLotId,
      final String? userId,
      final String? date,
      final String? userName,
      final String? gateName,
      final String? ticketingPoint,
      final String? transactionUniqueId,
      final String? userMacId,
      required final int isUploaded,
      final String? billNo}) = _$VisitingDataListImpl;

  factory _VisitingDataList.fromJson(Map<String, dynamic> json) =
      _$VisitingDataListImpl.fromJson;

  @override
  int? get id;
  @override
  List<Map<String, dynamic>>? get typeWiseData;
  @override
  String? get paymentId;
  @override
  String? get totalPersons;
  @override
  String? get totalAmount;
  @override
  String? get gateId;
  @override
  String? get parkingLotId;
  @override
  String? get userId;
  @override
  String? get date;
  @override
  String? get userName;
  @override
  String? get gateName;
  @override
  String? get ticketingPoint;
  @override
  String? get transactionUniqueId;
  @override
  String? get userMacId;
  @override
  int get isUploaded;
  @override
  String? get billNo;

  /// Create a copy of VisitingDataList
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VisitingDataListImplCopyWith<_$VisitingDataListImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
