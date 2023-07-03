import 'package:flutter/widgets.dart';

/// [ControlledWidget] is an abstract base class for widgets that are controlled
/// by a [ChangeNotifier].
///
/// The [controller] is a [ChangeNotifier] that when notifying its listeners,
/// triggers the widget to rebuild.
///
/// If a controller is not provided, a new instance will be created by calling
/// [ControlledStateMixin.makeController].
abstract class ControlledWidget<T extends ChangeNotifier>
    extends StatefulWidget {
  /// The [ChangeNotifier] that the widget will listen to.
  ///
  /// Whenever the [controller] sends notifications, the widget rebuilds. If
  /// null, a new instance is created by invoking the [ControlledStateMixin.makeController].
  final T? controller;

  const ControlledWidget({Key? key, this.controller}) : super(key: key);
}

/// [ControlledStateMixin] is a mixin that manages the lifecycle of a [ChangeNotifier]
/// for a [ControlledWidget].
///
/// It adds itself as a listener to the [ChangeNotifier] during initState and
/// removes itself during dispose.
///
/// If no [ChangeNotifier] is provided via the widget, it creates one using the
/// [makeController] method.
mixin ControlledStateMixin<T extends ChangeNotifier,
    U extends ControlledWidget<T>> on State<U> {
  /// Called when the [ChangeNotifier] notifies its listeners.
  ///
  /// By default, it rebuilds the widget. Override this method to change this behavior.
  @protected
  @mustCallSuper
  void rebuild() => setState(() {});

  /// Creates a new instance of the [ChangeNotifier].
  ///
  /// Called if no [ChangeNotifier] is provided via the widget.
  @protected
  T makeController();

  @override
  void initState() {
    super.initState();
    _bindController(widget.controller);
  }

  @override
  void didUpdateWidget(covariant U oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _unbindController();
      _bindController(widget.controller);
    }
  }

  @override
  void dispose() {
    _unbindController();
    super.dispose();
  }

  T? _controller;

  T get controller => _controller!;

  bool _selfCreatedController = false;

  void _bindController(T? newController) {
    if (newController == null) {
      _controller = makeController();
      _selfCreatedController = true;
    } else {
      _controller = newController;
      _selfCreatedController = false;
    }
    _controller!.addListener(rebuild);
  }

  void _unbindController() {
    _controller!.removeListener(rebuild);
    if (_selfCreatedController) {
      _controller!.dispose();
    }
  }
}
