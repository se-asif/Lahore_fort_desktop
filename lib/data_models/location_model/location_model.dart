import 'package:freezed_annotation/freezed_annotation.dart';

import '../../config/typedefs.dart';



part 'location_model.freezed.dart';
part 'location_model.g.dart';

@freezed
class LocationModel with _$LocationModel {
  const factory LocationModel({
    required double latitude,
    required double longitude,
    required String? countryCode,
  }) = _LocationModel;

  factory LocationModel.fromJson(DartMap json) => _$LocationModelFromJson(json);
}
