import 'package:flutter/material.dart';

class TabBarNotifier extends ChangeNotifier {
  bool _isVisible = true;

  bool get isVisible => _isVisible;

  void show() {
    if (!_isVisible) {
      _isVisible = true;
      notifyListeners();
    }
  }

  void hide() {
    if (_isVisible) {
      _isVisible = false;
      notifyListeners();
    }
  }
}

class TabBarProvider extends InheritedNotifier<TabBarNotifier> {
  const TabBarProvider({
    super.key,
    required TabBarNotifier super.notifier,
    required super.child,
  });

  static TabBarNotifier of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TabBarProvider>()!
        .notifier!;
  }

  static TabBarNotifier? read(BuildContext context) {
    return context.getInheritedWidgetOfExactType<TabBarProvider>()?.notifier;
  }
}
