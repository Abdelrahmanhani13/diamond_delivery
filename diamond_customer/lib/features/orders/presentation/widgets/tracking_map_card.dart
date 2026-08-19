import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';

/// A card displaying a simulated tracking map with a
/// road-network overlay, route line, store/home pins,
/// courier position, and an ETA banner.
class TrackingMapCard extends StatelessWidget {
  const TrackingMapCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Column(
          children: [
            Container(
              height: 180.h,
              width: double.infinity,
              color: const Color(0xFFE8ECE9),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(painter: _TrackingMapPainter()),
                  ),
                  Positioned(
                    top: 12.h,
                    right: 12.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 14.sp,
                            color: AppColors.white,
                          ),
                          Gap(4.w),
                          Text(
                            'الوصول المتوقع خلال 12 دقيقة',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom map painter that renders tracking paths of the delivery vehicle.
class _TrackingMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final groundPaint = Paint()
      ..color = const Color(0xFFE8ECE9)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), groundPaint);

    final roadPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16.w
      ..strokeCap = StrokeCap.round;

    final roadOutline = Paint()
      ..color = const Color(0xFFD6DDD8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18.w
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(20.w, size.height * 0.2)
      ..lineTo(size.width * 0.5, size.height * 0.45)
      ..lineTo(size.width - 20.w, size.height * 0.8);

    canvas.drawPath(path, roadOutline);
    canvas.drawPath(path, roadPaint);

    final path2 = Path()
      ..moveTo(size.width * 0.3, size.height * 0.9)
      ..lineTo(size.width * 0.8, size.height * 0.1);

    canvas.drawPath(path2, roadOutline);
    canvas.drawPath(path2, roadPaint);

    final routePaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.w
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, routePaint);

    final storePaint = Paint()..color = AppColors.accent;
    canvas.drawCircle(Offset(20.w, size.height * 0.2), 6.r, storePaint);

    final homePaint = Paint()..color = AppColors.error;
    canvas.drawCircle(
      Offset(size.width - 20.w, size.height * 0.8),
      7.r,
      homePaint,
    );

    final courierPulse = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.2);
    final courierCore = Paint()..color = AppColors.primary;

    final courierOffset = Offset(size.width * 0.5, size.height * 0.45);
    canvas.drawCircle(courierOffset, 12.r, courierPulse);
    canvas.drawCircle(courierOffset, 6.r, courierCore);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
