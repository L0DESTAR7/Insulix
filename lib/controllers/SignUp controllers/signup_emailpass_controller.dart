import 'package:insulix/models/insulixUser.dart';
import 'package:insulix/services/auth_service.dart';
import 'package:rive/rive.dart';

class EmailPassController {
  static String? email;
  static String? password;
  static String? confirmPassword;

  static bool? verifyEmail({String? email}) {
    /// Return a boolean to check if Email is valid. If no parameter is provided
    /// return null.
    if (email != null) {
      bool valid = RegExp(
              r"^([a-z0-9])(([\-.]|[_]+)?([a-z0-9]+))*(@)([a-z0-9])((([-]+)?([a-z0-9]+))?)*((.[a-z]{2,3})?(.[a-z]{2,6}))$")
          .hasMatch(email);
      return valid;
    }

    return null;
  }

  static bool? verifyPassword({String? password}) {
    /// Return a boolean to check if Email is valid. If no parameter is provided
    /// return null.
    if (password != null) {
      bool valid = RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$")
          .hasMatch(password);
      return valid;
    }

    return null;
  }

  static bool? verifyConfirmPassword(
      {String? confirmPassword, String? password}) {
    if (confirmPassword != null && password != null) {
      bool valid = false;
      valid = confirmPassword == password ? true : false;
      return valid;
    }

    return null;
  }

  static bool verifyCredentials() {
    /// Only returns true when strictly every input is valid and not null.
    return ((verifyEmail(email: email) ?? false) &&
        (verifyPassword(password: password) ?? false) &&
        (verifyConfirmPassword(
                confirmPassword: confirmPassword, password: password) ??
            false));
  }


  static String checkOut() {
    String s = "";
    s = "EmailPassController instance: Email: $email | Password: "
        "$password | Confirmed Password: $confirmPassword | "
        "Status: ${verifyCredentials()}";
    return s;
  }

  static Future register(AuthService auth) async {
    return auth.signUpWithEmailAndPassword(email!,password!);
  }

  static void sendEmailPassRegistry(InsulixUser? insulixUser, SMITrigger? successTrigger){
    if (insulixUser == null){
      refuseRegistry();
    } else {
      acceptRegistry(successTrigger);
    }
  }

  static void refuseRegistry(){
    // TODO: Add registry refusal behaviour and indicators.
    print("Registry error ! Registration refused.");
  }

  static void acceptRegistry(SMITrigger? trigger){
    // TODO: Add registry success behaviour and indicators.
    print("Registration successful ! Proceeding...");
    trigger?.fire();
  }

}
