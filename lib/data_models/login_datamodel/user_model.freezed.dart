// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserResponse _$UserResponseFromJson(Map<String, dynamic> json) {
  return _UserResponse.fromJson(json);
}

/// @nodoc
mixin _$UserResponse {
  User? get user =>
      throw _privateConstructorUsedError; // Ensuring user is required since it's always present
  String? get error => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;

  /// Serializes this UserResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserResponseCopyWith<UserResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserResponseCopyWith<$Res> {
  factory $UserResponseCopyWith(
          UserResponse value, $Res Function(UserResponse) then) =
      _$UserResponseCopyWithImpl<$Res, UserResponse>;
  @useResult
  $Res call({User? user, String? error, String? message});

  $UserCopyWith<$Res>? get user;
}

/// @nodoc
class _$UserResponseCopyWithImpl<$Res, $Val extends UserResponse>
    implements $UserResponseCopyWith<$Res> {
  _$UserResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = freezed,
    Object? error = freezed,
    Object? message = freezed,
  }) {
    return _then(_value.copyWith(
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
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

  /// Create a copy of UserResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res>? get user {
    if (_value.user == null) {
      return null;
    }

    return $UserCopyWith<$Res>(_value.user!, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserResponseImplCopyWith<$Res>
    implements $UserResponseCopyWith<$Res> {
  factory _$$UserResponseImplCopyWith(
          _$UserResponseImpl value, $Res Function(_$UserResponseImpl) then) =
      __$$UserResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({User? user, String? error, String? message});

  @override
  $UserCopyWith<$Res>? get user;
}

/// @nodoc
class __$$UserResponseImplCopyWithImpl<$Res>
    extends _$UserResponseCopyWithImpl<$Res, _$UserResponseImpl>
    implements _$$UserResponseImplCopyWith<$Res> {
  __$$UserResponseImplCopyWithImpl(
      _$UserResponseImpl _value, $Res Function(_$UserResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = freezed,
    Object? error = freezed,
    Object? message = freezed,
  }) {
    return _then(_$UserResponseImpl(
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
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
class _$UserResponseImpl implements _UserResponse {
  const _$UserResponseImpl({this.user, this.error, this.message});

  factory _$UserResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserResponseImplFromJson(json);

  @override
  final User? user;
// Ensuring user is required since it's always present
  @override
  final String? error;
  @override
  final String? message;

  @override
  String toString() {
    return 'UserResponse(user: $user, error: $error, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserResponseImpl &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, user, error, message);

  /// Create a copy of UserResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserResponseImplCopyWith<_$UserResponseImpl> get copyWith =>
      __$$UserResponseImplCopyWithImpl<_$UserResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserResponseImplToJson(
      this,
    );
  }
}

abstract class _UserResponse implements UserResponse {
  const factory _UserResponse(
      {final User? user,
      final String? error,
      final String? message}) = _$UserResponseImpl;

  factory _UserResponse.fromJson(Map<String, dynamic> json) =
      _$UserResponseImpl.fromJson;

  @override
  User? get user; // Ensuring user is required since it's always present
  @override
  String? get error;
  @override
  String? get message;

  /// Create a copy of UserResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserResponseImplCopyWith<_$UserResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
mixin _$User {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'first_name')
  String get firstName => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_name')
  String get lastName => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  @JsonKey(name: 'email_verified_at')
  String? get emailVerifiedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'profile_photo_path')
  String? get profilePhotoPath => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  int get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'parking_lots_id')
  int get parkingLotsId => throw _privateConstructorUsedError;
  @JsonKey(name: 'gates_id')
  int get gatesId => throw _privateConstructorUsedError;
  @JsonKey(name: 'shifts_id')
  int? get shiftsId => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'mac_address')
  String? get macAddress => throw _privateConstructorUsedError;
  @JsonKey(name: 'allow_mac')
  int get allowMac => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String get updatedAt => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get operations => throw _privateConstructorUsedError;
  String get purpose => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  int get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'parking_lot_name')
  String get parkingLotName => throw _privateConstructorUsedError;

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res, User>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'first_name') String firstName,
      @JsonKey(name: 'last_name') String lastName,
      String email,
      @JsonKey(name: 'email_verified_at') String? emailVerifiedAt,
      @JsonKey(name: 'profile_photo_path') String? profilePhotoPath,
      @JsonKey(name: 'is_active') int isActive,
      @JsonKey(name: 'parking_lots_id') int parkingLotsId,
      @JsonKey(name: 'gates_id') int gatesId,
      @JsonKey(name: 'shifts_id') int? shiftsId,
      String? description,
      @JsonKey(name: 'mac_address') String? macAddress,
      @JsonKey(name: 'allow_mac') int allowMac,
      @JsonKey(name: 'created_at') String createdAt,
      @JsonKey(name: 'updated_at') String updatedAt,
      String name,
      String operations,
      String purpose,
      @JsonKey(name: 'user_id') int userId,
      @JsonKey(name: 'parking_lot_name') String parkingLotName});
}

/// @nodoc
class _$UserCopyWithImpl<$Res, $Val extends User>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? email = null,
    Object? emailVerifiedAt = freezed,
    Object? profilePhotoPath = freezed,
    Object? isActive = null,
    Object? parkingLotsId = null,
    Object? gatesId = null,
    Object? shiftsId = freezed,
    Object? description = freezed,
    Object? macAddress = freezed,
    Object? allowMac = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? name = null,
    Object? operations = null,
    Object? purpose = null,
    Object? userId = null,
    Object? parkingLotName = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      emailVerifiedAt: freezed == emailVerifiedAt
          ? _value.emailVerifiedAt
          : emailVerifiedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      profilePhotoPath: freezed == profilePhotoPath
          ? _value.profilePhotoPath
          : profilePhotoPath // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as int,
      parkingLotsId: null == parkingLotsId
          ? _value.parkingLotsId
          : parkingLotsId // ignore: cast_nullable_to_non_nullable
              as int,
      gatesId: null == gatesId
          ? _value.gatesId
          : gatesId // ignore: cast_nullable_to_non_nullable
              as int,
      shiftsId: freezed == shiftsId
          ? _value.shiftsId
          : shiftsId // ignore: cast_nullable_to_non_nullable
              as int?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      macAddress: freezed == macAddress
          ? _value.macAddress
          : macAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      allowMac: null == allowMac
          ? _value.allowMac
          : allowMac // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      operations: null == operations
          ? _value.operations
          : operations // ignore: cast_nullable_to_non_nullable
              as String,
      purpose: null == purpose
          ? _value.purpose
          : purpose // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      parkingLotName: null == parkingLotName
          ? _value.parkingLotName
          : parkingLotName // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserImplCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$UserImplCopyWith(
          _$UserImpl value, $Res Function(_$UserImpl) then) =
      __$$UserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'first_name') String firstName,
      @JsonKey(name: 'last_name') String lastName,
      String email,
      @JsonKey(name: 'email_verified_at') String? emailVerifiedAt,
      @JsonKey(name: 'profile_photo_path') String? profilePhotoPath,
      @JsonKey(name: 'is_active') int isActive,
      @JsonKey(name: 'parking_lots_id') int parkingLotsId,
      @JsonKey(name: 'gates_id') int gatesId,
      @JsonKey(name: 'shifts_id') int? shiftsId,
      String? description,
      @JsonKey(name: 'mac_address') String? macAddress,
      @JsonKey(name: 'allow_mac') int allowMac,
      @JsonKey(name: 'created_at') String createdAt,
      @JsonKey(name: 'updated_at') String updatedAt,
      String name,
      String operations,
      String purpose,
      @JsonKey(name: 'user_id') int userId,
      @JsonKey(name: 'parking_lot_name') String parkingLotName});
}

