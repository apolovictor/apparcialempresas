import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

mixin OverLayStateMixin<T extends StatefulWidget> on State<T> {
  OverlayEntry? _overlayEntry;

  bool get _isOverlayShown => _overlayEntry != null;

  getOverlayEntry() => _overlayEntry;

  void toggleOverlay(Widget child, Offset? offset) =>
      _isOverlayShown ? removeOverlay() : _insertOverlay(child, offset);

  removeOverlay() {
    if (!_isOverlayShown) return _isOverlayShown;
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _insertOverlay(Widget child, Offset? offset) {
    print("offset === $offset");
    _overlayEntry = OverlayEntry(
      builder: (context) => _dismissibleOverlay(child, offset),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  Widget _dismissibleOverlay(Widget child, Offset? offset) => Positioned(
      left: offset?.dx,
      top: offset?.dy,
      child: GestureDetector(
        onTap: removeOverlay,
        child: child,
      ));

  @override
  void dispose() {
    removeOverlay();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    removeOverlay();

    super.didChangeDependencies();
  }
}
