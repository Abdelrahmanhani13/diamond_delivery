import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../data/models/order_model.dart';
import '../controller/orders_cubit.dart';
import '../controller/orders_state.dart';
import '../widgets/order_card.dart';
import '../widgets/order_filter_chip.dart';

class OrdersView extends StatelessWidget {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<OrdersCubit>()..fetchOrders(),
      child: const _OrdersViewBody(),
    );
  }
}

class _OrdersViewBody extends StatefulWidget {
  const _OrdersViewBody();

  @override
  State<_OrdersViewBody> createState() => _OrdersViewBodyState();
}

class _OrdersViewBodyState extends State<_OrdersViewBody> {
  int _filterIndex = 0;
  static const _filters = ['الكل', 'قيد التنفيذ', 'مكتمل', 'ملغى'];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<OrdersCubit>().loadNextPage();
    }
  }

  List<OrderModel> _filterOrders(List<OrderModel> orders) {
    if (_filterIndex == 0) return orders;
    return orders.where((order) {
      final status = order.orderStatus.toOrderStatus;
      if (_filterIndex == 1) {
        return status == BackendOrderStatus.pending ||
            status == BackendOrderStatus.accepted ||
            status == BackendOrderStatus.preparing ||
            status == BackendOrderStatus.readyForDelivery ||
            status == BackendOrderStatus.outForDelivery;
      } else if (_filterIndex == 2) {
        return status == BackendOrderStatus.delivered;
      } else if (_filterIndex == 3) {
        return status == BackendOrderStatus.cancelled ||
            status == BackendOrderStatus.rejected;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text('طلباتي', style: AppTextStyles.headingLarge),
                ),
              ),
              SizedBox(height: 14.h),
              SizedBox(
                height: 40.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemCount: _filters.length,
                  separatorBuilder: (_, _) => SizedBox(width: 8.w),
                  itemBuilder: (context, index) => OrderFilterChip(
                    label: _filters[index],
                    selected: _filterIndex == index,
                    onTap: () => setState(() => _filterIndex = index),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Expanded(
                child: BlocBuilder<OrdersCubit, OrdersState>(
                  builder: (context, state) {
                    if (state is OrdersLoading) {
                      return const Center(
                        child: CircularProgressIndicator(color: AppColors.primary),
                      );
                    }

                    if (state is OrdersError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline_rounded, size: 48.sp, color: AppColors.error),
                            Gap(12.h),
                            Text(state.message, style: AppTextStyles.bodyMedium),
                            Gap(12.h),
                            ElevatedButton(
                              onPressed: () => context.read<OrdersCubit>().fetchOrders(refresh: true),
                              child: const Text('إعادة المحاولة'),
                            ),
                          ],
                        ),
                      );
                    }

                    if (state is OrdersLoaded) {
                      final filteredOrders = _filterOrders(state.orders);

                      if (filteredOrders.isEmpty) {
                        return RefreshIndicator(
                          onRefresh: () => context.read<OrdersCubit>().fetchOrders(refresh: true),
                          child: ListView(
                            children: const [
                              SizedBox(height: 100),
                              EmptyStateWidget(
                                title: 'لا توجد طلبات بعد',
                                message: 'عند تقديم طلب جديد سيظهر هنا',
                                icon: Icons.receipt_long_outlined,
                              ),
                            ],
                          ),
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: () => context.read<OrdersCubit>().fetchOrders(refresh: true),
                        child: ListView.separated(
                          controller: _scrollController,
                          padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                          itemCount: filteredOrders.length + (state.isLoadingMore ? 1 : 0),
                          separatorBuilder: (_, _) => SizedBox(height: 14.h),
                          itemBuilder: (context, index) {
                            if (index == filteredOrders.length) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: CircularProgressIndicator(color: AppColors.primary),
                                ),
                              );
                            }
                            final order = filteredOrders[index];
                            return OrderCard(
                              order: order,
                              onDetails: () {
                                context.push(AppRoutes.orderDetails, extra: order.id);
                              },
                            );
                          },
                        ),
                      );
                    }

                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: AppBottomNavBar(
          currentIndex: 1,
          onTap: (index) {
            switch (index) {
              case 0:
                context.go(AppRoutes.profile);
                break;
              case 1:
                context.go(AppRoutes.orders);
                break;
              case 2:
                context.push(AppRoutes.search);
                break;
              case 3:
                context.go(AppRoutes.home);
                break;
            }
          },
        ),
      ),
    );
  }
}
