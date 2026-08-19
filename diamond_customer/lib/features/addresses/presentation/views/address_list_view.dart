import 'package:diamond_customer/features/addresses/domain/entities/address_domain_entity.dart';
import 'package:diamond_customer/features/addresses/presentation/controller/address_list_cubit/address_list_cubit.dart';
import 'package:diamond_customer/features/addresses/presentation/controller/address_list_cubit/address_list_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/loading_widget.dart';

import '../widgets/address_card.dart';

/// شاشة "عناويني" — بتتفتح من البروفايل أو من الـ Checkout.
class AddressListView extends StatelessWidget {
  const AddressListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AddressListCubit>()..loadAddresses(),
      child: const _AddressListBody(),
    );
  }
}

class _AddressListBody extends StatelessWidget {
  const _AddressListBody();

  Future<void> _confirmDelete(BuildContext context, Address address) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('حذف العنوان'),
          content: Text('هل أنت متأكد من حذف "${address.label}"؟'),
          actions: [
            TextButton(
              onPressed: () => dialogContext.pop(false),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () => dialogContext.pop(true),
              child: const Text('حذف', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
    if (confirmed == true && context.mounted) {
      context.read<AddressListCubit>().deleteAddress(address.id);
    }
  }

  Future<void> _editAddress(BuildContext context, Address address) async {
    final updated = await context.push<Address>(
      AppRoutes.editAddress,
      extra: address,
    );
    if (updated != null && context.mounted) {
      context.read<AddressListCubit>().loadAddresses();
    }
  }

  Future<void> _addAddress(BuildContext context) async {
    final added = await context.push<Address>(AppRoutes.addAddress);
    if (added != null && context.mounted) {
      context.read<AddressListCubit>().loadAddresses();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: const CustomAppBar(title: 'عناويني'),
        body: BlocConsumer<AddressListCubit, AddressListState>(
          listener: (context, state) {
            if (state is AddressListActionError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is AddressListLoading || state is AddressListInitial) {
              return const LoadingWidget();
            }
            if (state is AddressListError) {
              return EmptyStateWidget(
                title: state.message,
                icon: Icons.error_outline_rounded,
              );
            }

            final addresses = switch (state) {
              AddressListLoaded(:final addresses) => addresses,
              AddressListActionError(:final addresses) => addresses,
              _ => const <Address>[],
            };
            final processingId = state is AddressListLoaded
                ? state.processingAddressId
                : null;

            if (addresses.isEmpty) {
              return const EmptyStateWidget(
                title: 'لا توجد عناوين محفوظة',
                icon: Icons.location_off_outlined,
              );
            }

            return RefreshIndicator(
              onRefresh: () => context.read<AddressListCubit>().loadAddresses(),
              child: ListView.separated(
                padding: EdgeInsets.all(16.w),
                itemCount: addresses.length,
                separatorBuilder: (_, _) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  final address = addresses[index];
                  return AddressCard(
                    address: address,
                    isProcessing: address.id == processingId,
                    onSetDefault: () => context
                        .read<AddressListCubit>()
                        .setDefaultAddress(address.id),
                    onEdit: () => _editAddress(context, address),
                    onDelete: () => _confirmDelete(context, address),
                  );
                },
              ),
            );
          },
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: AppButton(
              label: 'إضافة عنوان جديد',
              icon: Icons.add_rounded,
              variant: AppButtonVariant.outline,
              onPressed: () => _addAddress(context),
            ),
          ),
        ),
      ),
    );
  }
}
