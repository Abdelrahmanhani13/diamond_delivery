// presentation/cubit/login/vendor_login_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'vendor_login_state.dart';
import 'package:vendor_dashboard/features/auth/domain/usecases/vendor_login_usecase.dart';

class VendorLoginCubit extends Cubit<VendorLoginState> {
  final VendorLoginUseCase loginUseCase;

  VendorLoginCubit({required this.loginUseCase}) : super(VendorLoginInitial());

  Future<void> login({
    required String email,
    required String password,
    required String deviceName,
  }) async {
    emit(VendorLoginLoading());

    final result = await loginUseCase(
      email: email,
      password: password,
      deviceName: deviceName,
    );

    result.fold(
      (failure) => emit(VendorLoginFailure(failure.errMessage)),
      (tokens) => emit(VendorLoginSuccess()),
    );
  }
}
