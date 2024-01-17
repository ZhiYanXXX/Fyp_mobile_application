import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medapp/authentication/screens/login/login.dart';
import 'package:medapp/authentication/services/auth_services.dart';
import 'package:medapp/constant/sizes.dart';
import 'package:medapp/constant/text_string.dart';

class SignUpFormWidget extends StatefulWidget {
  const SignUpFormWidget({
    super.key,
  });

  @override
  State<SignUpFormWidget> createState() => _SignUpFormWidgetState();
}

class _SignUpFormWidgetState extends State<SignUpFormWidget> {
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
    final formKey = GlobalKey<FormState>();
    return Container(
      padding: const EdgeInsets.symmetric(vertical: mFormHeight - 10),
      child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: fullNameC,
                decoration: const InputDecoration(
                  label: Text(mFullName),
                  prefixIcon: Icon(Icons.person_outline_rounded),
                ),
              ),
              const SizedBox(height: mFormHeight - 10),
              TextFormField(
                controller: emailC,
                decoration: const InputDecoration(
                  label: Text(mEmail),
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: mFormHeight - 10),
              TextFormField(
                controller: passwordC,
                obscureText:
                    !isPasswordVisible, // Toggle visibility based on the flag
                decoration: InputDecoration(
                  labelText: mPassword,
                  prefixIcon: const Icon(Icons.fingerprint),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
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
              const SizedBox(height: mFormHeight - 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: const ButtonStyle(
                      elevation: MaterialStatePropertyAll(5.0)),
                  onPressed: () {
                    signUp();
                  },
                  child: Text(
                    mSignUp.toUpperCase(),
                    style: const TextStyle(
                        fontFamily: "VarelaRound",
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          )),
    );
  }

  void signUp() async {
    String email = emailC.text;
    String password = passwordC.text;
    String name = fullNameC.text;

    // Email format validation
    RegExp emailRegexp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z0-9-.]+$");
    if (!emailRegexp.hasMatch(email)) {
      Get.snackbar('Error', 'Invalid email format',
          backgroundColor: Colors.red);
      return;
    }

    // Password strength validation
    bool isPasswordStrong = password.length >= 8; // Add more criteria as needed
    if (!isPasswordStrong) {
      Get.snackbar('Error', 'Password is not strong enough',
          backgroundColor: Colors.red);
      return;
    }

    try {
      User? user =
          await _auth.signUpWithEmailAndPassword(email, password, name);

      if (user != null) {
        Get.snackbar("Message", "User is successfully created!");
        Get.offAll(() => const LoginScreen());
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        Get.snackbar('Error', 'The email address is already in use',
            backgroundColor: Colors.red);
      } else {
        Get.snackbar('Error',
            e.message ?? 'Something went wrong. Please try again later',
            backgroundColor: Colors.red);
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong. Please try again later',
          backgroundColor: Colors.red);
    }
  }
}
