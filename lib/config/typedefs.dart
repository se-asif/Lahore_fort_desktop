import '../data_models/location_model/location_model.dart';
typedef DartMap<T> = Map<String, dynamic>;
typedef AgeRange = ({String rangeText, double lowerRange, double upperRange});
typedef PetTaxiAddress = ({
  String street,
  String apt,
  String city,
  LocationModel location
});
