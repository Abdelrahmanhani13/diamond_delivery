import 'package:equatable/equatable.dart';

class LookupItem extends Equatable {
  final String id;
  final String nameEn;
  final String nameAr;

  const LookupItem({
    required this.id,
    required this.nameEn,
    required this.nameAr,
  });

  @override
  List<Object?> get props => [id, nameEn, nameAr];
}
