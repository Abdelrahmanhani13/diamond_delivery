import 'package:flutter_bloc/flutter_bloc.dart';
import 'register_state.dart';
import 'package:diamond_customer/features/auth/domain/usecases/register_use_case.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUseCase _registerUseCase;

  RegisterCubit(this._registerUseCase) : super(RegisterInitial());

  Future<void> register({
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String email,
    required String password,
    String? dateOfBirth,
  }) async {
    emit(RegisterLoading());

    final result = await _registerUseCase(
      firstName,
      lastName,
      phoneNumber,
      email,
      password,
      "Customer", // Default role
      null,       // genderId
      dateOfBirth,
    );

    result.fold(
      (failure) => emit(RegisterError(failure.message, errors: failure.errors)),
      (response) => emit(RegisterSuccess(response)),
    );
  }
}
