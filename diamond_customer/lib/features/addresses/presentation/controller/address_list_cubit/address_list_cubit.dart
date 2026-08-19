import 'package:diamond_customer/features/addresses/domain/entities/address_domain_entity.dart';
import 'package:diamond_customer/features/addresses/domain/usecases/delete_address_use_case.dart';
import 'package:diamond_customer/features/addresses/domain/usecases/get_address_use_case.dart';
import 'package:diamond_customer/features/addresses/domain/usecases/set_default_address_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'address_list_state.dart';

class AddressListCubit extends Cubit<AddressListState> {
  final GetAddressesUseCase _getAddressesUseCase;
  final DeleteAddressUseCase _deleteAddressUseCase;
  final SetDefaultAddressUseCase _setDefaultAddressUseCase;

  AddressListCubit(
    this._getAddressesUseCase,
    this._deleteAddressUseCase,
    this._setDefaultAddressUseCase,
  ) : super(AddressListInitial());

  Future<void> loadAddresses() async {
    emit(AddressListLoading());
    final result = await _getAddressesUseCase();
    result.fold(
      (failure) => emit(AddressListError(failure.message)),
      (addresses) => emit(AddressListLoaded(addresses)),
    );
  }

  Future<void> deleteAddress(String id) async {
    final addresses = _currentAddresses();
    emit(AddressListLoaded(addresses, processingAddressId: id));

    final result = await _deleteAddressUseCase(id);
    result.fold(
      (failure) => emit(AddressListActionError(addresses, failure.message)),
      (_) =>
          emit(AddressListLoaded(addresses.where((a) => a.id != id).toList())),
    );
  }

  /// بنحدّث العلم isDefault محلياً بعد النجاح بدل ما نعمل reload كامل
  /// للقائمة من السيرفر تاني — أسرع وتجربة استخدام أنعم.
  Future<void> setDefaultAddress(String id) async {
    final addresses = _currentAddresses();
    emit(AddressListLoaded(addresses, processingAddressId: id));

    final result = await _setDefaultAddressUseCase(id);
    result.fold(
      (failure) => emit(AddressListActionError(addresses, failure.message)),
      (_) => emit(
        AddressListLoaded(
          addresses.map((a) => a.copyWith(isDefault: a.id == id)).toList(),
        ),
      ),
    );
  }

  List<Address> _currentAddresses() {
    final current = state;
    if (current is AddressListLoaded) return current.addresses;
    if (current is AddressListActionError) return current.addresses;
    return const [];
  }
}
