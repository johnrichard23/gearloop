import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// The screen a guest was trying to open when they were sent to Log in, so the
/// app can take them back there once they are signed in.
///
/// Held in a static because it is written from the router's redirect, which
/// runs outside the widget tree.
abstract final class PendingRoute {
  PendingRoute._();

  static String? _path;
  static Object? _extra;

  /// Remembers [path] (and its [extra] payload) as the place to resume.
  static void save(String path, {Object? extra}) {
    _path = path;
    _extra = extra;
  }

  /// Forgets any saved destination, e.g. when the guest backs out to browse.
  static void clear() {
    _path = null;
    _extra = null;
  }

  /// Lands on Home after a successful sign-in or sign-up, then opens the saved
  /// destination on top so Back returns to Home.
  static void goAfterAuth(BuildContext context) {
    final path = _path;
    final extra = _extra;
    clear();
    context.go('/home');
    if (path != null) {
      context.push(path, extra: extra);
    }
  }
}
