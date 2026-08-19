import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_categories_use_case.dart';
import 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  final GetVendorCategoriesUseCase _getCategoriesUseCase;

  CategoriesCubit(this._getCategoriesUseCase) : super(CategoriesInitial());

  Future<void> fetchVendorCategories() async {
    emit(CategoriesLoading());
    final result = await _getCategoriesUseCase();
    result.fold(
      (failure) => emit(CategoriesError(failure.message)),
      (categories) => emit(CategoriesLoaded(categories)),
    );
  }
}
