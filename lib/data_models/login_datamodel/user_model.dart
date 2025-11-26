import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserResponse with _$UserResponse {
  const factory UserResponse({
    User? user, // Ensuring user is required since it's always present
    String? error,
    String? message,
  }) = _UserResponse;

  factory UserResponse.fromJson(Map<String, dynamic> json) => _$UserResponseFromJson(json);
}

@freezed
class User with _$User {
  const factory User({
    required int id,
    @JsonKey(name: 'first_name') required String firstName,
    @JsonKey(name: 'last_name') required String lastName,
    required String email,
    @JsonKey(name: 'email_verified_at') String? emailVerifiedAt,
    @JsonKey(name: 'profile_photo_path') String? profilePhotoPath,
    @JsonKey(name: 'is_active') required int isActive,
    @JsonKey(name: 'parking_lots_id') required int parkingLotsId,
    @JsonKey(name: 'gates_id') required int gatesId,
    @JsonKey(name: 'shifts_id') int? shiftsId,
    String? description,
    @JsonKey(name: 'mac_address') String? macAddress,
    @JsonKey(name: 'allow_mac') required int allowMac,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') required String updatedAt,
    required String name,
    required String operations,
    required String purpose,
    @JsonKey(name: 'user_id') required int userId,
    @JsonKey(name: 'parking_lot_name') required String parkingLotName,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
