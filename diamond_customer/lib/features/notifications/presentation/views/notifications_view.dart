import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../widgets/notification_tile.dart';

/// Notifications screen — reached from Profile's "الإشعارات" item.
class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  static const _notifications = [
    NotificationData(
      title: 'تم تأكيد طلبك',
      message: 'طلبك من برجر هاوس في الطريق إليك الآن',
      time: 'منذ 5 د',
      icon: Icons.delivery_dining_rounded,
      unread: true,
    ),
    NotificationData(
      title: 'عرض خاص لك',
      message: 'خصم 20% على طلبك القادم من صيدلية بلس',
      time: 'منذ ساعة',
      icon: Icons.local_offer_rounded,
      unread: true,
    ),
    NotificationData(
      title: 'تم توصيل الطلب',
      message: 'نتمنى أن ينال طلبك إعجابك، قيّم تجربتك الآن',
      time: 'أمس',
      icon: Icons.check_circle_outline_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: const CustomAppBar(title: 'الإشعارات'),
        body: _notifications.isEmpty
            ? const EmptyStateWidget(
                title: 'لا توجد إشعارات',
                message: 'ستظهر إشعاراتك هنا عند وصولها',
                icon: Icons.notifications_none_rounded,
              )
            : ListView.separated(
                padding: EdgeInsets.all(16.w),
                itemCount: _notifications.length,
                separatorBuilder: (_, _) => SizedBox(height: 10.h),
                itemBuilder: (context, index) =>
                    NotificationTile(data: _notifications[index]),
              ),
      ),
    );
  }
}
