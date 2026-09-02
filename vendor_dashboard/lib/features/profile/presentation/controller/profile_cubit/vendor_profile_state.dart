import 'package:vendor_dashboard/features/profile/data/models/vendor_dashboard_stats_model.dart';
import '../../../domain/entities/vendor_profile.dart';

abstract class VendorProfileState {
  const VendorProfileState();
}

class VendorProfileInitial extends VendorProfileState {
  const VendorProfileInitial();
}

class VendorProfileLoading extends VendorProfileState {
  const VendorProfileLoading();
}

class VendorProfileLoaded extends VendorProfileState {
  final VendorProfile profile;
  final VendorDashboardStatsModel? stats;
  final bool isUpdatingStatus;

  const VendorProfileLoaded(
    this.profile, {
    this.stats,
    this.isUpdatingStatus = false,
  });

  VendorProfileLoaded copyWith({
    VendorProfile? profile,
    VendorDashboardStatsModel? stats,
    bool? isUpdatingStatus,
  }) {
    return VendorProfileLoaded(
      profile ?? this.profile,
      stats: stats ?? this.stats,
      isUpdatingStatus: isUpdatingStatus ?? this.isUpdatingStatus,
    );
  }
}

class VendorProfileError extends VendorProfileState {
  final String message;
  const VendorProfileError(this.message);
}

class VendorProfileUpdating extends VendorProfileState {
  const VendorProfileUpdating();
}

class VendorProfileUpdateSuccess extends VendorProfileState {
  final VendorProfile profile;
  const VendorProfileUpdateSuccess(this.profile);
}

class VendorProfileUpdateError extends VendorProfileState {
  final String message;
  const VendorProfileUpdateError(this.message);
}
