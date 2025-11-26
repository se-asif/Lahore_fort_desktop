// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TicketCategoryImpl _$$TicketCategoryImplFromJson(Map<String, dynamic> json) =>
    _$TicketCategoryImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      routineCharges: (json['routine_charges'] as num?)?.toInt(),
      image: json['image'] as String?,
      parkingLotsId: (json['parking_lots_id'] as num?)?.toInt(),
      visitorTypeId: (json['visitor_type_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$TicketCategoryImplToJson(
        _$TicketCategoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'routine_charges': instance.routineCharges,
      'image': instance.image,
      'parking_lots_id': instance.parkingLotsId,
      'visitor_type_id': instance.visitorTypeId,
    };

_$TicketCategoriesResponseImpl _$$TicketCategoriesResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$TicketCategoriesResponseImpl(
      catagories: (json['catagories'] as List<dynamic>)
          .map((e) => TicketCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$TicketCategoriesResponseImplToJson(
        _$TicketCategoriesResponseImpl instance) =>
    <String, dynamic>{
      'catagories': instance.catagories,
    };
