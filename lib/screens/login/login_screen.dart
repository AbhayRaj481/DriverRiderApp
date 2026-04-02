part of '../screen_lib.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.goNamed(RoutesName.home);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Login to your account',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 40),
              TextField(
                decoration: const InputDecoration(labelText: 'Email'),
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                onChanged: (value) {},
              ),
              const SizedBox(height: 24),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return state is AuthLoading
                      ? const CircularProgressIndicator()
                      : Column(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Get controllers or use FormKey for validation
                                context.read<AuthBloc>().add(
                                  const AppSignInWithEmailRequested(
                                    email:
                                        'test@example.com', // Replace with controller.text
                                    password: 'password',
                                  ),
                                );
                              },
                              child: const Text('Sign In'),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              onPressed: () {
                                context.read<AuthBloc>().add(
                                  const AppSignInWithGoogleRequested(),
                                );
                              },
                              icon: const Icon(Icons.g_mobiledata),
                              label: const Text('Sign In with Google'),
                            ),
                            const SizedBox(height: 24),
                            TextButton(
                              onPressed: () =>
                                  context.go(RoutesName.signup),
                              child: const Text('No account? Sign Up'),
                            ),
                          ],
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
