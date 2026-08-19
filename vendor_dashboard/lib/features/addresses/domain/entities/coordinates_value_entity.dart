import 'package:equatable/equatable.dart';

/// إحداثيات خام (مش مربوطة بأي مكتبة خريطة) — بنستخدمها في طبقة
/// الـ domain عشان تفضل مستقلة عن flutter_map / latlong2.
class Coordinates extends Equatable {
  final double latitude;
  final double longitude;

  const Coordinates({required this.latitude, required this.longitude});

  @override
  List<Object?> get props => [latitude, longitude];
}
