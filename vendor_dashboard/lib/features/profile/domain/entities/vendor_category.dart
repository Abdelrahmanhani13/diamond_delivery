import 'package:equatable/equatable.dart';

class VendorCategory extends Equatable {
  final String id;
  final String nameArabic;
  final String nameEnglish;
  final String? imageUrl;
  final int displayOrder;

  const VendorCategory({
    required this.id,
    required this.nameArabic,
    required this.nameEnglish,
    this.imageUrl,
    this.displayOrder = 0,
  });

  @override
  List<Object?> get props => [
    id,
    nameArabic,
    nameEnglish,
    imageUrl,
    displayOrder,
  ];
}
