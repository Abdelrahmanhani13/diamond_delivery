// presentation/controller/profile_cubit/vendor_profile_state.dart
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
  const VendorProfileLoaded(this.profile);
}

class VendorProfileError extends VendorProfileState {
  final String message;
  const VendorProfileError(this.message);
}

/// بيتبعت وقت تنفيذ التحديث (نص + رفع الصور لو موجودة).
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
