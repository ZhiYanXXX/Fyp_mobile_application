// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:logger/logger.dart';
import 'package:medapp/common/confirmation_dialog.dart';
import 'package:medapp/constant/colors.dart';
import 'package:medapp/constant/text_string.dart';
import 'package:sizer/sizer.dart';

class UpdateMedPartnerScreen extends StatefulWidget {
  const UpdateMedPartnerScreen({super.key});

  @override
  _UpdateMedPartnerScreenState createState() => _UpdateMedPartnerScreenState();
}

class _UpdateMedPartnerScreenState extends State<UpdateMedPartnerScreen> {
  final String currentUserId =
      FirebaseAuth.instance.currentUser?.uid ?? 'Unknown';

  late TextEditingController _emailController;
  late TextEditingController _nameController;
  late TextEditingController _phoneNoController;
  bool isReadOnly = true; // Move the variable to the widget state

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _nameController = TextEditingController();
    _phoneNoController = TextEditingController();
    _fetchMedPartnerData();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _phoneNoController.dispose();
  }

  Future<void> _fetchMedPartnerData() async {
    final logger = Logger();
    try {
      QuerySnapshot<Map<String, dynamic>> medPartnerSnapshot =
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(currentUserId)
              .collection('MedPartner')
              .get();

      // Check if there are documents in the query snapshot
      if (medPartnerSnapshot.docs.isNotEmpty) {
        // Assuming you want to get the first document in the query result
        QueryDocumentSnapshot<Map<String, dynamic>> firstDocument =
            medPartnerSnapshot.docs.first;
        Map<String, dynamic> medPartnerData = firstDocument.data();
        _emailController.text = medPartnerData['Email'];
        _nameController.text = medPartnerData['Name'];
        _phoneNoController.text = medPartnerData['Phone Number'];
      } else {
        // Handle the case when the MedPartner data doesn't exist
        Get.snackbar('Error', 'MedPartner data not found!',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e, stackTrace) {
      logger.e('Error fetching MedPartner data:',
          error: e, stackTrace: stackTrace);
      // Handle error if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          mUpdateMedPartnerScreenAppBarTitle,
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
      body: Stack(children: [
        Positioned.fill(
            bottom: -200,
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                const Color.fromARGB(255, 245, 236, 208)
                    .withOpacity(0.4), // Adjust opacity value as needed
                BlendMode.dstATop,
              ),
              child: Image.asset(
                'assets/images/update_medPartner_bg_pic.png',
                width: 200.0,
                height: 200.0,
              ),
            )),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildEditableTextField(mEmail, true, _emailController),
              const SizedBox(height: 30),
              buildEditableTextField(mFullName, true, _nameController),
              const SizedBox(height: 30),
              buildEditableTextField(mPhoneNo, true, _phoneNoController),
              const SizedBox(height: 30),
              Center(
                child: SizedBox(
                  width: 100.w,
                  child: ElevatedButton(
                    onPressed: _showConfirmation2,
                    style: ElevatedButton.styleFrom(
                        elevation: 5.0,
                        backgroundColor:
                            const Color.fromARGB(255, 255, 209, 72),
                        side: BorderSide.none,
                        shape: const StadiumBorder()),
                    child: const Text(
                      mUMPSButton1,
                      style: TextStyle(
                          color: Color.fromARGB(255, 18, 17, 16),
                          fontFamily: 'VarelaRound',
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: 100.w,
                height: 14.w,
                child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: kSecondaryColor,
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () async {
                      _showConfirmation();
                    },
                    child: const Text(
                      mUMPSButton2,
                      style: TextStyle(
                          color: Color.fromARGB(255, 241, 241, 241),
                          fontFamily: 'VarelaRound',
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    )),
              )
            ],
          ),
        ),
      ]),
    );
  }

  Widget buildEditableTextField(
      String labelText, bool isBold, TextEditingController controller) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: labelText,
              labelStyle: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
            ),
            readOnly: isReadOnly,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            // Toggle the read-only state
            setState(() {
              isReadOnly = !isReadOnly;
            });
          },
        ),
      ],
    );
  }

  Future<void> _updateMedPartnerData() async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUserId)
          .collection('MedPartner')
          .doc(currentUserId)
          .set({
        'Email': _emailController.text,
        'Name': _nameController.text,
        'Phone Number': _phoneNoController.text,
      });

      Get.snackbar('Success', 'MedPartner data updated!',
          backgroundColor: Colors.green, colorText: Colors.white);
      Navigator.pop(context);
    } catch (e) {
      Get.snackbar('Error', 'Failed to update MedPartner data!',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> _deleteMedPartner() async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUserId)
          .collection('MedPartner')
          .doc(currentUserId)
          .delete();

      Get.snackbar('Success', 'MedPartner deleted!',
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete MedPartner!',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  void _showConfirmation2() async {
    bool? result = await ConfirmationDialog.showConfirmationDialog(
        context, mUMPSDialogTitle2, mUMPSDialogSubtitle2, () {}, () {},
        lottieAnimationPath:
            'assets/animations/lottie/Animation - 1704102159657.json');
    if (result == true) {
      await _updateMedPartnerData();
    }
  }

  void _showConfirmation() async {
    bool? result = await ConfirmationDialog.showConfirmationDialog(
        context, mUMPSDialogTitle, mUMPSDialogSubtitle, () {}, () {},
        lottieAnimationPath:
            'assets/animations/lottie/Animation - 1704102159657.json');
    if (result == true) {
      await _deleteMedPartner();
      Navigator.of(context).pop();
    }
  }
}
