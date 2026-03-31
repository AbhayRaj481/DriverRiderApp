part of '../widgets_lib.dart';

/// Reusable StreamBuilder for Firestore.
///
/// Streams data from the specified collection [path] using snapshots().
/// Handles loading, error, and data states.
///
class FirestoreStreamBuilder extends StatelessWidget {
  final String path;
  final Widget Function(BuildContext context, QuerySnapshot snapshot) builder;
  final Widget? loader;
  final Widget Function(BuildContext context, Object error)? errorBuilder;

  const FirestoreStreamBuilder({
    super.key,
    required this.path,
    required this.builder,
    this.loader,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final ref = FirebaseFirestore.instance.collection(path);

    return StreamBuilder<QuerySnapshot>(
      stream: ref.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loader ?? const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return errorBuilder?.call(context, snapshot.error!) ??
              const Center(child: Text('Error: \${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const SizedBox.shrink();
        }

        return builder(context, snapshot.data!);
      },
    );
  }
}
