// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class MedPartnerScreen extends StatefulWidget {
  const MedPartnerScreen({super.key});

  @override
  _MedPartnerScreenState createState() => _MedPartnerScreenState();
}

class _MedPartnerScreenState extends State<MedPartnerScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameC = TextEditingController();
  final TextEditingController _emailC = TextEditingController();
  final TextEditingController _phoneNoC = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _emailC.dispose();
    _nameC.dispose();
    _phoneNoC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 253, 237, 187),
      appBar: AppBar(
        title: const Text(
          'Add a MedPartner',
          style: TextStyle(
              color: Color.fromARGB(255, 45, 34, 30),
              fontFamily: 'VarelaRound',
              fontSize: 24.0),
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
                const Color.fromARGB(255, 253, 237, 187)
                    .withOpacity(0.4), // Adjust opacity value as needed
                BlendMode.dstATop,
              ),
              child: Image.asset(
                'assets/images/medpartner_bg.png',
                width: 200.0,
                height: 200.0,
              ),
            )),
        Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: _emailC,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  hintText: 'E.g. lg@gmail.com',
                ),
                validator: (value) {
                  // Add your validation logic here if any
                  return null;
                },
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _nameC,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  hintText: 'E.g. Steven',
                ),
                validator: (value) {
                  // Add your validation logic here if any
                  return null;
                },
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _phoneNoC,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  hintText: 'E.g. +601112345678',
                ),
                validator: (value) {
                  // Add your validation logic here if any
                  return null;
                },
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (_formKey.currentState!.validate()) {
                    createMedPartnerProfile();
                  }
                },
                style: ElevatedButton.styleFrom(
                    elevation: 5.0,
                    backgroundColor: const Color.fromARGB(255, 255, 209, 72),
                    side: BorderSide.none,
                    shape: const StadiumBorder()),
                child: const Text(
                  'Add MedPartner',
                  style: TextStyle(
                      color: Color.fromARGB(255, 18, 17, 16),
                      fontFamily: 'VarelaRound',
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Future<void> createMedPartnerProfile() async {
    // Get the current user's ID
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    try {
      if (userId != null) {
        // Update the user's profile information in Firestore
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId) // Use the userId of the signed-in user
            .collection('MedPartner')
            .doc(userId)
            .set({
          'Email': _emailC.text,
          'Name': _nameC.text,
          'Phone Number': _phoneNoC.text,
        });

        // Show a success message using GetX
        Get.snackbar('Success', 'MedPartner is added successfully!',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        // Handle the case when the current user is null
        Get.snackbar('Error', 'User is not signed in!',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      // If an error occurs, show an error message using GetX
      Get.snackbar('Error', 'Failed to add a MedPartner: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
