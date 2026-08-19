import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_state.dart';
import 'package:diamond_customer/features/auth/domain/usecases/login_use_case.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase _loginUseCase;

  LoginCubit(this._loginUseCase) : super(LoginInitial());

  Future<void> login(String phoneNumber, String password) async {
    emit(LoginLoading());
    // For deviceName, we use a constant or fetch it from a service later
    final result = await _loginUseCase(phoneNumber, password, "Flutter App");
    result.fold(
      (failure) => emit(LoginError(failure.message, errors: failure.errors)),
      (authTokens) => emit(LoginSuccess(authTokens)),
    );
  }
}
