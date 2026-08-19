import 'dart:async';
import 'package:vendor_dashboard/core/network/auth_event_bus.dart';

enum AuthEvent { forcedLogout }

class AuthEventBus {
  final _controller = StreamController<AuthEvent>.broadcast();

  Stream<AuthEvent> get stream => _controller.stream;

  void emit(AuthEvent event) {
    if (!_controller.isClosed) {
      _controller.add(event);
    }
  }

  void dispose() {
    _controller.close();
  }
}
