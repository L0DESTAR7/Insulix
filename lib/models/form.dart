enum Gender{
  male,
  female
}
enum UnitSys{
  imperial,
  metric
}
enum InsulinUnit{
  mmolL,
  mgdl
}
class InsulixForm{
  int currentPage = 0; // Index to track the current page
  Gender gender = Gender.male; // Gender defaults to male
  UnitSys unitSys = UnitSys.metric; // Unit system defaults to metric
  DateTime? birthdate; // Holds the birthdate of user, later used to calculate age.
  // TODO: For now [birthdate] variable is useless because Page2 of the form is skipped. Implement later!
  bool pills = false; // true = Takes pills | false = doesn't take pills
  bool insulin = false; //TODO: Fix the app form, it says "insuline" should be "insulin"
  int type = 1; // Type1 = 1 | Type2 = 2 | Gestational = 3 | LADA = 4 | MODY = 5
  InsulinUnit insulinUnit = InsulinUnit.mmolL; // Insulix defaults the insuline level unit to mmol/l
}