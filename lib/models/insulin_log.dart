import 'package:hive/hive.dart';

part '../model adapters/insulin_log.g.dart';

// TODO: THERE IS A SPECIAL INSULIN LOG IN THE INSULINLOG BOX. WITH THE KEY "inBlood" THIS LOG CONTAINS THE CURRENT VALUE IN BLOOD OF INSULIN
@HiveType(typeId: 2)
class InsulinLog {
  
  @HiveField(0)
  double fastinsulin_dose = 0;
  
  @HiveField(1)
  double basalinsulin_dose = 0;

  @HiveField(2)
  int before_after = 0;

  @HiveField(3)
  DateTime? dateTime;


  InsulinLog(double fastinsulin_dose, double basalinsulin_dose, int before_after, DateTime dateTime){

    this.fastinsulin_dose = fastinsulin_dose;
    this.basalinsulin_dose = basalinsulin_dose;
    this.before_after = before_after;
    this.dateTime = dateTime;

  }
  
}