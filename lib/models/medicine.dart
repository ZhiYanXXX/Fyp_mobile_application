class MedicationReminder {
  final List<dynamic>? notificationIDs;
  final String uniqueID;
  final String medicineName;
  dynamic dosage;
  String? medicineType;
  int interval;
  String startTime;
  String? treatmentDuration;
  String? extInfo;
  final String createdTime;
  bool isStarred = false;

  MedicationReminder({
    required this.isStarred,
    this.extInfo,
    required this.uniqueID,
    this.treatmentDuration,
    required this.notificationIDs,
    required this.medicineName,
    this.dosage,
    this.medicineType,
    required this.interval,
    required this.startTime,
    required this.createdTime,
  });

  //Geters
  String get getUniqueID => uniqueID;
  String get getMedicationName => medicineName;
  dynamic get getDosage => dosage!;
  String get getType => medicineType!;
  int get getInterval => interval;
  String get getStartTime => startTime;
  String get getTreatmentDuration => treatmentDuration!;
  List<dynamic> get getIDs => notificationIDs!;
  String get getExtInfo => extInfo!;
  bool get getIsStarred => isStarred;

  Map<String, dynamic> toJson() {
    return {
      'Reminder IDs': notificationIDs,
      'Unique ID': uniqueID,
      'Medicine Name': medicineName,
      'Dosage (mg)': dosage,
      'Medicine Type': medicineType,
      'Interval': interval,
      'Start': startTime,
      'Treatment Duration?': treatmentDuration,
      'Extra Info': extInfo,
      'isStarred': isStarred
    };
  }

  // Factory method to create MedicationReminder from Firestore data
  factory MedicationReminder.fromFirestore(Map<String, dynamic> data) {
    return MedicationReminder(
      notificationIDs: data['notificationIDs'],
      medicineName: data['medicationName'],
      uniqueID: data["id"],
      dosage: data['dosage'],
      medicineType: data['medicineType'],
      interval: data['interval'],
      startTime: data['startTime'],
      treatmentDuration: data['treatmentDuration'],
      extInfo: data['extraInfo'],
      isStarred: data['isStarred'],
      createdTime: data['createdTime'],
    );
  }
}
