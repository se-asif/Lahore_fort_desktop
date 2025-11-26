import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'visiting_data_list.freezed.dart';
part 'visiting_data_list.g.dart';

@freezed
class VisitingDataList with _$VisitingDataList {
  const factory VisitingDataList({
    int? id,
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
    required int isUploaded,
    String? billNo,
  }) = _VisitingDataList;

  factory VisitingDataList.fromJson(Map<String, dynamic> json) =>
      _$VisitingDataListFromJson(json);

  Map<String, dynamic> toJson() {
    return {
      "typeWiseData": typeWiseData, // Convert to JSON string
      "paymentId": paymentId,
      "totalPersons": totalPersons,
      "totalAmount": totalAmount,
      "gateId": gateId,
      "parkingLotId": parkingLotId,
      "userId": userId,
      "date": date,
      "userName": userName,
      "gateName": gateName,
      "ticketingPoint": ticketingPoint,
      "transactionUniqueId": transactionUniqueId,
      "userMacId": userMacId,
      "isUploaded": isUploaded,
      "id": id,
      "bill_no" : billNo
    };
  }
}

/// **Helper Functions for JSON Encoding**
List<Map<String, dynamic>> _decodeList(String? jsonStr) {
  if (jsonStr == null || jsonStr.isEmpty) return [];
  return List<Map<String, dynamic>>.from(json.decode(jsonStr));
}

String _encodeList(List<Map<String, dynamic>> list) {
  return json.encode(list);
}