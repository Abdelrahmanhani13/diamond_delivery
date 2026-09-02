import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vendor_dashboard/features/auth/data/datasources/vendor_auth_local_data_source.dart';
import 'vendor_auth_state.dart';

class VendorAuthCubit extends Cubit<VendorAuthState> {
  final VendorAuthLocalDataSource localDataSource;

  VendorAuthCubit({required this.localDataSource}) : super(VendorAuthInitial());

  Future<void> checkAuthStatus() async {
    final token = await localDataSource.getAccessToken();
    if (token != null && token.isNotEmpty) {
      emit(VendorAuthenticated());
    } else {
      emit(VendorUnauthenticated());
    }
  }

  void loggedIn() => emit(VendorAuthenticated());

  Future<void> loggedOut() async {
    await localDataSource.clearAll();
    emit(VendorUnauthenticated());
  }
}
