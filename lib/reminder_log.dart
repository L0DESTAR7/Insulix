
class ReminderLog {
  List<int> days = []; // MON = 0 | .... | SUN = 6
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