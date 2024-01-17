import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medapp/authentication/screens/login/login.dart';
import 'package:medapp/authentication/screens/signup/widget/signup_form_widget.dart';
import 'package:medapp/common%20widgets/form/form_header_widget.dart';
import 'package:medapp/constant/image_string.dart';
import 'package:medapp/constant/sizes.dart';
import 'package:medapp/constant/text_string.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(mDefaultSize),
            child: Column(
              children: [
                const FormHeaderWidget(
                    image: mWelcomeImage,
                    title: mSignUpTitle,
                    subtitle: mSignUpSubtitle),
                const SignUpFormWidget(),
                Column(
                  children: [
                    TextButton(
                        onPressed: () {
                          Get.offAll(() => const LoginScreen());
                        },
                        child: Text.rich(TextSpan(children: [
                          TextSpan(
                              text: mAlreadyHaveAnAccount,
                              style: Theme.of(context).textTheme.bodyLarge),
                          TextSpan(
                              text: mLogin.toUpperCase(),
                              style: const TextStyle(
                                  color: Colors.blueAccent,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.blueAccent))
                        ])))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
