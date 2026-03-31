part of '../widgets_lib.dart';

/// Reusable StreamBuilder for Firebase Realtime Database.
///
/// Streams data from the specified [path] using `ref.onValue`.
/// Handles loading, error, and data states.
///
/// Example usage:
/// ```dart
/// FirebaseStreamBuilder(
///   path: 'drivers/test',
///   builder: (context, event) {
///     final data = event.snapshot.value;
///     if (data == null) return const Text('No data');
///     return Text('Data: \$data');
///   },
/// )
/// ```
class FirebaseStreamBuilder extends StatelessWidget {
  final String path;
  final Widget Function(BuildContext context, DatabaseEvent event) builder;
  final Widget? loader;
  final Widget Function(BuildContext context, Object error)? errorBuilder;

  const FirebaseStreamBuilder({
    super.key,
    required this.path,
    required this.builder,
    this.loader,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final ref = FirebaseDatabase.instance.ref(path);

    return StreamBuilder<DatabaseEvent>(
      stream: ref.onValue,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loader ?? const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return errorBuilder?.call(context, snapshot.error!) ??
              const Center(child: Text('Error: \${snapshot.error}'));
        }

        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        return builder(context, snapshot.data!);
      },
    );
  }
}
