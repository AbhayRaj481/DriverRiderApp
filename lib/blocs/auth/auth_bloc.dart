import 'package:driving_mobile_app/repositories/repo_lib.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  String? _verificationId;
  String? _phoneAuthError;

  AuthBloc({required this.authRepository}) : super(const AuthInitial()) {
    on<AppSignInWithEmailRequested>(_onSignInWithEmail);
    on<AppSignInWithGoogleRequested>(_onSignInWithGoogle);
    on<AppSignOutRequested>(_onSignOut);
    on<PhoneNumberSubmitted>(_onPhoneNumberSubmitted);
    on<OTPSubmitted>(_onOTPSubmitted);

    // Listen to auth state changes
    authRepository.currentUser.listen((user) {
      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(const AuthUnauthenticated());
      }
    });
  }

  void _onSignInWithEmail(
    AppSignInWithEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final user = await authRepository.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onSignInWithGoogle(
    AppSignInWithGoogleRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final user = await authRepository.signInWithGoogle();
      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onSignOut(AppSignOutRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      await authRepository.signOut();
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onPhoneNumberSubmitted(
    PhoneNumberSubmitted event,
    Emitter<AuthState> emit,
  ) async {

    print(">>>_ _onPhoneNumberSubmitted -> ");
    _verificationId = null;
    _phoneAuthError = null;
    emit(const AuthLoading());
    try {
      authRepository.verifyPhoneNumber(
        phoneNumber: event.phoneNumber,
        codeSent: (verificationId, resendToken) {
          _verificationId = verificationId;
          _phoneAuthError = null;
        },
        verificationFailed: (error) {
          _phoneAuthError = error.message ?? 'Verification failed';
        },
        codeAutoRetrievalTimeout: (verificationId) {
          _verificationId = verificationId;
          _phoneAuthError = 'Auto retrieval timeout';
        },
      );

     if((_verificationId ?? "").trim().isNotEmpty) emit(PhoneVerificationSent(verificationId: _verificationId ?? ""));
     if(_phoneAuthError != null) emit(PhoneAuthError(_phoneAuthError ?? "Something went wrong"));
    } catch (e) {
      emit(PhoneAuthError(e.toString()));
    }
  }

  Future<void> _onOTPSubmitted(
    OTPSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    if (_phoneAuthError != null) {
      emit(PhoneAuthError(_phoneAuthError!));
      _phoneAuthError = null;
      return;
    }
    if (_verificationId == null) {
      emit(const PhoneAuthError('No verification in progress'));
      return;
    }
    emit(const AuthLoading());
    try {
      final userCredential = await authRepository.confirmPhoneVerification(_verificationId!, event.otpCode);
      if (userCredential != null) {
        emit(AuthAuthenticated(user: userCredential.user!));
      }
    } catch (e) {
      emit(PhoneAuthError(e.toString()));
    }
  }
}
