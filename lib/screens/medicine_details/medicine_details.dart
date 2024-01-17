import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:medapp/common/confirmation_dialog.dart';
import 'package:medapp/constant/colors.dart';
import 'package:medapp/constant/text_string.dart';
import 'package:medapp/screens/home_page/home_page.dart';
import 'package:medapp/screens/medicine_details/update_medicine_details.dart';
import 'package:medapp/screens/medicine_details/widgets/extended_section.dart';
import 'package:medapp/screens/medicine_details/widgets/main_section.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MedicineDetails extends StatefulWidget {
  const MedicineDetails(
      {super.key,
      required this.medicineData,
      required this.documentId,
      required this.userId});
  final Map<String, dynamic> medicineData;
  final String documentId;
  final String userId;

  @override
  State<MedicineDetails> createState() => _MedicineDetailsState();
}

class _MedicineDetailsState extends State<MedicineDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          mMDAppBarTitle,
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
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              _showConfirmation2();
              //Do it later/ future work...
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(2.h),
        child: Column(
          children: [
            MainSection(medicineData: widget.medicineData),
            SizedBox(
              height: 4.h,
            ),
            ExtendedSection(medicineData: widget.medicineData),
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
                  openAlertBox(context, widget.documentId);
                },
                child: const Text(mDelete,
                    style: TextStyle(
                        fontFamily: "VarelaRound",
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }

  openAlertBox(BuildContext context, String documentId) {
    // Retrieve the current user's ID
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    // Check if a user is signed in
    if (userId == null) {
      Get.snackbar('Error', 'No user signed in',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    } else {
      _showConfirmation(userId);
    }
  }

  void _showConfirmation(String userId) async {
    bool? result = await ConfirmationDialog.showConfirmationDialog(
        context, mMDConfirmationTitle, "", () {}, () {},
        lottieAnimationPath:
            'assets/animations/lottie/Animation - 1704099431942.json');
    if (result == true) {
      try {
        // Reference to the medication reminder document
        DocumentReference reminderRef = FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .collection('Medication Reminders')
            .doc(widget.documentId);

        // Get the list of notification IDs from the document
        DocumentSnapshot documentSnapshot = await reminderRef.get();
        Map<String, dynamic>? data =
            documentSnapshot.data() as Map<String, dynamic>?;

        if (data != null && data.containsKey('notificationIDs')) {
          List<dynamic> notificationIDs = data['notificationIDs'];

          // Cancel each scheduled notification using its ID
          FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
              FlutterLocalNotificationsPlugin();
          for (int i = 0; i < notificationIDs.length; i++) {
            await flutterLocalNotificationsPlugin.cancel(notificationIDs[i]);
          }
        }

        // Delete the document for the signed-in user
        await reminderRef.delete();

        await addNotification(
            "New Reminders!!!",
            userId,
            widget.medicineData["medicationName"],
            widget.medicineData["dosage"],
            widget.medicineData["startTime"],
            widget.medicineData["medicineType"].toString());
        Get.offAll(() => HomePage(userId: widget.userId));
      } catch (e) {
        // Handle any errors with a snackbar
        Get.snackbar("Error", "Failed to delete document: $e",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    }
  }

  Future<void> addNotification(
      String title,
      String userId,
      String medicationName,
      dynamic dosage,
      String startTime,
      String medicineType) async {
    String message =
        "You have delete a reminder at $startTime for $medicationName with $dosage mg in the form of $medicineType successfully. ";
    DateTime now = DateTime.now();
    CollectionReference inAppNotifications = FirebaseFirestore.instance
        .collection("Users")
        .doc(userId)
        .collection("In App Notifications");

    await inAppNotifications.add({
      'title': title,
      'message': message,
      'timestamp': now,
      'read': false,
    });
  }

  void _showConfirmation2() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    // Check if a user is signed in
    if (userId == null) {
      Get.snackbar('Error', 'No user signed in',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    bool? result = await ConfirmationDialog.showConfirmationDialog(
        context, mMDConfirmationTitle2, mMDConfirmationContent2, () {}, () {},
        lottieAnimationPath:
            'assets/animations/lottie/Animation - 1704100271063.json');

    if (result == true) {
      try {
        // Reference to the medication reminder document
        DocumentReference reminderRef = FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .collection('Medication Reminders')
            .doc(widget.documentId);

        // Get the list of notification IDs from the document
        DocumentSnapshot documentSnapshot = await reminderRef.get();
        Map<String, dynamic>? data =
            documentSnapshot.data() as Map<String, dynamic>?;

        if (data != null && data.containsKey('notificationIDs')) {
          List<dynamic> notificationIDs = data['notificationIDs'];

          // Cancel each scheduled notification using its ID
          FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
              FlutterLocalNotificationsPlugin();
          for (int i = 0; i < notificationIDs.length; i++) {
            await flutterLocalNotificationsPlugin.cancel(notificationIDs[i]);
          }
        }
      } catch (e) {
        // Handle any errors with a snackbar
        Get.snackbar("Error", "Failed to delete document: $e",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
      if (!context.mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UpdateMedicineDetailsScreen(
                  eMedicationName: widget.medicineData["medicationName"],
                  eStartTime: widget.medicineData["startTime"],
                  eInterval: widget.medicineData["interval"],
                  eDocumentId: widget.medicineData["id"],
                  userId: userId,
                  eMedicineType: widget.medicineData["medicineType"],
                  eDosage: widget.medicineData["dosage"],
                  eExtInfo: widget.medicineData["extraInfo"],
                  eTreatmentDuration: widget.medicineData["treatmentDuration"],
                )),
      );
    }
  }
}
