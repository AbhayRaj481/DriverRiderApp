import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AppSignInWithEmailRequested extends AuthEvent {
  final String email;
  final String password;

  const AppSignInWithEmailRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class AppSignInWithGoogleRequested extends AuthEvent {
  const AppSignInWithGoogleRequested();

  @override
  List<Object?> get props => [];
}

class AppSignOutRequested extends AuthEvent {
  const AppSignOutRequested();

  @override
  List<Object?> get props => [];
}

class PhoneNumberSubmitted extends AuthEvent {
  final String phoneNumber;

  const PhoneNumberSubmitted({required this.phoneNumber});

  @override
  List<Object?> get props => [phoneNumber];
}

class OTPSubmitted extends AuthEvent {
  final String verificationId;
  final String otpCode;

  const OTPSubmitted({required this.verificationId, required this.otpCode});

  @override
  List<Object?> get props => [verificationId, otpCode];
}
