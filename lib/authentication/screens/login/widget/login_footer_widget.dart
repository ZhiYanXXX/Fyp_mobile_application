import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medapp/authentication/screens/signup/signup.dart';
import 'package:medapp/constant/sizes.dart';
import 'package:medapp/constant/text_string.dart';

class LoginFooterWidget extends StatelessWidget {
  const LoginFooterWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: mFormHeight - 20,
        ),
        TextButton(
          onPressed: () {
            Get.to(() => const SignUpScreen());
          },
          child: Text.rich(TextSpan(
              text: mDontHaveAnAccount,
              style: Theme.of(context).textTheme.bodyLarge,
              children: const [
                TextSpan(text: mSignUp, style: TextStyle(color: Colors.blue))
              ])),
        )
      ],
    );
  }
}
