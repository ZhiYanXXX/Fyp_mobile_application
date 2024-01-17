import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:medapp/common/confirmation_dialog.dart';
import 'package:medapp/constant/colors.dart';
import 'package:medapp/constant/image_string.dart';
import 'package:medapp/constant/text_string.dart';

class InAppNotificationScreen extends StatefulWidget {
  const InAppNotificationScreen({super.key, required this.userId});
  final String userId;

  @override
  State<InAppNotificationScreen> createState() =>
      _InAppNotificationScreenState();
}

class _InAppNotificationScreenState extends State<InAppNotificationScreen> {
  int unreadCount = 0;
  bool isDropdownOpen = false;
  List<String> expandedNotifications = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 234, 215),
      appBar: AppBar(
        title: const Row(
          children: [
            Text(
              mNPAppBarTitle,
            ),
            Icon(
              Icons.notifications_outlined,
              color: Colors.white,
              size: 25,
            )
          ],
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          icon: const Icon(
            LineAwesomeIcons.angle_left,
            weight: BouncingScrollSimulation.maxSpringTransferVelocity,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () {
              _showConfirmation2();
            },
          ),
        ],
      ),
      body: FutureBuilder(
          future: getAllInAppNotifications(widget.userId),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: SpinKitCubeGrid(
                  color: Colors.amber,
                ),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<DocumentSnapshot> notifications =
                  snapshot.data as List<DocumentSnapshot>;
              return notifications.isEmpty
                  ? buildNoNotificationsImage()
                  : ListView.builder(
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        bool isRead = notifications[index]['read'];
                        bool isExpanded = expandedNotifications
                            .contains(notifications[index].id);
                        // Replace with your notification UI
                        return Card(
                          color: isRead
                              ? const Color.fromARGB(255, 250, 241, 213)
                              : Colors.amber,
                          child: ListTile(
                            title: Text(
                              notifications[index]['title'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isExpanded
                                      ? notifications[index]['message']
                                      : '${notifications[index]['message'].substring(0, notifications[index]['message'].length ~/ 2)}...',
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (isExpanded) {
                                        expandedNotifications
                                            .remove(notifications[index].id);
                                      } else {
                                        expandedNotifications
                                            .add(notifications[index].id);
                                      }
                                    });
                                    if (!isRead) {
                                      markNotificationAsRead(
                                          widget.userId, notifications[index]);
                                      //Update the unread count after marking as read
                                      updateUnreadCount(widget.userId);
                                    }
                                  },
                                  child: Text(
                                    isExpanded ? 'Read Less' : 'Read More',
                                    style: const TextStyle(color: Colors.blue),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        _showConfirmation(notifications, index);
                                      },
                                      child: const Icon(Icons.delete),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      });
            }
          })),
    );
  }

  void _showConfirmation2() async {
    bool? result = await ConfirmationDialog.showConfirmationDialog(
        context, mNPConfirmationTitle2, mNPConfirmationContent2, () {}, () {},
        lottieAnimationPath:
            'assets/animations/lottie/Animation - 1704099431942.json');
    if (result == true) {
      clearAllNotifications(widget.userId);
    }
  }

  void _showConfirmation(
      List<DocumentSnapshot> notifications, int index) async {
    bool? result = await ConfirmationDialog.showConfirmationDialog(
        context, mNPConfirmationTitle, mNPConfirmationContent, () {}, () {},
        lottieAnimationPath:
            'assets/animations/lottie/Animation - 1704102159657.json');
    if (result == true) {
      deleteNotification(widget.userId, notifications[index]);
    }
  }

  void displayError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: kOtherColor,
      content: Text(error),
      duration: const Duration(milliseconds: 2000),
    ));
  }

  Future<List<DocumentSnapshot>> getAllInAppNotifications(String userId) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('In App Notifications')
        .get();

    return querySnapshot.docs;
  }

  Future<void> markNotificationAsRead(
      String userId, DocumentSnapshot notification) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('In App Notifications')
        .doc(notification.id)
        .update({'read': true});

    setState(() {
      unreadCount--;
    });
  }

  Future<void> updateUnreadCount(String userId) async {
    List<DocumentSnapshot> unreadNotifications =
        await getUnreadInAppNotifications(userId);
    setState(() {
      unreadCount = unreadNotifications.length;
    });
  }

  Future<List<DocumentSnapshot>> getUnreadInAppNotifications(
      String userId) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('In App Notifications')
        .where('read', isEqualTo: false)
        .get();

    return querySnapshot.docs;
  }

  Future<void> deleteNotification(
      String userId, DocumentSnapshot notification) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('In App Notifications')
        .doc(notification.id)
        .delete();

    // Update the unread count and refresh the notification list
    updateUnreadCount(userId);
  }

  Future<void> clearAllNotifications(String userId) async {
    // Fetch all notifications and delete them
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('In App Notifications')
        .get();

    for (QueryDocumentSnapshot notification in querySnapshot.docs) {
      await notification.reference.delete();
    }
    setState(() {
      getAllInAppNotifications(userId);
    });
  }

  Widget buildNoNotificationsImage() {
    return Center(
      child: Image.asset(
        mInAppNPImage,
        width: 300.0, // Adjust the width as needed
        height: 300.0, // Adjust the height as needed
      ),
    );
  }
}
