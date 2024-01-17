import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medapp/common%20widgets/fade_in_animation/fade_in_animation_controller.dart';
import 'package:medapp/common%20widgets/fade_in_animation/fade_in_animation_model.dart';

class MFadeInAnimation extends StatelessWidget {
  MFadeInAnimation({
    super.key,
    required this.durationInMs,
    required this.animate,
    required this.child,
  });

  final fiaController = Get.put(FadeInAnimationController());
  final int durationInMs;
  final MAnimatePosition? animate;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedPositioned(
        duration: Duration(milliseconds: durationInMs),
        top: fiaController.animate.value
            ? animate!.topafter
            : animate!.topBefore,
        left: fiaController.animate.value
            ? animate!.leftAfter
            : animate!.leftBefore,
        bottom: fiaController.animate.value
            ? animate!.bottomAfter
            : animate!.bottomBefore,
        right: fiaController.animate.value
            ? animate!.rightAfter
            : animate!.rightBefore,
        child: AnimatedOpacity(
          duration: Duration(milliseconds: durationInMs),
          opacity: fiaController.animate.value ? 1 : 0,
          child: child,
        ),
      ),
    );
  }
}
