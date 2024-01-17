import 'dart:async';

import 'package:medapp/models/medicine_type.dart';

class MedicineTypeController {
  final StreamController<MedicineType> _medicineTypeController =
      StreamController<MedicineType>.broadcast();

  Stream<MedicineType> get medicineTypeStream => _medicineTypeController.stream;

  MedicineType _selectedMedicineType = MedicineType.none;

  MedicineType get selectedMedicineType => _selectedMedicineType;

  // Method to toggle the selection state
  void toggleMedicineType(MedicineType type) {
    if (_selectedMedicineType == type) {
      // Deselect if already selected
      _selectedMedicineType = MedicineType.none;
    } else {
      // Select if not selected
      _selectedMedicineType = type;
    }

    // Notify listeners or update the UI as needed
    _medicineTypeController.sink.add(_selectedMedicineType);
  }

  // Method to deselect the current medicine type
  void deselectMedicineType() {
    _selectedMedicineType = MedicineType.none;

    // Notify listeners or update the UI as needed
    _medicineTypeController.sink.add(_selectedMedicineType);
  }

  void dispose() {
    _medicineTypeController.close();
  }
}
