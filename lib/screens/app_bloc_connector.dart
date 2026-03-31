part of 'screen_lib.dart';

class AppBlocConnector extends StatelessWidget {
  final Widget child;
  const AppBlocConnector({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AuthBloc>()),
      ],
      child: child,
    );
  }
}
