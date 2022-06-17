import 'dart:async';
import 'package:rive/rive.dart';
import 'package:flutter/material.dart';
import "package:flutter/services.dart";
import 'form.dart' as form;
import 'home.dart' as home;


class Get_Started extends StatefulWidget {
  const Get_Started({Key? key}) : super(key: key);
  static const String id = "Get Started";

  @override
  State<Get_Started> createState() => _Get_StartedState();
}

class _Get_StartedState extends State<Get_Started> {

  bool form_loaded = false;
  bool form_start = false;
  bool choosen_current = false; // Boolean to indicate to flutter that the user has made a choice on the current page.
  bool display_choice_Page3 = false; // Boolean to indicate when to display choice options at Page3.
  bool display_choice_Page4 = false; // Boolean to indicate when to display choice options at Page4.
  bool display_choice_Page5 = false; // Boolean to indicate when to display choice options at Page5.
  bool display_choice_Page6 = false; // Boolean to indicate when to display choice options at Page6.
  bool display_choice_Page7 = false; // Boolean to indicate when to display choice options at Page7.
  bool inLogin = false; // Boolean to indicate if the user is in the Login page.
  bool display_login_buttons = false; // Boolean to indicate when to display buttons at Login Page.
  bool checkLogin = false; // Boolean to indicate when to check for Login Page.
  bool display_start_buttons = true; // Boolean to indicate when to display start buttons at Start Page.
  bool push_next = false; // Boolean to indicate when to push next page on the view stack.
  form.InsulixForm? userForm = new form.InsulixForm();
  Artboard? _riveArtboard;
  RiveAnimationController? _rivecontroller;
  final mail_controller = TextEditingController();
  final password_controller = TextEditingController();


  // TRIGGERS ----------------------
  SMITrigger? go_toform;
  SMITrigger? select_female;
  SMITrigger? select_male;
  SMITrigger? go_next;
  SMITrigger? select_yes_Page3;
  SMITrigger? select_no_Page3;
  SMITrigger? select_yes_Page4;
  SMITrigger? select_no_Page4;
  SMITrigger? select_mgdl;
  SMITrigger? select_mmolL;
  SMITrigger? select_phone;
  SMITrigger? select_mail;
  SMITrigger? select_google;
  SMITrigger? start_mainapp;
  SMITrigger? register;
  SMITrigger? already_click;
  SMITrigger? back_login;
  SMITrigger? LogIn;
  //--------------------------------

  // BOOLEANS ----------------------
  SMIBool? has_choosen1;
  SMIBool? has_choosen2;
  SMIBool? has_choosen3;
  SMIBool? has_choosen4;
  SMIBool? has_choosen5;
  SMIBool? has_choosen6;
  SMIBool? metric_imp;
  SMIBool? form_done;
  SMIBool? registry_success;
  SMIBool? is1;
  SMIBool? is2;
  SMIBool? is3;
  SMIBool? is4;
  SMIBool? is5;
  SMIBool? correct_mail;
  SMIBool? correct_pass;
  //--------------------------------

