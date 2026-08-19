import 'package:equatable/equatable.dart';

abstract class OtpState extends Equatable {
  const OtpState();

  @override
  List<Object?> get props => [];
}

class OtpInitial extends OtpState {}

class OtpLoading extends OtpState {}

class OtpSuccess extends OtpState {}

class OtpResentSuccess extends OtpState {}

class OtpError extends OtpState {
  final String message;
  const OtpError(this.message);

  @override
  List<Object?> get props => [message];
}
