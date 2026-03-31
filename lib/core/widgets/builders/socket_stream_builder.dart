part of '../widgets_lib.dart';

/// A widget that builds itself based on the latest snapshot of interaction with a WebSocket stream.
///
/// Similar to [StreamBuilder], but specialized for WebSocket connections with explicit URL.
///
/// The stream data is cast to T?, handle nulls in builder if needed.
class SocketStreamBuilder<T> extends StatefulWidget {
  /// The WebSocket server URL. Must be ws:// or wss://
  const SocketStreamBuilder({
    super.key,
    required this.url,
    this.initialData,
    this.loadingBuilder,
    this.errorBuilder,
    required this.builder,
  });

  final String url;
  final T? initialData;
  final Widget Function(BuildContext context, AsyncSnapshot<T?> snapshot)?
  loadingBuilder;
  final Widget Function(BuildContext context, AsyncSnapshot<T?> snapshot)?
  errorBuilder;
  final Widget Function(BuildContext context, AsyncSnapshot<T?> snapshot)
  builder;

  @override
  State<SocketStreamBuilder<T>> createState() => _SocketStreamBuilderState<T>();
}

class _SocketStreamBuilderState<T> extends State<SocketStreamBuilder<T>> {
  WebSocketChannel? _channel;
  late AsyncSnapshot<T?> _snapshot;
  StreamSubscription<dynamic>? _subscription;

  @override
  void initState() {
    super.initState();
    _snapshot = AsyncSnapshot<T?>.withData(
      ConnectionState.waiting,
      widget.initialData,
    );
    _connect();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _channel?.sink.close(status.goingAway);
    super.dispose();
  }

  Future<void> _connect() async {
    if (!mounted) return;

    setState(() {
      _snapshot = AsyncSnapshot<T?>.withData(
        ConnectionState.waiting,
        widget.initialData,
      );
    });

    try {
      _channel = WebSocketChannel.connect(Uri.parse(widget.url));
      await _channel!.ready;

      if (!mounted) return;

      setState(() {
        _snapshot = AsyncSnapshot<T?>.withData(
          ConnectionState.active,
          widget.initialData,
        );
      });

      _subscription?.cancel();
      _subscription = _channel!.stream.listen(
        (data) {
          if (mounted) {
            setState(() {
              _snapshot = AsyncSnapshot<T?>.withData(
                ConnectionState.active,
                data as T?,
              );
            });
          }
        },
        onError: (error) {
          if (mounted) {
            setState(() {
              _snapshot = AsyncSnapshot<T?>.withError(
                ConnectionState.done,
                error,
              );
            });
          }
        },
        onDone: () {
          if (mounted) {
            setState(() {
              _snapshot = AsyncSnapshot<T?>.withData(
                ConnectionState.done,
                _snapshot.data,
              );
            });
          }
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _snapshot = AsyncSnapshot<T?>.withError(ConnectionState.none, e);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = _snapshot;

    if (snapshot.hasError && widget.errorBuilder != null) {
      return widget.errorBuilder!(context, snapshot);
    }

    if (snapshot.connectionState == ConnectionState.waiting &&
        widget.loadingBuilder != null) {
      return widget.loadingBuilder!(context, snapshot);
    }

    return widget.builder(context, snapshot);
  }
}
