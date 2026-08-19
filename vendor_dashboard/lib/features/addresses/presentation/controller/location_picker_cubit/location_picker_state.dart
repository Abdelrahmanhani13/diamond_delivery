import 'package:equatable/equatable.dart';
import 'package:vendor_dashboard/features/addresses/domain/entities/coordinates_value_entity.dart';
import 'package:vendor_dashboard/features/addresses/domain/entities/geocoded_address_entity_representing_a_reverse_forward_geocoding_result.dart';

abstract class LocationPickerState extends Equatable {
  const LocationPickerState();

  @override
  List<Object?> get props => [];
}

class LocationPickerInitial extends LocationPickerState {}

/// بيظهر أول ما نجيب موقع المستخدم الحالي أو أول reverse geocode.
/// بعد كده الشاشة بتفضل على [LocationPickerLoaded] وبتحدّث نفسها
/// مباشرة بدل ما ترجع تاني لحالة تحميل كاملة الشاشة.
class LocationPickerLoading extends LocationPickerState {}

class LocationPickerLoaded extends LocationPickerState {
  final Coordinates coordinates;
  final GeocodedAddress address;
  final List<GeocodedAddress> searchResults;
  final bool isSearching;

  const LocationPickerLoaded({
    required this.coordinates,
    required this.address,
    this.searchResults = const [],
    this.isSearching = false,
  });

  LocationPickerLoaded copyWith({
    Coordinates? coordinates,
    GeocodedAddress? address,
    List<GeocodedAddress>? searchResults,
    bool? isSearching,
  }) {
    return LocationPickerLoaded(
      coordinates: coordinates ?? this.coordinates,
      address: address ?? this.address,
      searchResults: searchResults ?? this.searchResults,
      isSearching: isSearching ?? this.isSearching,
    );
  }

  @override
  List<Object?> get props => [coordinates, address, searchResults, isSearching];
}

class LocationPickerError extends LocationPickerState {
  final String message;

  const LocationPickerError(this.message);

  @override
  List<Object?> get props => [message];
}
