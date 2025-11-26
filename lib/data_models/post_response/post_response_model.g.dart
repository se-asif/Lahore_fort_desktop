// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostResponseModelImpl _$$PostResponseModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PostResponseModelImpl(
      success: json['success'] as String?,
      error: json['error'] as String?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$$PostResponseModelImplToJson(
        _$PostResponseModelImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'error': instance.error,
      'message': instance.message,
    };
