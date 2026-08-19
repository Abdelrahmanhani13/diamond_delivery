import 'package:diamond_customer/features/addresses/domain/entities/address_domain_entity.dart';
import 'package:diamond_customer/features/addresses/domain/usecases/add_address_use_case.dart';
import 'package:diamond_customer/features/addresses/domain/usecases/update_address_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'add_edit_address_state.dart';

class AddEditAddressCubit extends Cubit<AddEditAddressState> {
  final AddAddressUseCase _addAddressUseCase;
  final UpdateAddressUseCase _updateAddressUseCase;

  AddEditAddressCubit(this._addAddressUseCase, this._updateAddressUseCase)
    : super(AddEditAddressInitial());

  Future<void> submit(Address address) async {
    emit(AddEditAddressLoading());

    final result = address.id.isEmpty
        ? await _addAddressUseCase(address)
        : await _updateAddressUseCase(address);

    result.fold(
      (failure) => emit(AddEditAddressError(failure.message)),
      (saved) => emit(AddEditAddressSuccess(saved)),
    );
  }
}
