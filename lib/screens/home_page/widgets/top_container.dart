import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:medapp/constant/text_string.dart';
import 'package:sizer/sizer.dart';

class TopContainer extends StatelessWidget {
  const TopContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.only(
            bottom: 1.h,
          ),
          child: const Text(
            mHomPageHeading,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Color.fromARGB(255, 18, 17, 16),
                fontFamily: 'Satisfy',
                fontWeight: FontWeight.bold,
                fontSize: 36.0),
          ),
        ),
        Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.only(
            bottom: 1.h,
          ),
          child: const Text(
            mHomePageSubheading,
            style: TextStyle(
                color: Color.fromARGB(255, 18, 17, 16),
                fontFamily: 'Satisfy',
                fontWeight: FontWeight.normal,
                fontSize: 24.0),
          ),
        ),
        SizedBox(
          height: 2.h,
        ),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseAuth.instance.currentUser != null
              ? FirebaseFirestore.instance
                  .collection('Users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('Medication Reminders')
                  .snapshots()
              : const Stream.empty(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: SpinKitCubeGrid(
                  color: Colors.amber,
                ),
              );
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Text('');
            }

            // Display the count of documents
            return Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 1.h),
              child: Text(
                  '${snapshot.data!.docs.length} ${snapshot.data!.docs.length > 1 ? 'reminders' : 'reminder'}',
                  style: const TextStyle(
                      color: Color.fromARGB(255, 41, 14, 87),
                      fontFamily: "Salsa",
                      fontWeight: FontWeight.bold,
                      fontSize: 24)),
            );
          },
        )
      ],
    );
  }
}
