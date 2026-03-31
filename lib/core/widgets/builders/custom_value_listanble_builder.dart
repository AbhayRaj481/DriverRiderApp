part of '../widgets_lib.dart';


/// Reusable ValueListenableBuilder for listening to ValueNotifier changes.
///
/// Listens to [valueListenable] and rebuilds using [builder].
/// Handles loading, error, and value states.

class CustomValueListenableBuilder<T> extends StatelessWidget {
  final ValueListenable<T> valueListenable;
  final Widget Function(BuildContext context, T value) builder;
  final Widget? loader;
  final Widget Function(BuildContext context, Object error)? errorBuilder;

  const CustomValueListenableBuilder({
    super.key,
    required this.valueListenable,
    required this.builder,
    this.loader,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<T>(
      valueListenable: valueListenable,
      builder: (context, value, child) {
        // Simulate loading if needed; ValueListenableBuilder doesn't have connectionState
        // For async notifiers, consider FutureBuilder or StreamBuilder alternative
        // if (/* add custom loading logic if needed */) {
        //   return loader ?? const Center(child: CircularProgressIndicator());
        // }

        // Error handling typically external; add if notifier throws
        try {
          return builder(context, value);
        } catch (e) {
          return errorBuilder?.call(context, e) ??
              const Center(child: Text('Error: \$e'));
        }
      },
    );
  }
}
