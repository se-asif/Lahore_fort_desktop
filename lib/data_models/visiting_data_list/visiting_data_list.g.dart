// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visiting_data_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VisitingDataListImpl _$$VisitingDataListImplFromJson(
        Map<String, dynamic> json) =>
    _$VisitingDataListImpl(
      id: (json['id'] as num?)?.toInt(),
      typeWiseData: (json['typeWiseData'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      paymentId: json['paymentId'] as String?,
      totalPersons: json['totalPersons'] as String?,
      totalAmount: json['totalAmount'] as String?,
      gateId: json['gateId'] as String?,
      parkingLotId: json['parkingLotId'] as String?,
      userId: json['userId'] as String?,
      date: json['date'] as String?,
      userName: json['userName'] as String?,
      gateName: json['gateName'] as String?,
      ticketingPoint: json['ticketingPoint'] as String?,
      transactionUniqueId: json['transactionUniqueId'] as String?,
      userMacId: json['userMacId'] as String?,
      isUploaded: (json['isUploaded'] as num).toInt(),
      billNo: json['billNo'] as String?,
    );

Map<String, dynamic> _$$VisitingDataListImplToJson(
        _$VisitingDataListImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'typeWiseData': instance.typeWiseData,
      'paymentId': instance.paymentId,
      'totalPersons': instance.totalPersons,
      'totalAmount': instance.totalAmount,
      'gateId': instance.gateId,
      'parkingLotId': instance.parkingLotId,
      'userId': instance.userId,
      'date': instance.date,
      'userName': instance.userName,
      'gateName': instance.gateName,
      'ticketingPoint': instance.ticketingPoint,
      'transactionUniqueId': instance.transactionUniqueId,
      'userMacId': instance.userMacId,
      'isUploaded': instance.isUploaded,
      'billNo': instance.billNo,
    };
