import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_response_model.freezed.dart';
part 'post_response_model.g.dart';

@freezed
class PostResponseModel with _$PostResponseModel {
  const factory PostResponseModel({
    String? success, // ✅ Changed to bool? if the API returns true/false
    String? error,
    String? message,
  }) = _PostResponseModel;

  factory PostResponseModel.fromJson(Map<String, dynamic> json) => _$PostResponseModelFromJson(json);
}
