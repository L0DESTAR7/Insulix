import 'package:hive/hive.dart';

part 'glucose_log.g.dart';

@HiveType(typeId: 1)
class GlucoseLog{
  
  @HiveField(0)
  double log = 0;
  @HiveField(1)
  int before_after = 0;
  @HiveField(2)
  DateTime? dateTime;
  
  GlucoseLog(double log,int before_after,DateTime dateTime){
    this.log = log;
    this.before_after = before_after;
    this.dateTime = dateTime;
  }
}