import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../profile/domain/usecases/get_vendor_categories_use_case.dart';
import 'vendor_categories_state.dart';

class VendorCategoriesCubit extends Cubit<VendorCategoriesState> {
  final GetVendorCategoriesUseCase getVendorCategoriesUseCase;

  VendorCategoriesCubit({required this.getVendorCategoriesUseCase})
    : super(VendorCategoriesInitial());

  Future<void> loadCategories() async {
    emit(VendorCategoriesLoading());
    final result = await getVendorCategoriesUseCase();
    result.fold(
      (failure) => emit(VendorCategoriesError(failure.errMessage)),
      (categories) => emit(VendorCategoriesLoaded(categories)),
    );
  }
}
