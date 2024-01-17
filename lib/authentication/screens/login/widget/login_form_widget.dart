import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medapp/authentication/screens/forget_password/forget_password_mail/forget_password_mail.dart';
import 'package:medapp/authentication/services/auth_services.dart';
import 'package:medapp/constant/sizes.dart';
import 'package:medapp/constant/text_string.dart';
import 'package:medapp/screens/home_page/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  TextEditingController fullNameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController phoneNoC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  bool isPasswordVisible = false;

  @override
  void dispose() {
    super.dispose();
    fullNameC.dispose();
    emailC.dispose();
    phoneNoC.dispose();
    passwordC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        child: Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextFormField(
            controller: emailC,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.person_outline_outlined),
              labelText: mEmail,
              hintText: mEmail,
            ),
          ),
          const SizedBox(
            height: mFormHeight,
          ),
          TextFormField(
            controller: passwordC,
            obscureText:
                !isPasswordVisible, // Toggle visibility based on the flag
            decoration: InputDecoration(
              labelText: mPassword,
              prefixIcon: const Icon(Icons.fingerprint),
              suffixIcon: IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  // Toggle the visibility state
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
              ),
            ),
          ),
          const SizedBox(
            height: mFormHeight - 20,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
                onPressed: () {
                  Get.to(() => const ForgetPasswordMailScreen());
                },
                child: const Text(mForgetPassword)),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                signIn();
              },
              child: Text(mLogin
                  .toUpperCase()), // mLogin should be a String variable representing the button text
            ),
          ),
        ],
      ),
    ));
  }

  void signIn() async {
    // String name = fullNameC.text;
    String email = emailC.text;
    // String phoneNo = phoneNoC.text;
    String password = passwordC.text;

    User? user = await _auth.signInWithEmailAndPassword(email, password);
    await updateAuthenticationStatus(true);

    if (user != null) {
      Get.snackbar("Message", "User is successfully sign in");
      Get.offAll(() => HomePage(userId: user.uid));
    } else {
      Get.snackbar('Error', 'Something went wrong. Please try again later',
          backgroundColor: Colors.red);
    }
  }

  Future<void> updateAuthenticationStatus(bool isAuthenticated) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_authenticated', isAuthenticated);
  }
}