  @override
  void _onRiveInit(Artboard artboard) {
    final controller =
    StateMachineController.fromArtboard(artboard, 'State Machine 1');
    if (controller != null){
      artboard.addController(controller);
      go_toform = controller.findInput<bool>('go_toform') as SMITrigger;
      select_female = controller.findInput<bool>('select_female') as SMITrigger;
      select_male = controller.findInput<bool>('select_male') as SMITrigger;
      select_yes_Page3 = controller.findInput<bool>('select_yes_Page3') as SMITrigger;
      select_no_Page3 = controller.findInput<bool>('select_no_Page3') as SMITrigger;
      select_yes_Page4 = controller.findInput<bool>('select_yes_Page4') as SMITrigger;
      select_no_Page4 = controller.findInput<bool>('select_no_Page4') as SMITrigger;
      select_mgdl = controller.findInput<bool>('select_mgdl') as SMITrigger;
      select_mmolL = controller.findInput<bool>('select_mmolL') as SMITrigger;
      select_mail = controller.findInput<bool>('select_mail') as SMITrigger;
      register = controller.findInput<bool>('register') as SMITrigger;
      already_click = controller.findInput<bool>('already_click') as SMITrigger;
      back_login = controller.findInput<bool>('back_login') as SMITrigger;
      LogIn = controller.findInput<bool>('LogIn') as SMITrigger;
      has_choosen1 = controller.findInput<bool>('has_choosen1') as SMIBool;
      has_choosen3 = controller.findInput<bool>('has_choosen3') as SMIBool;
      has_choosen4 = controller.findInput<bool>('has_choosen4') as SMIBool;
      has_choosen5 = controller.findInput<bool>('has_choosen5') as SMIBool;
      has_choosen6 = controller.findInput<bool>('has_choosen6') as SMIBool;
      registry_success = controller.findInput<bool>('registry_success') as SMIBool;
      is1 = controller.findInput<bool>('is1') as SMIBool;
      is2 = controller.findInput<bool>('is2') as SMIBool;
      is3 = controller.findInput<bool>('is3') as SMIBool;
      is4 = controller.findInput<bool>('is4') as SMIBool;
      is5 = controller.findInput<bool>('is5') as SMIBool;
      metric_imp = controller.findInput<bool>('metric_imp') as SMIBool;
      correct_mail = controller.findInput<bool>('correct_mail') as SMIBool;
      correct_pass = controller.findInput<bool>('correct_pass') as SMIBool;
      go_next = controller.findInput<bool>('go_next') as SMITrigger;
      setState(() {
        _riveArtboard = artboard;
      });
    }
  }


