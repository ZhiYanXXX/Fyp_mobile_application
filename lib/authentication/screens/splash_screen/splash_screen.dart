import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medapp/common%20widgets/fade_in_animation/animation_design.dart';
import 'package:medapp/common%20widgets/fade_in_animation/fade_in_animation_controller.dart';
import 'package:medapp/common%20widgets/fade_in_animation/fade_in_animation_model.dart';
import 'package:medapp/constant/colors.dart';
import 'package:medapp/constant/image_string.dart';
import 'package:medapp/constant/sizes.dart';
import 'package:medapp/constant/text_string.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fiaController = Get.put(FadeInAnimationController());
    fiaController.startSplashAnimation();

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            MFadeInAnimation(
                durationInMs: 1600,
                animate: MAnimatePosition(
                  topafter: 0,
                  topBefore: -30,
                  leftBefore: -30,
                  leftAfter: 0,
                ),
                child: const Image(image: AssetImage(mSplashIcon))),
            MFadeInAnimation(
              durationInMs: 2000,
              animate: MAnimatePosition(
                  topBefore: 80,
                  topafter: 80,
                  leftAfter: mDefaultSize,
                  leftBefore: -80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(mAppName,
                      style: Theme.of(context).textTheme.headlineLarge),
                  Text(mAppTagLine,
                      style: Theme.of(context).textTheme.headlineMedium),
                ],
              ),
            ),
            MFadeInAnimation(
              durationInMs: 2400,
              animate: MAnimatePosition(bottomBefore: -80, bottomAfter: 40),
              child: const Image(
                image: AssetImage(mSplashImage),
                width: 400,
                height: 800,
              ),
            ),
            MFadeInAnimation(
              durationInMs: 2400,
              animate: MAnimatePosition(
                  bottomBefore: 0,
                  bottomAfter: 40,
                  rightBefore: mDefaultSize,
                  rightAfter: 0),
              child: Container(
                width: mSplashContainerSize,
                height: mSplashContainerSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: mPrimaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
