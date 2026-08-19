import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../controller/product_details_cubit.dart';
import '../controller/product_details_state.dart';
import 'widgets/add_to_cart_bottom_bar.dart';
import 'widgets/product_header_gallery.dart';
import 'widgets/product_info_section.dart';

class ProductDetailsView extends StatefulWidget {
  const ProductDetailsView({super.key});

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  int _quantity = 1;
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
          builder: (context, state) {
            if (state is ProductDetailsInitial || state is ProductDetailsLoading) {
              return Center(
                child: CircularProgressIndicator(color: context.primaryThemeColor),
              );
            }

            if (state is ProductDetailsError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                    SizedBox(height: 16.h),
                    Text(state.message),
                  ],
                ),
              );
            }

            if (state is ProductDetailsLoaded) {
              final product = state.product;
              final relatedProducts = state.relatedProducts;
              final price = product.discountPrice ?? product.price;
              _isFavorite = product.isFavorite;

              return Stack(
                children: [
                  ListView(
                    padding: EdgeInsets.only(bottom: 100.h),
                    children: [
                      ProductHeaderGallery(
                        imageUrls: product.imageUrls,
                        isFavorite: _isFavorite,
                        onFavoriteToggle: () {
                          setState(() {
                            _isFavorite = !_isFavorite;
                          });
                        },
                      ),
                      
                      ProductInfoSection(
                        product: product,
                        relatedProducts: relatedProducts,
                        price: price,
                        quantity: _quantity,
                        onQuantityIncrement: () => setState(() => _quantity++),
                        onQuantityDecrement: () => setState(() {
                          if (_quantity > 1) _quantity--;
                        }),
                      ),
                    ],
                  ),
                  
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: AddToCartBottomBar(
                      productId: product.id,
                      price: price,
                      quantity: _quantity,
                    ),
                  ),
                ],
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
