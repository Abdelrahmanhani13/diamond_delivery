import 'package:equatable/equatable.dart';
import '../../domain/entities/search_data.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final SearchData searchData;

  const SearchLoaded(this.searchData);

  @override
  List<Object?> get props => [searchData];
}

class SearchError extends SearchState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object?> get props => [message];
}
