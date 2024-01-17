// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:logger/logger.dart';
import 'package:medapp/authentication/screens/welcome_page/welcome_page.dart';
import 'package:medapp/common/confirmation_dialog.dart';
import 'package:medapp/constant/image_string.dart';
import 'package:medapp/constant/text_string.dart';
import 'package:medapp/screens/medpartner/medpartner_screen.dart';
import 'package:medapp/screens/medpartner/update_medpartner_screen.dart';
import 'package:medapp/screens/profile/update_user_profile.dart';
import 'package:medapp/screens/profile/widget/profile_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key, required this.userId});
  final String? userId;

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  File? profileImage;
  // Get the current user's ID

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Associate the key with the Scaffold
      appBar: AppBar(
        title: const Text(
          mProfileScreenAppBarTitle,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            LineAwesomeIcons.angle_left,
            weight: BouncingScrollSimulation.maxSpringTransferVelocity,
          ),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(widget.userId) // Use the userId of the signed-in user
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            String userEmail =
                FirebaseAuth.instance.currentUser?.email ?? 'Unknown';
            String userName = 'Unknown';
            // Check if data exists and is not null
            if (snapshot.hasData && snapshot.data != null) {
              // Assuming user data is stored in the first document of the collection
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              // Check if the 'name' field exists in the user's data
              if (data.containsKey('name')) {
                userName = data['name'];
              }
            }

            return Stack(children: [
              // Background Image
              Positioned.fill(
                  bottom: 200,
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      const Color.fromARGB(255, 255, 241, 198)
                          .withOpacity(0.2), // Adjust opacity value as needed
                      BlendMode.dstATop,
                    ),
                    child: Image.asset(
                      mHappyImage,
                      width: 200.0,
                      height: 200.0,
                    ),
                  )),
              SingleChildScrollView(
                child: SafeArea(
                  child: Container(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Stack(children: [
                          CircleAvatar(
                            radius: 64,
                            backgroundImage: profileImage != null
                                ? FileImage(profileImage!)
                                : const AssetImage(mUserProfileImage)
                                    as ImageProvider<Object>?,
                          ),
                          Positioned(
                              bottom: -10,
                              right: -10,
                              child: IconButton(
                                  onPressed: () async {
                                    await pickImage();
                                  },
                                  icon: const Icon(Icons.camera_alt)))
                        ]),
                        const SizedBox(height: 10),
                        Text(
                          userName,
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Salsa',
                              fontSize: 32.0),
                        ),
                        Text(
                          userEmail,
                          style: const TextStyle(
                              color: Color.fromARGB(255, 13, 78, 192),
                              fontFamily: 'Salsa',
                              fontSize: 24.0),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                            width: 200,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UpdateProfileScreen(
                                        userId: widget.userId!),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                  elevation: 4.0,
                                  backgroundColor:
                                      const Color.fromARGB(255, 255, 209, 72),
                                  side: BorderSide.none,
                                  shape: const StadiumBorder()),
                              child: const Text(
                                mEditprofile,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'VarelaRound',
                                    fontSize: 20.0),
                              ),
                            )),
                        const SizedBox(height: 30),
                        const SizedBox(height: 10),
                        const Divider(color: Colors.grey),
                        const SizedBox(height: 10),
                        ProfileMenuWidget(
                          title: mProfileMenu1,
                          icon: LineAwesomeIcons.info,
                          onPress: () {
                            _showProfileInfoDialog(context);
                          },
                        ),
                        const SizedBox(height: 25),
                        ProfileMenuWidget(
                          title: mProfileMenu2,
                          icon: LineAwesomeIcons.user_friends,
                          onPress: () {
                            _checkExistingMedPartner();
                          },
                        ),
                        const SizedBox(height: 25),
                        ProfileMenuWidget(
                          title: mProfileMenu3,
                          textColor: Colors.redAccent,
                          icon: LineAwesomeIcons.alternate_sign_out,
                          endIcon: false,
                          onPress: () {
                            showLogoutConfirmation();
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ]);
          }),
    );
  }

  void _showProfileInfoDialog(BuildContext context) {
    // Open a stream builder here for real-time updates
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 255, 243, 205),
          title: const Center(
            child: Text(
              mInformationDialogTitle,
              style: TextStyle(
                  color: Color.fromARGB(255, 42, 16, 87),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'RubikDoodleShadow',
                  fontSize: 22.0),
            ),
          ),
          content: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(widget.userId) // Using the current user's ID
                  .collection('Profile Data')
                  .doc(widget.userId)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SpinKitCubeGrid(
                      color: Colors.amber,
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                }
                if (snapshot.hasData &&
                    snapshot.data != null &&
                    snapshot.data!.exists) {
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;
                  String dob = data['DOB'] ?? mNotSpecified;
                  String gender = data['Gender'] ?? mNotSpecified;
                  String address = data['Address'] ?? mNotSpecified;
                  String name = data['Name'] ?? mNotSpecified;
                  String phoneNo = data['Phone No.'] ?? mNotSpecified;
                  // Now using the data to show DOB and Gender
                  return RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: "Name: ",
                          style: TextStyle(
                            fontFamily: "Salsa",
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 113, 34, 3),
                            fontSize: 20,
                          ),
                        ),
                        TextSpan(
                          text: '$name\n\n',
                          style: const TextStyle(
                            fontFamily: "VarelaRound",
                            color: Color.fromARGB(255, 3, 33, 57),
                            fontSize: 20,
                          ),
                        ),
                        const TextSpan(
                          text: mDOB,
                          style: TextStyle(
                            fontFamily: "Salsa",
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 8, 53, 2),
                            fontSize: 20,
                          ),
                        ),
                        TextSpan(
                          text: '$dob\n\n',
                          style: const TextStyle(
                            fontFamily: "VarelaRound",
                            color: Color.fromARGB(255, 3, 33, 57),
                            fontSize: 20,
                          ),
                        ),
                        const TextSpan(
                          text: mGender,
                          style: TextStyle(
                            fontFamily: "Salsa",
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 56, 13, 129),
                            fontSize: 20,
                          ),
                        ),
                        TextSpan(
                          text: '$gender\n\n',
                          style: const TextStyle(
                            fontFamily: "VarelaRound",
                            color: Color.fromARGB(255, 3, 33, 57),
                            fontSize: 20,
                          ),
                        ),
                        const TextSpan(
                          text: "Phone Number: ",
                          style: TextStyle(
                            fontFamily: "Salsa",
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 21, 5, 76),
                            fontSize: 20,
                          ),
                        ),
                        TextSpan(
                          text: '$phoneNo\n\n',
                          style: const TextStyle(
                            fontFamily: "VarelaRound",
                            color: Color.fromARGB(255, 3, 33, 57),
                            fontSize: 20,
                          ),
                        ),
                        const TextSpan(
                          text: "Address: ",
                          style: TextStyle(
                            fontFamily: "Salsa",
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 6, 93, 72),
                            fontSize: 20,
                          ),
                        ),
                        TextSpan(
                          text: '$address\n\n',
                          style: const TextStyle(
                            fontFamily: "VarelaRound",
                            color: Color.fromARGB(255, 3, 33, 57),
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Image.asset(
                    mProfileDataNoRecordImage, // Replace with the actual asset path
                    width: 100.0, // Adjust the width as needed
                    height: 100.0, // Adjust the height as needed
                    fit: BoxFit.contain, // Adjust the fit as needed
                  );
                }
              }),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(mInformationDialogButton,
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontFamily: 'Salsa',
                      fontSize: 22.0)),
            ),
          ],
        );
      },
    );
  }

  //Check Ltr
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        profileImage = File(pickedFile.path);
      });
    }
  }

  void _checkExistingMedPartner() async {
    String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final logger = Logger();

    try {
      // Check if there are any documents in the 'MedPartner' collection for the current user
      QuerySnapshot medPartnerQuerySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUserId)
          .collection('MedPartner')
          .get();

      bool hasExistingMedPartner = medPartnerQuerySnapshot.docs.isNotEmpty;

      if (hasExistingMedPartner) {
        _showConfirmation2();
      } else {
        _showConfirmation();
      }
    } catch (e, stackTrace) {
      logger.e('Error checking existing MedPartner:',
          error: e, stackTrace: stackTrace);
      // Handle error if needed
    }
  }

  void _showConfirmation() async {
    bool? result = await ConfirmationDialog.showConfirmationDialog(
        context, mGeneralConfirmation, mAddMedPartnerDialog, () {}, () {},
        lottieAnimationPath:
            'assets/animations/lottie/Animation - 1704102211072.json');
    if (result == true) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MedPartnerScreen(),
        ),
      );
    }
  }

  void _showConfirmation2() async {
    bool? result = await ConfirmationDialog.showConfirmationDialog(
        context, mGeneralConfirmation, mAdyHaveMedPartnerDialog, () {}, () {},
        cancelButtonText: "Send",
        confirmButtonText: "Update",
        lottieAnimationPath:
            'assets/animations/lottie/Animation - 1704102128921.json');
    if (result == true) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const UpdateMedPartnerScreen(),
        ),
      );
    }
  }

  Future<void> updateAuthenticationStatus(bool isAuthenticated) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_authenticated', isAuthenticated);
  }

  void showLogoutConfirmation() async {
    bool? result = await ConfirmationDialog.showConfirmationDialog(context,
        mHomePageMenu3DialogTitle, mHomePageMenu3DialogSubtitle, () {}, () {},
        lottieAnimationPath:
            'assets/animations/lottie/Animation - 1704102128921.json');
    if (!context.mounted) return;
    if (result == true) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Record the sign out time in Firestore
        await FirebaseFirestore.instance.collection('Users').doc(user.uid).set({
          'lastSignOutTime': DateTime.now(),
        }, SetOptions(merge: true));
      }

      // Sign out the user
      await FirebaseAuth.instance.signOut();
      await updateAuthenticationStatus(false);
      // Navigate to the WelcomePage
      Get.to(() => const WelcomePage());
    }
  }
}
