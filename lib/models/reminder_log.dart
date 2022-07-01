
class ReminderLog {
  List<int> days = []; // SUN = 1 | MON = 2 | ... | SAT = 7. View "https://developer.android.com/reference/java/util/Calendar#SUNDAY" for more info.
  DateTime dateTime = DateTime.now();
  bool periodic = false;
  String comment = "";

  ReminderLog(List<int> days, DateTime dateTime, bool periodic, String comment){
    this.days = days;
    this.dateTime = dateTime;
    this.periodic = periodic;
    this.comment = comment;
  }
}