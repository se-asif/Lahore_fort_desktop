// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserResponseImpl _$$UserResponseImplFromJson(Map<String, dynamic> json) =>
    _$UserResponseImpl(
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      error: json['error'] as String?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$$UserResponseImplToJson(_$UserResponseImpl instance) =>
    <String, dynamic>{
      'user': instance.user,
      'error': instance.error,
      'message': instance.message,
    };

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      id: (json['id'] as num).toInt(),
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      emailVerifiedAt: json['email_verified_at'] as String?,
      profilePhotoPath: json['profile_photo_path'] as String?,
      isActive: (json['is_active'] as num).toInt(),
      parkingLotsId: (json['parking_lots_id'] as num).toInt(),
      gatesId: (json['gates_id'] as num).toInt(),
      shiftsId: (json['shifts_id'] as num?)?.toInt(),
      description: json['description'] as String?,
      macAddress: json['mac_address'] as String?,
      allowMac: (json['allow_mac'] as num).toInt(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      name: json['name'] as String,
      operations: json['operations'] as String,
      purpose: json['purpose'] as String,
      userId: (json['user_id'] as num).toInt(),
      parkingLotName: json['parking_lot_name'] as String,
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'email': instance.email,
      'email_verified_at': instance.emailVerifiedAt,
      'profile_photo_path': instance.profilePhotoPath,
      'is_active': instance.isActive,
      'parking_lots_id': instance.parkingLotsId,
      'gates_id': instance.gatesId,
      'shifts_id': instance.shiftsId,
      'description': instance.description,
      'mac_address': instance.macAddress,
      'allow_mac': instance.allowMac,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'name': instance.name,
      'operations': instance.operations,
      'purpose': instance.purpose,
      'user_id': instance.userId,
      'parking_lot_name': instance.parkingLotName,
    };
