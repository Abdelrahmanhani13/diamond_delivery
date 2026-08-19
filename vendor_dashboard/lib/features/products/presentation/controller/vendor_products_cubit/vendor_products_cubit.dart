// presentation/controller/products_cubit/vendor_products_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vendor_dashboard/features/products/domain/usecases/change_vendor_product_availability.dart';
import 'package:vendor_dashboard/features/products/domain/usecases/delete_vendor_product_use_case.dart';
import 'package:vendor_dashboard/features/products/domain/usecases/get_vendor_product_use_case.dart';
import '../../../domain/entities/vendor_product.dart';
import 'vendor_products_state.dart';

class VendorProductsCubit extends Cubit<VendorProductsState> {
  final GetVendorProductsUseCase getProductsUseCase;
  final ChangeVendorProductAvailabilityUseCase changeAvailabilityUseCase;
  final DeleteVendorProductUseCase deleteProductUseCase;

  static const int _pageSize = 20;
  int _page = 1;

  VendorProductsCubit({
    required this.getProductsUseCase,
    required this.changeAvailabilityUseCase,
    required this.deleteProductUseCase,
  }) : super(VendorProductsInitial());

  /// [refresh] = true بيبدأ من صفحة 1 تاني (pull-to-refresh / أول تحميل).
  /// من غيرها، بتكمل الصفحة اللي بعدها (infinite scroll).
  Future<void> fetchProducts({bool refresh = false}) async {
    final currentState = state;

    if (refresh) {
      _page = 1;
      emit(VendorProductsLoading());
    } else if (currentState is VendorProductsLoaded) {
      if (currentState.hasReachedMax) return;
      _page++;
    } else {
      emit(VendorProductsLoading());
    }

    final result = await getProductsUseCase(page: _page, pageSize: _pageSize);

    result.fold((failure) => emit(VendorProductsError(failure.errMessage)), (
      page,
    ) {
      final previousProducts =
          (!refresh && currentState is VendorProductsLoaded)
          ? currentState.products
          : <VendorProduct>[];

      emit(
        VendorProductsLoaded(
          products: [...previousProducts, ...page.products],
          hasReachedMax: !page.hasNextPage,
        ),
      );
    });
  }

  Future<void> changeAvailability(String productId, bool isAvailable) async {
    final currentState = state;
    if (currentState is! VendorProductsLoaded) return;

    // Optimistic update عشان الـ Switch يستجيب فورًا.
    final optimistic = currentState.products
        .map(
          (p) => p.id == productId ? p.copyWith(isAvailable: isAvailable) : p,
        )
        .toList();
    emit(currentState.copyWith(products: optimistic));

    final result = await changeAvailabilityUseCase(
      id: productId,
      isAvailable: isAvailable,
    );

    result.fold(
      // فشل الطلب → نرجّع الحالة الأصلية قبل التعديل.
      (failure) => emit(currentState),
      (_) {},
    );
  }

  Future<void> deleteProduct(String productId) async {
    final currentState = state;
    if (currentState is! VendorProductsLoaded) return;

    final result = await deleteProductUseCase(productId);

    result.fold((failure) => emit(VendorProductsError(failure.errMessage)), (
      _,
    ) {
      final updated = currentState.products
          .where((p) => p.id != productId)
          .toList();
      emit(currentState.copyWith(products: updated));
    });
  }
}
