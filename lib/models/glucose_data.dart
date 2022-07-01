import 'package:hive/hive.dart';

part '../model adapters/glucose_data.g.dart';

@HiveType(typeId: 0)
class GlucoseData extends HiveObject {

  // ATTRIBUTES -------------------
  @HiveField(0)
  double latestLog = 0;
  @HiveField(1)
  List<double> Logs = [0]; // List of the glucose logs of the user.
  @HiveField(2)
  List<int> BeforeAfter = [0]; // List of Before / After logs.
                               /// The i-th item corresponds to whether the log
                              /// happened before or after the meal.
                             /// 0 <--> After   |   1 <--> Before
  @HiveField(3)
  List<DateTime> LogTime = []; // List of DateTime objects of every log.
                               /// The i-th item corresponds to the dateTime of
                              /// the i-th Log.
  // ------------------------------

  // METHODS ----------------------
  void addLog(double log,int before_after,DateTime dateTime){
    Logs.add(log);
    BeforeAfter.add(before_after);
    LogTime.add(dateTime);
    latestLog = log;
  }

  void deleteLastLog(){
    Logs.removeLast();
    BeforeAfter.removeLast();
    LogTime.removeLast();
    latestLog = Logs.last;
  }

  double computeAVG(){
    double sum = 0;
    int n = Logs.length;
    Logs.forEach((element) {
      sum += element;
    });
    return (sum/n);
  }
// ------------------------------
}