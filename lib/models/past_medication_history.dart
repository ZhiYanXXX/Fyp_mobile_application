class PastMedicationHistory {
  final String id;
  final String illness;
  final String howToTreate;
  final dynamic dosage;

  final String? startDate;
  final String? endDate;
  final String effectiveness;

  PastMedicationHistory(
      {required this.id,
      required this.illness,
      required this.howToTreate,
      required this.dosage,
      required this.startDate,
      required this.endDate,
      required this.effectiveness});

  String get getId => id;
  String get getIllness => illness;
  String get getHowToTreate => howToTreate;
  dynamic get getDosage => dosage;

  String? get getStartDate => startDate;
  String? get getEndDate => endDate;
  String get getEffectiveness => effectiveness;

  factory PastMedicationHistory.fromFirestore(Map<String, dynamic> data) {
    return PastMedicationHistory(
        id: data["id"],
        illness: data["illness"],
        howToTreate: data["howToTreate"],
        dosage: data["dosage"],
        startDate: data["startDate"],
        endDate: data["endDate"],
        effectiveness: data["effectiveness"]);
  }
}
