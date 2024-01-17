import 'package:get/get.dart';
// import 'package:medapp/repository/authentication_repository/authentication_repository.dart';
// import 'package:medapp/screens/home_page.dart';

class OTPController extends GetxController {
  static OTPController get instance => Get.find();

  // void verifyOTP(String otp) async {
  //   var isVerified = await AuthenticationRepository.instance.verifyOTP(otp);
  //   isVerified ? Get.offAll(const HomePage()) : Get.back();
  // }
}
