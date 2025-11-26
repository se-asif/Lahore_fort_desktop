import 'package:freezed_annotation/freezed_annotation.dart';

part 'ticket_category_model.freezed.dart';
part 'ticket_category_model.g.dart';

@freezed
class TicketCategory with _$TicketCategory {
  const factory TicketCategory({
    required int id,
    required String name,
    @JsonKey(name: 'routine_charges') int? routineCharges,
    String? image,
    @JsonKey(name: 'parking_lots_id')  int? parkingLotsId,
    @JsonKey(name: 'visitor_type_id')  int? visitorTypeId,
  }) = _TicketCategory;

  factory TicketCategory.fromJson(Map<String, dynamic> json) => _$TicketCategoryFromJson(json);
}

@freezed
class TicketCategoriesResponse with _$TicketCategoriesResponse {
  const factory TicketCategoriesResponse({
    required List<TicketCategory> catagories,
  }) = _TicketCategoriesResponse;

  factory TicketCategoriesResponse.fromJson(Map<String, dynamic> json) => _$TicketCategoriesResponseFromJson(json);
}
