import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:insulix/controllers/SignUp%20controllers/signup_emailpass_controller.dart' show EmailPassController;

class EmailPassForm extends StatefulWidget {
  /// The position coordinates of the 5 form fields, where pos1.first represents
  /// x1 and pos2.last represents y1.
  final List<double>? pos1;

  final List<double>? pos2;

  final List<double>? pos3;

  final List<double>? pos4;

  final List<double>? pos5;

  SMIBool? onChange;

  SMIBool? verifyStatus1;

  SMIBool? verifyStatus2;

  SMIBool? verifyStatus3;



  EmailPassForm(
      {Key? key,
      this.pos1,
      this.pos2,
      this.pos3,
      this.pos4,
      this.pos5,
      this.onChange,
      this.verifyStatus1,
      this.verifyStatus2,
      this.verifyStatus3})
      : super(key: key);


  @override
  State<EmailPassForm> createState() => _EmailPassFormState();
}

class _EmailPassFormState extends State<EmailPassForm> {
  final TextEditingController _firstNameFieldController = TextEditingController();

  final TextEditingController _lastNameFieldController = TextEditingController();

  final TextEditingController _emailFieldController = TextEditingController();

  final TextEditingController _passwordFieldController = TextEditingController();

  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: buildForm(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print("EMAIL PASS FORM LOADED !!");
          return snapshot.data as Widget;
        }
        return Container();
      },
    );
  }

  Future<Widget> buildForm() async {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Positioned(
        top: height * 0.29,
        left: width * 0.1,
        child: Container(
          color: const Color(0xB2FF),
          width: width * 0.8,
          height: height * 0.55,
          child: Column(
            children: [
              Container(
                height: 480,
                child: Stack(children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: widget.pos1!.last,
                        horizontal: widget.pos1!.first),
                    child: Container(
                      width: 240,
                      child: TextFormField(
                          maxLines: 1,
                          controller: _firstNameFieldController,
                          style: const TextStyle(
                            fontFamily: "Lexend",
                            fontWeight: FontWeight.w200,
                            fontSize: 16,
                            color: Color(0xC7FFFFFF),
                          ),
                          decoration: const InputDecoration(
                            hintText: "Enter your first name...",
                            hintStyle: TextStyle(
                                color: Color(0x7AFFFFFF), letterSpacing: -1),
                            border: InputBorder.none,
                          )),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: widget.pos2!.last,
                        horizontal: widget.pos2!.first),
                    child: Container(
                      width: 240,
                      child: TextFormField(
                          maxLines: 1,
                          controller: _lastNameFieldController,
                          style: const TextStyle(
                            fontFamily: "Lexend",
                            fontWeight: FontWeight.w200,
                            fontSize: 16,
                            color: Color(0xC7FFFFFF),
                          ),
                          decoration: const InputDecoration(
                            hintText: "Enter your last name...",
                            hintStyle: TextStyle(
                                color: Color(0x7AFFFFFF), letterSpacing: -1),
                            border: InputBorder.none,
                          )),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: widget.pos3!.last,
                        horizontal: widget.pos3!.first),
                    child: SizedBox(
                      width: 240,
                      child: TextFormField(
                          maxLines: 1,
                          controller: _emailFieldController,
                          onTap: (){
                            widget.onChange?.value = true;
                          },
                          onChanged: (String input){
                            bool valid = EmailPassController.verifyEmail(email: input)!;
                            EmailPassController.email = input;
                            if (valid){
                              widget.verifyStatus1?.value = true;
                            }
                            else {
                              widget.verifyStatus1?.value = false;
                            }
                          },
                          style: const TextStyle(
                            fontFamily: "Lexend",
                            fontWeight: FontWeight.w200,
                            fontSize: 16,
                            color: Color(0xC7FFFFFF),
                          ),
                          decoration: const InputDecoration(
                            hintText: "Enter your email...",
                            hintStyle: TextStyle(
                                color: Color(0x7AFFFFFF), letterSpacing: -1),
                            border: InputBorder.none,
                          )),
                    ),
                  ),
                  Positioned(
                    left: widget.pos4?.first,
                    top: widget.pos4?.last,
                    child: Container(
                      width: 240,
                      child: TextFormField(
                          maxLines: 1,
                          controller: _passwordFieldController,
                          obscureText: true,
                          onTap: (){
                            widget.onChange?.value = true;
                          },
                          onChanged: (String input){
                            bool valid = EmailPassController.verifyPassword(password: input)!;
                            EmailPassController.password = input;
                            if (valid){
                              widget.verifyStatus2?.value = true;
                            }
                            else{
                              widget.verifyStatus2?.value = false;
                            }
                          },
                          style: const TextStyle(
                            fontFamily: "Lexend",
                            fontWeight: FontWeight.w200,
                            fontSize: 16,
                            color: Color(0xC7FFFFFF),
                          ),
                          decoration: const InputDecoration(
                            hintText: "Enter your password...",
                            hintStyle: TextStyle(
                                color: Color(0x7AFFFFFF), letterSpacing: -1),
                            border: InputBorder.none,
                          )),
                    ),
                  ),
                  Positioned(
                    left: widget.pos5?.first,
                    top: widget.pos5?.last,
                    child: Container(
                      width: 240,
                      child: TextFormField(
                          maxLines: 1,
                          controller: _confirmPasswordController,
                          obscureText: true,
                          onTap: (){
                            widget.onChange?.value = true;
                          },
                          onChanged: (String? input){
                            String input2 = _passwordFieldController.text;
                            bool valid = EmailPassController.verifyConfirmPassword(password: input2, confirmPassword: input)!;
                            EmailPassController.confirmPassword = input;
                            if (valid){
                              widget.verifyStatus3?.value = true;
                            }
                            else{
                              widget.verifyStatus3?.value = false;
                            }
                          },
                          style: const TextStyle(
                            fontFamily: "Lexend",
                            fontWeight: FontWeight.w200,
                            fontSize: 16,
                            color: Color(0xC7FFFFFF),
                          ),
                          decoration: const InputDecoration(
                            hintText: "Confirm password...",
                            hintStyle: TextStyle(
                                color: Color(0x7AFFFFFF), letterSpacing: -1),
                            border: InputBorder.none,
                          )),
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ));
  }
}
