import '../../../../core/utils/either.dart';
import '../../../../core/errors/failures.dart';
import '../entities/search_data.dart';

abstract class SearchRepo {
  Future<Either<Failure, SearchData>> search(String query);
}
