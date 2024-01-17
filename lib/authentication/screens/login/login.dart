import 'package:flutter/material.dart';
import 'package:medapp/authentication/screens/login/widget/login_footer_widget.dart';
import 'package:medapp/authentication/screens/login/widget/login_form_widget.dart';
import 'package:medapp/common%20widgets/form/form_header_widget.dart';
import 'package:medapp/constant/image_string.dart';
import 'package:medapp/constant/sizes.dart';
import 'package:medapp/constant/text_string.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(mDefaultSize),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FormHeaderWidget(
                image: mWelcomeImage,
                title: mLoginTilte,
                subtitle: mLoginSubtitle,
              ),
              LoginForm(),
              LoginFooterWidget()
            ],
          ),
        ),
      )),
    );
  }
}