/// @nodoc
class __$$UserImplCopyWithImpl<$Res>
    extends _$UserCopyWithImpl<$Res, _$UserImpl>
    implements _$$UserImplCopyWith<$Res> {
  __$$UserImplCopyWithImpl(_$UserImpl _value, $Res Function(_$UserImpl) _then)
      : super(_value, _then);

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? email = null,
    Object? emailVerifiedAt = freezed,
    Object? profilePhotoPath = freezed,
    Object? isActive = null,
    Object? parkingLotsId = null,
    Object? gatesId = null,
    Object? shiftsId = freezed,
    Object? description = freezed,
    Object? macAddress = freezed,
    Object? allowMac = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? name = null,
    Object? operations = null,
    Object? purpose = null,
    Object? userId = null,
    Object? parkingLotName = null,
  }) {
    return _then(_$UserImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      emailVerifiedAt: freezed == emailVerifiedAt
          ? _value.emailVerifiedAt
          : emailVerifiedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      profilePhotoPath: freezed == profilePhotoPath
          ? _value.profilePhotoPath
          : profilePhotoPath // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as int,
      parkingLotsId: null == parkingLotsId
          ? _value.parkingLotsId
          : parkingLotsId // ignore: cast_nullable_to_non_nullable
              as int,
      gatesId: null == gatesId
          ? _value.gatesId
          : gatesId // ignore: cast_nullable_to_non_nullable
              as int,
      shiftsId: freezed == shiftsId
          ? _value.shiftsId
          : shiftsId // ignore: cast_nullable_to_non_nullable
              as int?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      macAddress: freezed == macAddress
          ? _value.macAddress
          : macAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      allowMac: null == allowMac
          ? _value.allowMac
          : allowMac // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      operations: null == operations
          ? _value.operations
          : operations // ignore: cast_nullable_to_non_nullable
              as String,
      purpose: null == purpose
          ? _value.purpose
          : purpose // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      parkingLotName: null == parkingLotName
          ? _value.parkingLotName
          : parkingLotName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserImpl implements _User {
  const _$UserImpl(
      {required this.id,
      @JsonKey(name: 'first_name') required this.firstName,
      @JsonKey(name: 'last_name') required this.lastName,
      required this.email,
      @JsonKey(name: 'email_verified_at') this.emailVerifiedAt,
      @JsonKey(name: 'profile_photo_path') this.profilePhotoPath,
      @JsonKey(name: 'is_active') required this.isActive,
      @JsonKey(name: 'parking_lots_id') required this.parkingLotsId,
      @JsonKey(name: 'gates_id') required this.gatesId,
      @JsonKey(name: 'shifts_id') this.shiftsId,
      this.description,
      @JsonKey(name: 'mac_address') this.macAddress,
      @JsonKey(name: 'allow_mac') required this.allowMac,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt,
      required this.name,
      required this.operations,
      required this.purpose,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'parking_lot_name') required this.parkingLotName});

  factory _$UserImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'first_name')
  final String firstName;
  @override
  @JsonKey(name: 'last_name')
  final String lastName;
  @override
  final String email;
  @override
  @JsonKey(name: 'email_verified_at')
  final String? emailVerifiedAt;
  @override
  @JsonKey(name: 'profile_photo_path')
  final String? profilePhotoPath;
  @override
  @JsonKey(name: 'is_active')
  final int isActive;
  @override
  @JsonKey(name: 'parking_lots_id')
  final int parkingLotsId;
  @override
  @JsonKey(name: 'gates_id')
  final int gatesId;
  @override
  @JsonKey(name: 'shifts_id')
  final int? shiftsId;
  @override
  final String? description;
  @override
  @JsonKey(name: 'mac_address')
  final String? macAddress;
  @override
  @JsonKey(name: 'allow_mac')
  final int allowMac;
  @override
  @JsonKey(name: 'created_at')
  final String createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  @override
  final String name;
  @override
  final String operations;
  @override
  final String purpose;
  @override
  @JsonKey(name: 'user_id')
  final int userId;
  @override
  @JsonKey(name: 'parking_lot_name')
  final String parkingLotName;

  @override
  String toString() {
    return 'User(id: $id, firstName: $firstName, lastName: $lastName, email: $email, emailVerifiedAt: $emailVerifiedAt, profilePhotoPath: $profilePhotoPath, isActive: $isActive, parkingLotsId: $parkingLotsId, gatesId: $gatesId, shiftsId: $shiftsId, description: $description, macAddress: $macAddress, allowMac: $allowMac, createdAt: $createdAt, updatedAt: $updatedAt, name: $name, operations: $operations, purpose: $purpose, userId: $userId, parkingLotName: $parkingLotName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.emailVerifiedAt, emailVerifiedAt) ||
                other.emailVerifiedAt == emailVerifiedAt) &&
            (identical(other.profilePhotoPath, profilePhotoPath) ||
                other.profilePhotoPath == profilePhotoPath) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.parkingLotsId, parkingLotsId) ||
                other.parkingLotsId == parkingLotsId) &&
            (identical(other.gatesId, gatesId) || other.gatesId == gatesId) &&
            (identical(other.shiftsId, shiftsId) ||
                other.shiftsId == shiftsId) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.macAddress, macAddress) ||
                other.macAddress == macAddress) &&
            (identical(other.allowMac, allowMac) ||
                other.allowMac == allowMac) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.operations, operations) ||
                other.operations == operations) &&
            (identical(other.purpose, purpose) || other.purpose == purpose) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.parkingLotName, parkingLotName) ||
                other.parkingLotName == parkingLotName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        firstName,
        lastName,
        email,
        emailVerifiedAt,
        profilePhotoPath,
        isActive,
        parkingLotsId,
        gatesId,
        shiftsId,
        description,
        macAddress,
        allowMac,
        createdAt,
        updatedAt,
        name,
        operations,
        purpose,
        userId,
        parkingLotName
      ]);

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      __$$UserImplCopyWithImpl<_$UserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserImplToJson(
      this,
    );
  }
}

