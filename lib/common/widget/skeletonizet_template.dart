import 'package:flutter/material.dart';
import 'package:flutter_starter_template/common/theme/app_colors.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SkeletonizerTemplate extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final bool animateLoad;
  const SkeletonizerTemplate({super.key, required this.child, required this.isLoading, this.animateLoad = true});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(containersColor: Theme.of(context).extension<AppColors>()!.customColor1, enableSwitchAnimation: animateLoad, enabled: isLoading, child: child);
  }
}
