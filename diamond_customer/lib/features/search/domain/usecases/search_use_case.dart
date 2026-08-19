import '../../../../core/utils/either.dart';
import '../../../../core/errors/failures.dart';
import '../entities/search_data.dart';
import '../repos/search_repo.dart';

class SearchUseCase {
  final SearchRepo repo;

  SearchUseCase(this.repo);

  Future<Either<Failure, SearchData>> call(String query) async {
    return await repo.search(query);
  }
}
