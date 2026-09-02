import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vendor_dashboard/core/services/snackbar_service.dart';
import 'package:vendor_dashboard/core/theme/vendor_colors.dart';
import 'package:vendor_dashboard/core/theme/vendor_text_styles.dart';
import 'package:vendor_dashboard/core/widgets/empty_state_widget.dart';
import 'package:vendor_dashboard/core/widgets/shimmer_loading.dart';
import '../controller/vendor_orders_cubit.dart';
import '../controller/vendor_orders_state.dart';
import '../widgets/order_item_card.dart';
import '../widgets/rejection_reason_dialog.dart';
import 'vendor_order_details_page.dart';

class VendorOrdersListPage extends StatefulWidget {
  const VendorOrdersListPage({super.key});

  @override
  State<VendorOrdersListPage> createState() => _VendorOrdersListPageState();
}

class _VendorOrdersListPageState extends State<VendorOrdersListPage> {
  final ScrollController _scrollController = ScrollController();
  int _selectedTabIndex = 0;

  final List<({String label, String? status})> _tabs = const [
    (label: 'الكل', status: null),
    (label: 'الجديدة', status: 'available'),
    (label: 'التجهيز', status: 'preparing'),
    (label: 'الجاهزة', status: 'ready'),
    (label: 'المكتملة', status: 'delivered'),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VendorOrdersCubit>().fetchOrders(status: null);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<VendorOrdersCubit>().loadMoreOrders();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: VendorColors.background,
        appBar: AppBar(
          title: Text('طلبات المتجر', style: VendorTextStyles.titleLarge),
          centerTitle: false,
          elevation: 0,
          backgroundColor: VendorColors.surface,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: SizedBox(
              height: 44,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _tabs.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final isSelected = _selectedTabIndex == index;
                  return ChoiceChip(
                    label: Text(_tabs[index].label),
                    selected: isSelected,
                    selectedColor: VendorColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : VendorColors.textPrimary,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                    backgroundColor: VendorColors.surface,
                    onSelected: (_) {
                      setState(() {
                        _selectedTabIndex = index;
                      });
                      context.read<VendorOrdersCubit>().fetchOrders(
                        status: _tabs[index].status,
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
        body: BlocConsumer<VendorOrdersCubit, VendorOrdersState>(
          listener: (context, state) {
            if (state is VendorOrdersLoaded) {
              if (state.actionSuccessMessage != null) {
                SnackbarService.showSuccess(state.actionSuccessMessage!);
              }
              if (state.actionError != null) {
                SnackbarService.showError(state.actionError!);
              }
            }
          },
          builder: (context, state) {
            if (state is VendorOrdersLoading) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: ShimmerLoadingList(),
              );
            }

            if (state is VendorOrdersError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message, style: VendorTextStyles.bodyLarge),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        context.read<VendorOrdersCubit>().fetchOrders(
                          status: _tabs[_selectedTabIndex].status,
                        );
                      },
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              );
            }

            if (state is VendorOrdersLoaded) {
              if (state.orders.isEmpty) {
                return RefreshIndicator(
                  onRefresh: () =>
                      context.read<VendorOrdersCubit>().fetchOrders(
                        status: _tabs[_selectedTabIndex].status,
                        isRefresh: true,
                      ),
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const [
                      SizedBox(height: 100),
                      EmptyStateWidget(
                        title: 'لا توجد طلبات',
                        message: 'لم يتم العثور على طلبات في هذا القسم.',
                        icon: Icons.receipt_long_outlined,
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => context.read<VendorOrdersCubit>().fetchOrders(
                  status: _tabs[_selectedTabIndex].status,
                  isRefresh: true,
                ),
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: state.orders.length + (state.hasNextPage ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == state.orders.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    }

                    final order = state.orders[index];
                    final isItemLoading =
                        state.isActionLoading &&
                        state.actionOrderId == order.id;

                    return OrderItemCard(
                      order: order,
                      isActionLoading: isItemLoading,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: context.read<VendorOrdersCubit>(),
                              child: VendorOrderDetailsPage(order: order),
                            ),
                          ),
                        );
                      },
                      onActionTap: (action) async {
                        final cubit = context.read<VendorOrdersCubit>();
                        if (action == 'accept') {
                          await cubit.acceptOrder(order.id);
                        } else if (action == 'reject') {
                          final reason = await RejectionReasonDialog.show(
                            context,
                          );
                          if (reason != null && reason.isNotEmpty) {
                            await cubit.rejectOrder(order.id, reason);
                          }
                        } else if (action == 'ready') {
                          await cubit.readyOrder(order.id);
                        }
                      },
                    );
                  },
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
