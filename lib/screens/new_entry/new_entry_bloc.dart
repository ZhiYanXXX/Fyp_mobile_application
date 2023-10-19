import 'package:medapp/models/errors.dart';
import 'package:medapp/models/medicine_type.dart';
import 'package:rxdart/rxdart.dart';

class NewEntryBloc {
  // BehaviorSubject to manage the selected medicine type
  BehaviorSubject<MedicineType>? _selectedMedicineType$;
  ValueStream<MedicineType>? get selectedMedicineType =>
      _selectedMedicineType$!.stream;

  // BehaviorSubject to manage the selected interval
  BehaviorSubject<int>? _selectedInterval$;
  BehaviorSubject<int>? get selectIntervals => _selectedInterval$;

  // BehaviorSubject to manage the selected time of day
  BehaviorSubject<String>? _selectedTimeOfDay$;
  BehaviorSubject<String>? get selectedTimeOfDay$ => _selectedTimeOfDay$;

  // BehaviorSubject to manage error state
  BehaviorSubject<EntryError>? _errorState$;
  BehaviorSubject<EntryError>? get errorState$ => _errorState$;

  // Constructor to initialize the BehaviorSubjects with initial values
  NewEntryBloc() {
    _selectedMedicineType$ =
        BehaviorSubject<MedicineType>.seeded(MedicineType.none);
    _selectedTimeOfDay$ = BehaviorSubject<String>.seeded('none');
    _selectedInterval$ = BehaviorSubject<int>.seeded(0);
    _errorState$ = BehaviorSubject<EntryError>();
  }

  // Method to dispose of the BehaviorSubjects when they are no longer needed
  void dispose() {
    _selectedMedicineType$!.close();
    _selectedTimeOfDay$!.close();
    _selectedInterval$!.close();
  }

  // Method to submit an error to the error state
  void submitError(EntryError error) {
    _errorState$!.add(error);
  }

  // Method to update the selected interval
  void updateInterval(int interval) {
    _selectedInterval$!.add(interval);
  }

  // Method to update the selected time of day
  void updateTime(String time) {
    _selectedTimeOfDay$!.add(time);
  }

  // Method to update the selected medicine type
  void updateSelectedMedicine(MedicineType type) {
    MedicineType tempType = _selectedMedicineType$!.value;
    if (type == tempType) {
      _selectedMedicineType$!.add(MedicineType.none);
    } else {
      _selectedMedicineType$!.add(type);
    }
  }
}
