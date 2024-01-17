import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medapp/authentication/screens/login/login.dart';
import 'package:medapp/authentication/screens/signup/signup.dart';
import 'package:medapp/common%20widgets/fade_in_animation/animation_design.dart';
import 'package:medapp/common%20widgets/fade_in_animation/fade_in_animation_controller.dart';
import 'package:medapp/common%20widgets/fade_in_animation/fade_in_animation_model.dart';
import 'package:medapp/constant/colors.dart';
import 'package:medapp/constant/image_string.dart';
import 'package:medapp/constant/sizes.dart';
import 'package:medapp/constant/text_string.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final fiaController = Get.put(FadeInAnimationController());
    fiaController.startAnimation();
    var mediaQuery = MediaQuery.of(context);
    var height = mediaQuery.size.height;
    var brightness = mediaQuery.platformBrightness;
    final isDarkMode = brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? mSecondaryColor : mPrimaryColor,
      body: Stack(
        children: [
          MFadeInAnimation(
            durationInMs: 1200,
            animate: MAnimatePosition(
              bottomAfter: 0,
              bottomBefore: -100,
              leftBefore: 0,
              leftAfter: 0,
              topBefore: 0,
              topafter: 0,
              rightAfter: 0,
              rightBefore: 0,
            ),
            child: Container(
              padding: const EdgeInsets.all(mDefaultSize),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Hero(
                      tag: 'welcome-image-tag',
                      child: Image(
                        image: const AssetImage(mWelcomeImage),
                        height: height * 0.3,
                      ),
                    ),
                    const Column(
                      children: [
                        Text(
                          mWelcomeTitle,
                          style: TextStyle(
                              fontFamily: "RubikDoodleShadow",
                              fontWeight: FontWeight.bold,
                              fontSize: 30),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          mWelcomeSubtitle,
                          style: TextStyle(
                              fontFamily: "Salsa",
                              fontWeight: FontWeight.w500,
                              color: Colors.brown,
                              fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: OutlinedButton(
                                style: const ButtonStyle(
                                    elevation: MaterialStatePropertyAll(3.0),
                                    foregroundColor: MaterialStatePropertyAll(
                                        Color.fromARGB(255, 0, 0, 0)),
                                    backgroundColor: MaterialStatePropertyAll(
                                        Color.fromARGB(255, 255, 237, 181))),
                                onPressed: () =>
                                    Get.to(() => const LoginScreen()),
                                child: Text(mLogin.toUpperCase()))),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: ElevatedButton(
                              style: const ButtonStyle(
                                elevation: MaterialStatePropertyAll(3.0),
                                foregroundColor:
                                    MaterialStatePropertyAll(Colors.black),
                                backgroundColor: MaterialStatePropertyAll(
                                    Color.fromARGB(255, 255, 240, 195)),
                              ),
                              onPressed: () =>
                                  Get.to(() => const SignUpScreen()),
                              child: Text(mSignUp.toUpperCase())),
                        ),
                      ],
                    )
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}
