import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vendor_dashboard/core/services/snackbar_service.dart';
import 'package:vendor_dashboard/core/theme/vendor_colors.dart';
import 'package:vendor_dashboard/core/theme/vendor_text_styles.dart';
import '../../domain/entities/vendor_order.dart';
import '../controller/vendor_orders_cubit.dart';
import '../controller/vendor_orders_state.dart';
import '../widgets/order_customer_info_card.dart';
import '../widgets/order_details_header_card.dart';
import '../widgets/order_summary_card.dart';
import '../widgets/rejection_reason_dialog.dart';

class VendorOrderDetailsPage extends StatefulWidget {
  final VendorOrder order;

  const VendorOrderDetailsPage({super.key, required this.order});

  @override
  State<VendorOrderDetailsPage> createState() => _VendorOrderDetailsPageState();
}

class _VendorOrderDetailsPageState extends State<VendorOrderDetailsPage> {
  late VendorOrder _currentOrder;

  @override
  void initState() {
    super.initState();
    _currentOrder = widget.order;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: VendorColors.background,
        appBar: AppBar(
          title: Text(
            'تفاصيل الطلب #${_currentOrder.orderNumber}',
            style: VendorTextStyles.titleLarge,
          ),
          elevation: 0,
          backgroundColor: VendorColors.surface,
        ),
        body: BlocListener<VendorOrdersCubit, VendorOrdersState>(
          listener: (context, state) {
            if (state is VendorOrdersLoaded) {
              if (state.actionSuccessMessage != null) {
                SnackbarService.showSuccess(state.actionSuccessMessage!);
              }
              if (state.actionError != null) {
                SnackbarService.showError(state.actionError!);
              }
              final updated = state.orders.firstWhere(
                (o) => o.id == _currentOrder.id,
                orElse: () => _currentOrder,
              );
              setState(() {
                _currentOrder = updated;
              });
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OrderDetailsHeaderCard(order: _currentOrder),
                const SizedBox(height: 16),
                OrderCustomerInfoCard(order: _currentOrder),
                const SizedBox(height: 16),
                if (_currentOrder.address != null) ...[
                  _buildAddressCard(),
                  const SizedBox(height: 16),
                ],
                _buildItemsList(),
                const SizedBox(height: 16),
                OrderSummaryCard(order: _currentOrder),
                const SizedBox(height: 24),
                _buildActionButtons(context),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddressCard() {
    final address = _currentOrder.address!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: VendorColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('عنوان التوصيل', style: VendorTextStyles.titleMedium),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 20,
                color: VendorColors.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  address.formattedAddress,
                  style: VendorTextStyles.bodyMedium,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItemsList() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: VendorColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'عناصر الطلب (${_currentOrder.items.length})',
            style: VendorTextStyles.titleMedium,
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _currentOrder.items.length,
            separatorBuilder: (_, _) => const Divider(height: 16),
            itemBuilder: (context, index) {
              final item = _currentOrder.items[index];
              return Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: VendorColors.greyLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.inventory_2_outlined,
                      color: VendorColors.grey,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.productNameArabic,
                          style: VendorTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${item.unitPrice.toStringAsFixed(2)} د.أ × ${item.quantity}',
                          style: VendorTextStyles.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${item.totalPrice.toStringAsFixed(2)} د.أ',
                    style: VendorTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: VendorColors.primary,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final status = _currentOrder.orderStatus.toLowerCase();
    final isActionLoading = context.select<VendorOrdersCubit, bool>(
      (cubit) =>
          cubit.state is VendorOrdersLoaded &&
          (cubit.state as VendorOrdersLoaded).isActionLoading &&
          (cubit.state as VendorOrdersLoaded).actionOrderId == _currentOrder.id,
    );

    if (isActionLoading) {
      return const Center(
        child: CircularProgressIndicator(color: VendorColors.primary),
      );
    }

    if (status == 'available' || status == 'pending') {
      return Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () => context.read<VendorOrdersCubit>().acceptOrder(
                _currentOrder.id,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: VendorColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'قبول الطلب',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton(
              onPressed: () async {
                final reason = await RejectionReasonDialog.show(context);
                if (reason != null && reason.isNotEmpty && context.mounted) {
                  context.read<VendorOrdersCubit>().rejectOrder(
                    _currentOrder.id,
                    reason,
                  );
                }
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: VendorColors.error),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'رفض الطلب',
                style: TextStyle(
                  color: VendorColors.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      );
    }

    if (status == 'preparing') {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () =>
              context.read<VendorOrdersCubit>().readyOrder(_currentOrder.id),
          style: ElevatedButton.styleFrom(
            backgroundColor: VendorColors.success,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'تحديد كجاهز للتسليم',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