abstract class _User implements User {
  const factory _User(
      {required final int id,
      @JsonKey(name: 'first_name') required final String firstName,
      @JsonKey(name: 'last_name') required final String lastName,
      required final String email,
      @JsonKey(name: 'email_verified_at') final String? emailVerifiedAt,
      @JsonKey(name: 'profile_photo_path') final String? profilePhotoPath,
      @JsonKey(name: 'is_active') required final int isActive,
      @JsonKey(name: 'parking_lots_id') required final int parkingLotsId,
      @JsonKey(name: 'gates_id') required final int gatesId,
      @JsonKey(name: 'shifts_id') final int? shiftsId,
      final String? description,
      @JsonKey(name: 'mac_address') final String? macAddress,
      @JsonKey(name: 'allow_mac') required final int allowMac,
      @JsonKey(name: 'created_at') required final String createdAt,
      @JsonKey(name: 'updated_at') required final String updatedAt,
      required final String name,
      required final String operations,
      required final String purpose,
      @JsonKey(name: 'user_id') required final int userId,
      @JsonKey(name: 'parking_lot_name')
      required final String parkingLotName}) = _$UserImpl;

  factory _User.fromJson(Map<String, dynamic> json) = _$UserImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'first_name')
  String get firstName;
  @override
  @JsonKey(name: 'last_name')
  String get lastName;
  @override
  String get email;
  @override
  @JsonKey(name: 'email_verified_at')
  String? get emailVerifiedAt;
  @override
  @JsonKey(name: 'profile_photo_path')
  String? get profilePhotoPath;
  @override
  @JsonKey(name: 'is_active')
  int get isActive;
  @override
  @JsonKey(name: 'parking_lots_id')
  int get parkingLotsId;
  @override
  @JsonKey(name: 'gates_id')
  int get gatesId;
  @override
  @JsonKey(name: 'shifts_id')
  int? get shiftsId;
  @override
  String? get description;
  @override
  @JsonKey(name: 'mac_address')
  String? get macAddress;
  @override
  @JsonKey(name: 'allow_mac')
  int get allowMac;
  @override
  @JsonKey(name: 'created_at')
  String get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  String get updatedAt;
  @override
  String get name;
  @override
  String get operations;
  @override
  String get purpose;
  @override
  @JsonKey(name: 'user_id')
  int get userId;
  @override
  @JsonKey(name: 'parking_lot_name')
  String get parkingLotName;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
