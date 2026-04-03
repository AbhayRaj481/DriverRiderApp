part of '../screen_lib.dart';

class OTPVerificationScreen extends StatelessWidget {
  final String verificationId;

  const OTPVerificationScreen({super.key, required this.verificationId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter OTP')),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            // Navigator.popUntil(context, (route) => route.isFirst);
            context.push(RoutesName.homeScreen);
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Login successful!')));
          } else if (state is PhoneAuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.sms, size: 100, color: Colors.green),
              const SizedBox(height: 32),
              const Text(
                'Enter the OTP sent to your phone',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              Pinput(
                length: 6,
                onCompleted: (otpCode) {
                  context.read<AuthBloc>().add(
                    OTPSubmitted(
                      verificationId: verificationId,
                      otpCode: otpCode,
                    ),
                  );
                },
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
              ),
              const SizedBox(height: 32),
              const Text('Didn\'t receive OTP? Resend'),
            ],
          ),
        ),
      ),
    );
  }
}
