import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/localization/app_localizations.dart';
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
    final filters = [
      context.tr('all'),
      context.tr('inProgress'),
      context.tr('completed'),
      context.tr('cancelled'),
    ];

    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  context.tr('orders'),
                  style: AppTextStyles.headingLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.textPrimaryColor,
                  ),
                ),
              ),
            ),
            SizedBox(height: 14.h),
            SizedBox(
              height: 40.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: filters.length,
                separatorBuilder: (context, index) => SizedBox(width: 8.w),
                itemBuilder: (context, index) {
                  return OrderFilterChip(
                    label: filters[index],
                    selected: _filterIndex == index,
                    onTap: () => setState(() => _filterIndex = index),
                  );
                },
              ),
            ),
            SizedBox(height: 14.h),
            Expanded(
              child: BlocBuilder<OrdersCubit, OrdersState>(
                builder: (context, state) {
                  if (state is OrdersLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: context.primaryThemeColor,
                      ),
                    );
                  }

                  if (state is OrdersError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 48.sp,
                            color: AppColors.error,
                          ),
                          SizedBox(height: 16.h),
                          Text(state.message),
                          SizedBox(height: 16.h),
                          ElevatedButton(
                            onPressed: () =>
                                context.read<OrdersCubit>().fetchOrders(),
                            child: Text(context.tr('retry')),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is OrdersLoaded) {
                    final filtered = _filterOrders(state.orders);

                    if (filtered.isEmpty) {
                      return RefreshIndicator(
                        onRefresh: () =>
                            context.read<OrdersCubit>().fetchOrders(),
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Container(
                            height: 400.h,
                            alignment: Alignment.center,
                            child: EmptyStateWidget(
                              title: context.tr('noOrdersYet'),
                              message: context.tr('noOrdersMessage'),
                              icon: Icons.receipt_long_outlined,
                            ),
                          ),
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () =>
                          context.read<OrdersCubit>().fetchOrders(),
                      child: ListView.separated(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.all(16.w),
                        itemCount:
                            filtered.length + (state.isLoadingMore ? 1 : 0),
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 12.h),
                        itemBuilder: (context, index) {
                          if (index == filtered.length) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: context.primaryThemeColor,
                                ),
                              ),
                            );
                          }

                          final order = filtered[index];
                          return OrderCard(
                            order: order,
                            onTap: () => context.push(
                              AppRoutes.orderDetails,
                              extra: order.id,
                            ),
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
    );
  }
}
