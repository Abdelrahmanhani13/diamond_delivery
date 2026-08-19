import 'package:equatable/equatable.dart';

class VendorCategory extends Equatable {
  final String id;
  final String nameArabic;
  final String nameEnglish;

  const VendorCategory({
    required this.id,
    required this.nameArabic,
    required this.nameEnglish,
  });

  @override
  List<Object?> get props => [id, nameArabic, nameEnglish];
}
