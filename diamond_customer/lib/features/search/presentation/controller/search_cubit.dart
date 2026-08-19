import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/search_use_case.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchUseCase searchUseCase;

  SearchCubit(this.searchUseCase) : super(SearchInitial());

  Future<void> search(String query) async {
    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }
    
    emit(SearchLoading());
    final result = await searchUseCase(query);
    result.fold(
      (failure) => emit(SearchError(failure.message)),
      (searchData) => emit(SearchLoaded(searchData)),
    );
  }
}
