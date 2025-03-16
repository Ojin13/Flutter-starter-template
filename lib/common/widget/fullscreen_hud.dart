import 'dart:ui';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class FullscreenHud extends StatefulWidget {
  final Widget child;
  const FullscreenHud({super.key, required this.child});

  @override
  _FullscreenHudState createState() => _FullscreenHudState();

  static _FullscreenHudState of(BuildContext context) {
    return context.findAncestorStateOfType<_FullscreenHudState>()!;
  }
}

class _FullscreenHudState extends State<FullscreenHud> {
  bool _isLoading = false;
  DateTime _startTime = DateTime.now();

  void show() {
    setState(() {
      _isLoading = true;
      _startTime = DateTime.now();
    });
  }

  void hide() {
    setState(() {
      // To prevent flickering of the loading hud on fast operations
      // we will show the loading hud for at least 500ms...
      final timePassed = DateTime.now().difference(_startTime).inMilliseconds;
      if (timePassed < 500) {
        Future.delayed(Duration(milliseconds: 500), () {
          setState(() {
            _isLoading = false;
          });
        });
      } else {
        _isLoading = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_isLoading) ...[
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Opacity(
              opacity: 0.75,
              child: ModalBarrier(dismissible: false, color: Colors.black),
            ),
          ),
          Center(
            child: CircularProgressIndicator(
              strokeWidth: 7,
              color: Theme.of(context).extension<AppColors>()!.customColor1,
            ),
          ),
        ]
      ],
    );
  }
}
