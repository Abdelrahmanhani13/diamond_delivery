import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/stores_use_cases.dart';
import 'vendor_details_state.dart';

class VendorDetailsCubit extends Cubit<VendorDetailsState> {
  final GetVendorByIdUseCase getVendorByIdUseCase;

  VendorDetailsCubit(this.getVendorByIdUseCase) : super(VendorDetailsInitial());

  Future<void> fetchVendorDetails(String id) async {
    emit(VendorDetailsLoading());
    final result = await getVendorByIdUseCase(id);
    result.fold(
      (failure) => emit(VendorDetailsError(failure.message)),
      (vendor) => emit(VendorDetailsLoaded(vendor)),
    );
  }
}
