import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/products_use_cases.dart';
import 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  final GetProductByIdUseCase getProductByIdUseCase;
  final GetRelatedProductsUseCase getRelatedProductsUseCase;

  ProductDetailsCubit({
    required this.getProductByIdUseCase,
    required this.getRelatedProductsUseCase,
  }) : super(ProductDetailsInitial());

  Future<void> fetchProductDetails(String productId) async {
    emit(ProductDetailsLoading());

    final productResult = await getProductByIdUseCase(productId);
    
    productResult.fold(
      (failure) => emit(ProductDetailsError(failure.message)),
      (product) async {
        final relatedResult = await getRelatedProductsUseCase(productId);
        relatedResult.fold(
          (failure) => emit(ProductDetailsError(failure.message)), // Or handle silently
          (relatedProducts) => emit(ProductDetailsLoaded(
            product: product,
            relatedProducts: relatedProducts,
          )),
        );
      },
    );
  }
}
