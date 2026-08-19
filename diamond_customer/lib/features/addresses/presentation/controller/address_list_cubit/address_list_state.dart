import 'package:diamond_customer/features/addresses/domain/entities/address_domain_entity.dart';
import 'package:equatable/equatable.dart';

abstract class AddressListState extends Equatable {
  const AddressListState();

  @override
  List<Object?> get props => [];
}

class AddressListInitial extends AddressListState {}

/// شاشة تحميل كاملة — بتظهر بس أول ما الشاشة تفتح.
class AddressListLoading extends AddressListState {}

class AddressListLoaded extends AddressListState {
  final List<Address> addresses;

  /// id العنوان اللي بيتم حذفه/تعيينه كافتراضي دلوقتي — بنستخدمه
  /// عشان نعطّل الكارت المعني بس، من غير ما نوقف باقي الشاشة.
  final String? processingAddressId;

  const AddressListLoaded(this.addresses, {this.processingAddressId});

  @override
  List<Object?> get props => [addresses, processingAddressId];
}

/// فشل أول تحميل للقائمة (لسه معندناش أي بيانات نعرضها).
class AddressListError extends AddressListState {
  final String message;

  const AddressListError(this.message);

  @override
  List<Object?> get props => [message];
}

/// فشل عملية حذف/تعيين افتراضي بعد ما القائمة كانت متحمّلة بالفعل —
/// بنفضل نعرض نفس القائمة القديمة ونطلع رسالة خطأ فوقها بدل ما
/// نمسح كل حاجة وترجع الشاشة فاضية.
class AddressListActionError extends AddressListState {
  final List<Address> addresses;
  final String message;

  const AddressListActionError(this.addresses, this.message);

  @override
  List<Object?> get props => [addresses, message];
}
