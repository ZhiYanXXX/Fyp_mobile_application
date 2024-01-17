import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medapp/models/medicine_name.dart';
import 'package:medapp/screens/home_page/widgets/medicine_card_widget.dart';
import 'package:sizer/sizer.dart';

class BottomContainer extends StatelessWidget {
  const BottomContainer({super.key, required this.userId});
  final String? userId;

  @override
  Widget build(BuildContext context) {
    final MedicationNamesModel medicationNamesModel = MedicationNamesModel();

    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseAuth.instance.currentUser != null
            ? FirebaseFirestore.instance
                .collection('Users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('Medication Reminders')
                .snapshots()
            : const Stream.empty(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Container();
          } else if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Image.asset(
                'assets/images/no_record_latest.png',
                width: 300.0,
                height: 300.0,
                fit: BoxFit.contain,
              ),
            );
          } else {
            return GridView.builder(
              padding: EdgeInsets.only(top: 1.h),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];

                Map<String, dynamic> medicineData =
                    documentSnapshot.data() as Map<String, dynamic>? ?? {};

                return MedicineCard(
                  userId: userId!,
                  medicineData: medicineData,
                  medicationNamesModel: medicationNamesModel,
                );
              },
            );
          }
        });
  }
}
