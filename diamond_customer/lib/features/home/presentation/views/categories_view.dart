import 'package:diamond_customer/features/categories/domain/entities/category_entity.dart';
import 'package:diamond_customer/features/categories/presentation/controller/categories_cubit.dart';
import 'package:diamond_customer/features/categories/presentation/controller/categories_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_app_bar.dart';

class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: const CustomAppBar(title: 'جميع التصنيفات'),
        body: BlocBuilder<CategoriesCubit, CategoriesState>(
          builder: (context, state) {
            if (state is CategoriesInitial || state is CategoriesLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            if (state is CategoriesError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: AppColors.error,
                    ),
                    SizedBox(height: 16.h),
                    Text(state.message),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<CategoriesCubit>()
                            ..fetchVendorCategories(),
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              );
            }

            if (state is CategoriesLoaded) {
              final categories = state.categories;

              if (categories.isEmpty) {
                return const Center(child: Text('لا توجد تصنيفات حالياً'));
              }

              return GridView.builder(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 14.h,
                  crossAxisSpacing: 12.w,
                  childAspectRatio: 0.82,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cat = categories[index];

                  return _CategoryTile(
                        category: cat,
                        onTap: () => context.push(
                          AppRoutes.storesList,
                        ), // pass category info via extra later
                      )
                      .animate()
                      .fadeIn(delay: (index * 30).ms, duration: 300.ms)
                      .scale(
                        begin: const Offset(0.92, 0.92),
                        end: const Offset(1, 1),
                        duration: 300.ms,
                        curve: Curves.easeOutBack,
                      );
                },
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category, required this.onTap});

  final CategoryEntity category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: category.imageUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16.r),
                        child: Image.network(
                          category.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Icon(
                        Icons.category,
                        color: AppColors.primary,
                        size: 24.sp,
                      ),
              ),
              SizedBox(height: 10.h),
              Text(
                category.name,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