  @override
  void initState() {
    super.initState();
    rootBundle.load('./assets/Rive/get_started.riv').then((data) async{
      final file = RiveFile.import(data);
      final artboard = file.mainArtboard;
      setState(() => _riveArtboard = artboard);
    });
    Future.delayed(Duration(seconds: 11),(){
      form_loaded = true;
      print("Form loaded!");
      setState(() {

      });
    });
  }






  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    print("${form_start} | ${userForm?.currentPage}");
    if (userForm?.currentPage == 3 && !display_choice_Page3){
      Future.delayed(Duration(seconds: 2),(){
        display_choice_Page3 = true;
        print("Displaying choice at Page3");
        setState(() {

        });
      });
    }
    if (userForm?.currentPage == 4 && !display_choice_Page4){
      Future.delayed(Duration(seconds: 2),(){
        display_choice_Page4 = true;
        print("Displaying choice at Page4");
        setState(() {

        });
      });
    }
    if (userForm?.currentPage == 5 && !display_choice_Page5){
      Future.delayed(Duration(seconds: 2),(){
        display_choice_Page5 = true;
        print("Displaying choice at Page5");
        setState(() {

        });
      });
    }
    if (userForm?.currentPage == 6 && !display_choice_Page6){
      Future.delayed(Duration(seconds: 2),(){
        display_choice_Page6 = true;
        print("Displaying choice at Page6");
        setState(() {

        });
      });
    }
    if (userForm?.currentPage == 7 && !display_choice_Page7){
      Future.delayed(Duration(seconds: 4),(){
        display_choice_Page7 = true;
        print("Displaying choice at Page7");
        setState(() {

        });
      });
    }
    if (form_start == false && inLogin && checkLogin){
          Future.delayed(Duration(seconds: 3), () {
            display_login_buttons = true;
            checkLogin = false;
            print("User entered Login Page");
            setState(() {

            });
          });
    }
    if (push_next){
      push_next = false;
      Future.delayed(Duration(seconds: 3),(){
        Navigator.pushReplacementNamed(context, home.HomeScreen.id);
        print("Pushed on the stack!");
      });
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          children: [Stack(children: [
            Container(
              width: width,
              height: height,
              color: Color(0xFF3E5468),
            ),
            Positioned(
              child: RiveAnimation.asset(
                "./assets/Rive/get_started.riv",
                fit: BoxFit.cover,
                onInit: _onRiveInit,
                stateMachines: ["State Machine 1"],
              ),
              width: width,
              height: height,
            ),
            Positioned(
              bottom: 5,
              left: 245,
              child: GestureDetector(
                onTap: (){
                  // Increment page index and print current page. Also fire the go_next trigger and set state.
                  if (choosen_current) {
                    if(userForm?.currentPage == 1){
                      userForm?.currentPage++;
                      userForm?.currentPage++;
                    }
                    else {
                      userForm?.currentPage++;
                    }
                    choosen_current = false;
                  }
                  go_next?.fire();
                  setState(() {
                  });
                  },
                child: Container(
                  width: 140,
                  height: 42,
                  color: Color(0xFFFFFF),
                ),
              ),
            ),
            if (userForm?.currentPage == 1 && form_start)
              /// There are two conditions to display buttons of page1 of the form.
              /// The current page of the [userForm] object needs to equal 1 and
              /// [form_start] needs to be true.
              Positioned(
                top: 168,
                left: 128,
                child: GestureDetector(
                  onTap: (){
                    print("User selected Female");
                    select_female?.fire();
                    has_choosen1?.value = true;
                    print("FEMALE BUTTON MADE has_choosen1: ${has_choosen1?.value}");
                    choosen_current = true;
                    userForm?.gender = form.Gender.female;
                    setState(() {

                    });
                  },
                  child: ClipOval(
                    child: Container(
                      width: 175,
                      height: 175,
                      color: Color(0xFFFFFF),
                    ),
                  ),
                ),
              ),
            if (userForm?.currentPage == 1 && form_start)
              Positioned(
                top: 495,
                left: 125,
                child: GestureDetector(
                  onTap: (){
                    print("User selected Male");
                    select_male?.fire();
                    has_choosen1?.value = true;
                    choosen_current = true;
                    userForm?.gender = form.Gender.male;
                    setState(() {

                    });
                  },
                  child: ClipOval(
                    child: Container(
                      width: 175,
                      height: 175,
                      color: Color(0xFFFFB2),
                    ),
                  ),
                ),
              ),
            if (!form_start & form_loaded && !inLogin)
              /// 3 CONDITIONS:
              /// (1) [form_start] FALSE | (2) [form_loaded] TRUE | (3) [inLogin] FALSE.
              /// Goes to first page of form.
              Positioned(
                top: 615,
                left: 62,
                child: GestureDetector(
                  onTap: (){
                    // Fires the [go_toform] trigger and triggers a countdown of
                    // 3secs for incrementing the [currentPage] field.
                    print("taped!");
                    go_toform?.fire();
                    setState(() {
                      form_start = true;
                      Future.delayed(Duration(seconds: 3),(){
                          setState(() {
                            userForm?.currentPage++;
                          });
                      });
                    });
                  },
                  child: Container(
                    height: 77,
                    width: 265,
                    color: Color(0xFFFFB2),
                  ),
                ),
              ),
          if (!form_start && form_loaded && display_start_buttons)
            Positioned(
              top: 725,
              left: 62,
              child: GestureDetector(
                onTap: (){
                  print("taped!");
                  already_click?.fire();
                  inLogin = true;
                  display_start_buttons = false;
                  checkLogin = true;
                  setState(() {
                  });
                },
                child: Container(
                  height: 77,
                  width: 265,
                  color: Color(0xFFFFB2),
                ),
              ),
            ),
            if (!form_start && form_loaded && display_login_buttons)
              Positioned(
                top: 395,
                left: 20,
                child: GestureDetector(
                  onTap: (){
                    print("taped back button!");
                    Future.delayed(Duration(seconds: 2),(){
                      display_start_buttons = true;
                      inLogin = false;
                      setState(() {

                      });
                    });
                    back_login?.fire();
                    display_login_buttons = false;
                    setState(() {
                    });
                  },
                  child: ClipOval(
                    child: Container(
                      height: 65,
                      width: 65,
                      color: Color(0xFFFFB2),
                    ),
                  ),
                ),
              ),
            if (!form_start && form_loaded && display_login_buttons)
              Positioned(
                left: 80,
                top: 485,
                child: Container(
                  width: 190,
                  child: Card(
                    semanticContainer: false,
                    color: Color(0xFFF),
                    elevation: 0,
                    child: TextFormField(
                      controller: mail_controller,
                      autofocus: true,
                      maxLines: 1,
                      style: TextStyle(
                        color: Color(0xE0FFFFFF),
                        fontSize: 18,
                        fontFamily: 'Lexend'
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),
            if (!form_start && form_loaded && display_login_buttons)
              Positioned(
                left: 80,
                top: 620,
                child: Container(
                  width: 190,
                  child: Card(
                    semanticContainer: false,
                    color: Color(0xFFF),
                    elevation: 0,
                    child: TextFormField(
                      controller: password_controller,
                      obscureText: true,
                      autofocus: true,
                      maxLines: 1,
                      style: TextStyle(
                          color: Color(0xE0FFFFFF),
                          fontSize: 18,
                          fontFamily: 'Lexend'
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),
            if (!form_start && form_loaded && display_login_buttons)
              Positioned(
                top: 700,
                left: 150,
                child: GestureDetector(
                  onTap: (){
                    print("taped log in button!");
                    String? mailInput = mail_controller.text;
                    String? passwordInput = password_controller.text;
                    if (mailInput == "a" && passwordInput == "a"){
                      correct_mail?.value = true;
                      correct_pass?.value = true;
                      LogIn?.fire();
                      display_login_buttons = false;
                      push_next = true;
                    }
                    else{
                      correct_mail?.value = false;
                      correct_pass?.value = false;
                      LogIn?.fire();
                    }
                    setState(() {
                    });
                  },
                  child: Container(
                    height: 65,
                    width: 130,
                    color: Color(0xFFF),
                  ),
                ),
              ),
          // TODO: Page2 which corresponds to the birthdate is extremely complicated. Do later!
          if (userForm?.currentPage == 3 && form_start && display_choice_Page3)
            Positioned(
              top: 192,
              left: 125,
              child: GestureDetector(
                onTap: (){
                  print("User selected Yes at page3");
                  select_yes_Page3?.fire();
                  has_choosen3?.value = true;
                  choosen_current = true;
                  userForm?.pills = true;
                  setState(() {

                  });
                },
                child: ClipOval(
                  child: Container(
                    width: 175,
                    height: 175,
                    color: Color(0xCBC2C2),
                  ),
                ),
              ),
            ),
          if (userForm?.currentPage == 3 && form_start && display_choice_Page3)
            Positioned(
              top: 517,
              left: 122,
              child: GestureDetector(
                onTap: (){
                  print("User selected No at page3");
                  select_no_Page3?.fire();
                  has_choosen3?.value = true;
                  choosen_current = true;
                  userForm?.pills = false;
                  setState(() {

                  });
                },
                child: ClipOval(
                  child: Container(
                    width: 175,
                    height: 175,
                    color: Color(0xFFFFB2),
                  ),
                ),
              ),
            ),
            if (userForm?.currentPage == 4 && form_start && display_choice_Page4)
              Positioned(
                top: 252,
                left: 127,
                child: GestureDetector(
                  onTap: (){
                    print("User selected Yes at page4");
                    select_yes_Page4?.fire();
                    has_choosen4?.value = true;
                    choosen_current = true;
                    userForm?.insulin = true;
                    setState(() {

                    });
                  },
                  child: ClipOval(
                    child: Container(
                      width: 175,
                      height: 175,
                      color: Color(0xCBC2C2),
                    ),
                  ),
                ),
              ),
            if (userForm?.currentPage == 4 && form_start && display_choice_Page4)
              Positioned(
                top: 548,
                left: 129,
                child: GestureDetector(
                  onTap: (){
                    print("User selected No at page4");
                    select_no_Page4?.fire();
                    has_choosen4?.value = true;
                    choosen_current = true;
                    userForm?.insulin = false;
                    setState(() {

                    });
                  },
                  child: ClipOval(
                    child: Container(
                      width: 175,
                      height: 175,
                      color: Color(0xFFFFB2),
                    ),
                  ),
                ),
              ),
          //
          // TODO: Complete the other form pages. CURRENT PROGRESS: Page1 DONE | Page2 LATER | Page3 DONE | Page4 DONE | Page5 DONE | Page6 INPROG .
            if (userForm?.currentPage == 5 && form_start && display_choice_Page5)
              Positioned(
                left: 275,
                top: 230,
                child: GestureDetector(
                  onTap: (){
                    if (is1?.value == false) {
                      is1?.value = true;
                      is2?.value = false;
                      is3?.value = false;
                      is4?.value = false;
                      is5?.value = false;
                      userForm?.type = 1;
                      has_choosen5?.value = true;
                      choosen_current = true;
                    }
                    else if (is1?.value == true){
                      is1?.value = false;
                      choosen_current = true;
                    }
                  },
                  child: ClipOval(
                      child: Container(
                        width: 70,
                        height: 70,
                        color: Color(0xFFFFFF),
                      ),
                    ),
                ),
                ),
            if (userForm?.currentPage == 5 && form_start && display_choice_Page5)
                Positioned(
                  left: 275,
                  top: 332,
                  child: GestureDetector(
                    onTap: (){
                      if (is2?.value == false) {
                        is1?.value = false;
                        is2?.value = true;
                        is3?.value = false;
                        is4?.value = false;
                        is5?.value = false;
                        userForm?.type = 2;
                        has_choosen5?.value = true;
                        choosen_current = true;
                      }
                      else if (is2?.value == true){
                        is2?.value = false;
                        choosen_current = true;
                      }
                    },
                    child: ClipOval(
                      child: Container(
                        width: 70,
                        height: 70,
                        color: Color(0xFFFFFF),
                      ),
                    ),
                  ),
                ),
            if (userForm?.currentPage == 5 && form_start && display_choice_Page5)
              Positioned(
                left: 275,
                top: 445,
                child: GestureDetector(
                  onTap: (){
                    if (is3?.value == false) {
                      is1?.value = false;
                      is2?.value = false;
                      is3?.value = true;
                      is4?.value = false;
                      is5?.value = false;
                      userForm?.type = 3;
                      has_choosen5?.value = true;
                      choosen_current = true;
                    }
                    else if (is3?.value == true){
                      is3?.value = false;
                      choosen_current = true;
                    }
                  },
                  child: ClipOval(
                    child: Container(
                      width: 70,
                      height: 70,
                      color: Color(0xFFFFFF),
                    ),
                  ),
                ),
              ),
            if (userForm?.currentPage == 5 && form_start && display_choice_Page5)
              Positioned(
                left: 275,
                top: 557,
                child: GestureDetector(
                  onTap: (){
                    if (is4?.value == false) {
                      is1?.value = false;
                      is2?.value = false;
                      is3?.value = false;
                      is4?.value = true;
                      is5?.value = false;
                      userForm?.type = 4;
                      has_choosen5?.value = true;
                      choosen_current = true;
                    }
                    else if (is4?.value == true){
                      is4?.value = false;
                      choosen_current = true;
                    }
                  },
                  child: ClipOval(
                    child: Container(
                      width: 70,
                      height: 70,
                      color: Color(0xFFFFFF),
                    ),
                  ),
                ),
              ),
            if (userForm?.currentPage == 5 && form_start && display_choice_Page5)
              Positioned(
                left: 275,
                top: 655,
                child: GestureDetector(
                  onTap: (){
                    if (is5?.value == false) {
                      is1?.value = false;
                      is2?.value = false;
                      is3?.value = false;
                      is4?.value = false;
                      is5?.value = true;
                      userForm?.type = 5;
                      has_choosen5?.value = true;
                      choosen_current = true;
                    }
                    else if (is5?.value == true){
                      is5?.value = false;
                      choosen_current = true;
                    }
                  },
                  child: ClipOval(
                    child: Container(
                      width: 70,
                      height: 70,
                      color: Color(0xFFFFFF),
                    ),
                  ),
                ),
              ),
            if (userForm?.currentPage == 6 && form_start && display_choice_Page6)
              Positioned(
                top: 538,
                left: 55,
                child: GestureDetector(
                  onTap: (){
                    print("User selected METRIC");
                    metric_imp?.value = true;
                    userForm?.unitSys = form.UnitSys.metric;
                    setState(() {

                    });
                  },
                  child: ClipOval(
                    child: Container(
                      width: 150,
                      height: 150,
                      color: Color(0xFFFFB2),
                    ),
                  ),
                ),
              ),
            if (userForm?.currentPage == 6 && form_start && display_choice_Page6)
              Positioned(
                top: 538,
                left: 230,
                child: GestureDetector(
                  onTap: (){
                    print("User selected IMPERIAL");
                    metric_imp?.value = false;
                    userForm?.unitSys = form.UnitSys.imperial;
                    setState(() {

                    });
                  },
                  child: ClipOval(
                    child: Container(
                      width: 150,
                      height: 150,
                      color: Color(0xFFFFB2),
                    ),
                  ),
                ),
              ),
            if (userForm?.currentPage == 6 && form_start && display_choice_Page6)
              Positioned(
                top: 248,
                left: 232,
                child: GestureDetector(
                  onTap: (){
                    print("User selected mg/dl");
                    select_mgdl?.fire();
                    has_choosen6?.value = true;
                    choosen_current = true;
                    userForm?.insulinUnit = form.InsulinUnit.mgdl;
                    setState(() {

                    });
                  },
                  child: ClipOval(
                    child: Container(
                      width: 150,
                      height: 150,
                      color: Color(0xFFFFFF),
                    ),
                  ),
                ),
              ),
            if (userForm?.currentPage == 6 && form_start && display_choice_Page6)
              Positioned(
                top: 248,
                left: 55,
                child: GestureDetector(
                  onTap: (){
                    print("User selected mmol/L");
                    select_mmolL?.fire();
                    has_choosen6?.value = true;
                    choosen_current = true;
                    userForm?.insulinUnit = form.InsulinUnit.mmolL;
                    setState(() {

                    });
                  },
                  child: ClipOval(
                    child: Container(
                      width: 150,
                      height: 150,
                      color: Color(0xFFFFFF),
                    ),
                  ),
                ),
              ),
            if (userForm?.currentPage == 7 && form_start && display_choice_Page7)
              Positioned(
                top: 412,
                left: 25,
                child: GestureDetector(
                  onTap: (){
                    print("User selected PHONE auth method");
                    select_phone?.fire();
                    setState(() {

                    });
                  },
                  child: Container(
                      width: 342,
                      height: 50,
                      color: Color(0xFFFFFF),
                    ),
                  ),
                ),
            if (userForm?.currentPage == 7 && form_start && display_choice_Page7)
              Positioned(
                top: 547,
                left: 25,
                child: GestureDetector(
                  onTap: (){
                    print("User selected EMAIL auth method");
                    select_mail?.fire();
                    inLogin = true;
                    setState(() {

                    });
                  },
                  child: Container(
                    width: 342,
                    height: 50,
                    color: Color(0xFFFFFF),
                  ),
                ),
              ),
            if (userForm?.currentPage == 7 && form_start && display_choice_Page7)
              Positioned(
                top: 685,
                left: 25,
                child: GestureDetector(
                  onTap: (){
                    print("User selected GOOGLE auth method");
                    select_google?.fire();
                    setState(() {

                    });
                  },
                  child: Container(
                    width: 342,
                    height: 50,
                    color: Color(0xFFFFFF),
                  ),
                ),
              ),
            if (userForm?.currentPage == 7 && form_start && display_choice_Page7 && inLogin)
              Positioned(
                top: 675,
                left: 147,
                child: GestureDetector(
                  onTap: (){
                    register?.fire();
                    print("User attempted to register via mail");
                    setState(() {

                    });
                  },
                  child: ClipOval(
                    child: Container(
                      width: 100,
                      height: 100,
                      color: Color(0x5E1616),
                    ),
                  ),
                ),
              ),
          ]),
      ])),
    );
  }
}
