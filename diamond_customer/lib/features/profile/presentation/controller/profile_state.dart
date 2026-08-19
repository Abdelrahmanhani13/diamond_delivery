import 'package:equatable/equatable.dart';
import '../../domain/entities/profile_entity.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileEntity profile;

  const ProfileLoaded(this.profile);

  @override
  List<Object?> get props => [profile];
}

class ProfileError extends ProfileState {
  final String message;
  final List<dynamic>? errors;

  const ProfileError(this.message, {this.errors});

  @override
  List<Object?> get props => [message, errors];
}

class ProfileUpdateLoading extends ProfileState {}

class ProfileUpdateSuccess extends ProfileState {
  final ProfileEntity profile;

  const ProfileUpdateSuccess(this.profile);

  @override
  List<Object?> get props => [profile];
}

class ProfileUpdateError extends ProfileState {
  final String message;
  final List<dynamic>? errors;

  const ProfileUpdateError(this.message, {this.errors});

  @override
  List<Object?> get props => [message, errors];
}
