import '../../../../core/errors/failures.dart';
import '../../../../core/utils/either.dart';
import '../entities/category_entity.dart';
import '../repos/categories_repo.dart';

class GetVendorCategoriesUseCase {
  final CategoriesRepo repo;

  GetVendorCategoriesUseCase(this.repo);

  Future<Either<Failure, List<CategoryEntity>>> call() async {
    return await repo.getCategories();
  }
}
