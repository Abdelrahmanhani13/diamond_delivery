import '../../../../core/errors/failures.dart';
import '../../../../core/utils/either.dart';
import '../entities/category_entity.dart';

abstract class CategoriesRepo {
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
}
