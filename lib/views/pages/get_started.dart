import 'dart:async';
import 'package:insulix/controllers/SignUp%20controllers/signup_emailpass_controller.dart';
import 'package:insulix/views/widgets/emailpass_form.dart';
import 'package:insulix/models/insulixUser.dart';
import 'package:insulix/services/auth_service.dart';
import 'package:rive/rive.dart';
import 'package:flutter/material.dart';
import "package:flutter/services.dart";
import 'package:insulix/models/form.dart' as form;
import 'home.dart' as home;

class Get_Started extends StatefulWidget {
  const Get_Started({Key? key}) : super(key: key);
  static const String id = "Get Started";

  @override
  State<Get_Started> createState() => _Get_StartedState();
}

class _Get_StartedState extends State<Get_Started> {
  bool form_loaded =
      false; // Boolean to indicate when to activate "Get Started >" hitbox. Temporary and will be removed later.
  bool form_start =
      false; // Boolean to indicate when to activate "Next" and "Previous" buttons.
  bool inLogin = false; // Boolean to indicate if the user is in the Login page.
  bool display_login_buttons =
      false; // Boolean to indicate when to display buttons at Login Page.
  bool checkLogin = false; // Boolean to indicate when to check for Login Page.
  bool display_start_buttons =
      true; // Boolean to indicate when to display start buttons at Start Page.
  bool push_next =
      false; // Boolean to indicate when to push next page on the view stack.
  form.InsulixForm? userForm = form.InsulixForm();
  Artboard? _riveArtboard;
  RiveAnimationController? _rivecontroller;
  final _mail_controller = TextEditingController();
  final _password_controller = TextEditingController();
  final AuthService _auth = AuthService();

  // TRIGGERS ----------------------
  SMITrigger? go_toform;
  SMITrigger? go_next;
  SMITrigger? previous;
  SMITrigger? select_phone;
  SMITrigger? select_mail;
  SMITrigger? select_google;
  SMITrigger? start_mainapp;
  SMITrigger? register;
  SMITrigger? already_click;
  SMITrigger? back_login;
  SMITrigger? LogIn;
  SMITrigger? registry_finished;
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
  SMIBool? check_login;
  SMIBool? at_page1;
  SMIBool? at_page3;
  SMIBool? at_page4;
  SMIBool? at_page5;
  SMIBool? at_page6;
  SMIBool? at_page7;
  SMIBool? male;
  SMIBool? pills;
  SMIBool? insulin;
  SMIBool? mgdl;
  SMIBool? in_EmailPassForm;
  SMIBool? check_EmailPassForm;
  SMIBool? correct_emailForm;
  SMIBool? correct_passForm;
  SMIBool? correct_confirmForm;
  SMIBool? send_EmailPassRegistry;
  SMIBool? go_home;
  //--------------------------------

  // METHODS -----------------------

  void registryPageChecker() {
    Timer.periodic(const Duration(seconds: 1), (Timer t) async {
      if (send_EmailPassRegistry?.value ?? false){
        send_EmailPassRegistry?.value = false;
        print("abc ${EmailPassController.checkOut()}");

        if(EmailPassController.verifyCredentials()){
          InsulixUser? response = await EmailPassController.register(_auth);
          EmailPassController.sendEmailPassRegistry(response, registry_finished);
        }

      }
      if (go_home?.value ?? false){
        push_next = true;
      }
      setState(() {
      });
      if (!mounted){
        t.cancel();
      }
    });
  }

  void updatePage({bool backwards = false}) {
    /// This method sync's userForm.currentPage index with the "at_page[index]"
    /// Rive boolean. It has two sync modes, backwards = false (DEFAULT) which
    /// assumes you're advancing in the form and backwards = true which assumes
    /// you're going back to previous pages in the form.
    backwards ? previous?.fire() : go_next?.fire();

    /// The following hardcoded delay seems to be necessary for the state
    /// machine to execute it's logic, otherwise the code runs faster than
    /// Rive's state machine. Variables change by the time Rive's state
    /// machine does "any state" transition condition check, which results into
    /// undesired behaviour.
    Future.delayed(const Duration(milliseconds: 500), () {
      print(" /!\\ UPDATING PAGE /!\\");
      switch (userForm!.currentPage) {
        case 1:
          {
            at_page1?.value = true;
            at_page3?.value = false;
            at_page4?.value = false;
            at_page5?.value = false;
            at_page6?.value = false;
            at_page7?.value = false;
          }
          break;

        case 2:
          {
            at_page1?.value = false;
            at_page3?.value = false;
            at_page4?.value = false;
            at_page5?.value = false;
            at_page6?.value = false;
            at_page7?.value = false;
          }
          break;

        case 3:
          {
            at_page1?.value = false;
            at_page3?.value = true;
            at_page4?.value = false;
            at_page5?.value = false;
            at_page6?.value = false;
            at_page7?.value = false;
          }
          break;

        case 4:
          {
            at_page1?.value = false;
            at_page3?.value = false;
            at_page4?.value = true;
            at_page5?.value = false;
            at_page6?.value = false;
            at_page7?.value = false;
          }
          break;

        case 5:
          {
            at_page1?.value = false;
            at_page3?.value = false;
            at_page4?.value = false;
            at_page5?.value = true;
            at_page6?.value = false;
            at_page7?.value = false;
          }
          break;

        case 6:
          {
            at_page1?.value = false;
            at_page3?.value = false;
            at_page4?.value = false;
            at_page5?.value = false;
            at_page6?.value = true;
            at_page7?.value = false;
          }
          break;

        case 7:
          {
            at_page1?.value = false;
            at_page3?.value = false;
            at_page4?.value = false;
            at_page5?.value = false;
            at_page6?.value = false;
            at_page7?.value = true;
            registryPageChecker();
          }
          break;
      }
      print(
          "[at_page1 = ${at_page1!.value}, at_page3 = ${at_page3!.value}, at_page4 = "
          "${at_page4!.value}, at_page5 = ${at_page5!.value}, at_page6 = ${at_page6!.value}]\n"
          " ■ Currently at page : ${userForm!.currentPage}");
      return;
    });
  }

  void verifyLogin(InsulixUser? _insulixUser) {
    /// Toggles a Rive boolean to start the [⌛] indicators and start the check
    /// for login credentials.
    check_login?.value = true;
    if (_insulixUser == null) {
      refuseLogin();
    } else {
      acceptLogin();
    }
  }

  void acceptLogin() {
    print("Login successful ! Proceeding...");
    // Activating the login [✔] indicators.
    correct_mail?.value = true;
    correct_pass?.value = true;
    push_next = true;
    display_login_buttons = false;
    setState(() {});
  }

  void refuseLogin() {
    print("Login error ! Connection refused.");
    // Activating the login [X] indicators.
    correct_mail?.value = false;
    correct_pass?.value = false;
    setState(() {});
  }

  // -------------------------------

  @override
  void _onRiveInit(Artboard artboard) {
    final controller =
        StateMachineController.fromArtboard(artboard, 'State Machine 1');
    if (controller != null) {
      /// Simple null check into mapping flutter inputs to Rive state machine
      /// inputs.
      artboard.addController(controller);
      go_toform = controller.findInput<bool>('go_toform') as SMITrigger;
      select_mail = controller.findInput<bool>('select_mail') as SMITrigger;
      register = controller.findInput<bool>('register') as SMITrigger;
      already_click = controller.findInput<bool>('already_click') as SMITrigger;
      back_login = controller.findInput<bool>('back_login') as SMITrigger;
      LogIn = controller.findInput<bool>('LogIn') as SMITrigger;
      go_next = controller.findInput<bool>('go_next') as SMITrigger;
      previous = controller.findInput<bool>('previous') as SMITrigger;
      registry_finished = controller.findInput<bool>('registry_finished') as SMITrigger;
      has_choosen1 = controller.findInput<bool>('has_choosen1') as SMIBool;
      has_choosen3 = controller.findInput<bool>('has_choosen3') as SMIBool;
      has_choosen4 = controller.findInput<bool>('has_choosen4') as SMIBool;
      has_choosen5 = controller.findInput<bool>('has_choosen5') as SMIBool;
      has_choosen6 = controller.findInput<bool>('has_choosen6') as SMIBool;
      registry_success =
          controller.findInput<bool>('registry_success') as SMIBool;
      is1 = controller.findInput<bool>('is1') as SMIBool;
      is2 = controller.findInput<bool>('is2') as SMIBool;
      is3 = controller.findInput<bool>('is3') as SMIBool;
      is4 = controller.findInput<bool>('is4') as SMIBool;
      is5 = controller.findInput<bool>('is5') as SMIBool;
      metric_imp = controller.findInput<bool>('metric_imp') as SMIBool;
      correct_mail = controller.findInput<bool>('correct_mail') as SMIBool;
      correct_pass = controller.findInput<bool>('correct_pass') as SMIBool;
      check_login = controller.findInput<bool>('check_login') as SMIBool;
      at_page1 = controller.findInput<bool>('at_page1') as SMIBool;
      at_page3 = controller.findInput<bool>('at_page3') as SMIBool;
      at_page4 = controller.findInput<bool>('at_page4') as SMIBool;
      at_page5 = controller.findInput<bool>('at_page5') as SMIBool;
      at_page6 = controller.findInput<bool>('at_page6') as SMIBool;
      at_page7 = controller.findInput<bool>('at_page7') as SMIBool;
      male = controller.findInput<bool>('male') as SMIBool;
      pills = controller.findInput<bool>('pills') as SMIBool;
      insulin = controller.findInput<bool>('insulin') as SMIBool;
      mgdl = controller.findInput<bool>('mg/dl') as SMIBool;
      in_EmailPassForm =
          controller.findInput<bool>('in_EmailPassForm') as SMIBool;
      check_EmailPassForm = controller.findInput<bool>('check_EmailPassForm') as SMIBool;
      correct_emailForm = controller.findInput<bool>('correct_emailForm') as SMIBool;
      correct_passForm = controller.findInput<bool>('correct_passForm') as SMIBool;
      correct_confirmForm = controller.findInput<bool>('correct_confirmForm') as SMIBool;
      send_EmailPassRegistry = controller.findInput<bool>('send_EmailPassRegistry') as SMIBool;
      go_home = controller.findInput<bool>('go_home') as SMIBool;
      print("All inputs have been mapped!");
      setState(() {
        _riveArtboard = artboard;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    rootBundle.load('./assets/Rive/get_started.riv').then((data) async {
      final file = RiveFile.import(data);
      final artboard = file.mainArtboard;
      setState(() => _riveArtboard = artboard);
    });
    Future.delayed(const Duration(seconds: 11), () {
      form_loaded = true;
      print("Form loaded!");
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    print(
        "FORM START ? ${form_start} | CURRENT PAGE ? ${userForm?.currentPage}");
    if (form_start == false && inLogin && checkLogin) {
      Future.delayed(const Duration(seconds: 3), () {
        display_login_buttons = true;
        checkLogin = false;
        print("User entered Login Page");
        setState(() {});
      });
    }
    if (push_next) {
      push_next = false;
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushReplacementNamed(context, home.HomeScreen.id);
        print("Pushed on the stack!");
      });
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
          child: Column(children: [
        Stack(children: [
          Container(
            width: width,
            height: height,
            color: const Color(0xFF3E5468),
          ),
          Positioned(
            child: RiveAnimation.asset(
              "./assets/Rive/get_started.riv",
              fit: BoxFit.cover,
              onInit: _onRiveInit,
              stateMachines: const ["State Machine 1"],
            ),
            width: width,
            height: height,
          ),
          if (form_start)
            Positioned(
              bottom: 0,
              left: width * 0.63,
              child: GestureDetector(
                onTap: () {
                  // Page logic for pressing Next button.
                  if (has_choosen1!.value &&
                      userForm!.currentPage == 1 &&
                      at_page1!.value == true) {
                    userForm!.currentPage++;
                    userForm!.currentPage++;
                    print(
                        "¤¤¤¤¤¤¤¤¤¤\n ADVANCING TO PAGE 3 FROM PAGE 1 \n¤¤¤¤¤¤¤¤¤¤");
                    updatePage();
                  }
                  if (has_choosen3!.value &&
                      userForm!.currentPage == 3 &&
                      at_page3!.value == true) {
                    userForm!.currentPage++;
                    print(
                        "¤¤¤¤¤¤¤¤¤¤\n ADVANCING TO PAGE 4 FROM PAGE 3 \n¤¤¤¤¤¤¤¤¤¤");
                    updatePage();
                  }
                  if (has_choosen4!.value &&
                      userForm!.currentPage == 4 &&
                      at_page4!.value == true) {
                    userForm!.currentPage++;
                    updatePage();
                    print(
                        "¤¤¤¤¤¤¤¤¤¤\n ADVANCING TO PAGE 5 FROM PAGE 4 \n¤¤¤¤¤¤¤¤¤¤");
                  }
                  if (has_choosen5!.value &&
                      userForm!.currentPage == 5 &&
                      at_page5!.value == true) {
                    userForm!.currentPage++;
                    updatePage();
                    print(
                        "¤¤¤¤¤¤¤¤¤¤\n ADVANCING TO PAGE 6 FROM PAGE 5 \n¤¤¤¤¤¤¤¤¤¤");
                  }
                  if (has_choosen6!.value &&
                      userForm!.currentPage == 6 &&
                      at_page6!.value == true) {
                    userForm!.currentPage++;
                    updatePage();
                    print(
                        "¤¤¤¤¤¤¤¤¤¤\n ADVANCING TO PAGE 7 FROM PAGE 6 \n¤¤¤¤¤¤¤¤¤¤");
                  }
                },
                child: Container(
                  width: 140,
                  height: 60,
                  color: const Color(0xFFFFFF),
                ),
              ),
            ),
          if (form_start)
            Positioned(
              bottom: 0,
              left: width * 0.06,
              child: GestureDetector(
                onTap: () {
                  print(width);
                  print(height);
                  // Page logic for pressing Previous button.
                  if (userForm!.currentPage == 3) {
                    userForm!.currentPage--;
                    userForm!.currentPage--;
                  } else {
                    userForm!.currentPage--;
                  }
                  print(
                      "¤¤¤¤¤¤¤¤¤¤\n REVERSING TO PAGE ${userForm!.currentPage}"
                      " FROM PAGE ${userForm!.currentPage + 1} \n¤¤¤¤¤¤¤¤¤¤");
                  updatePage(backwards: true);
                },
                child: Container(
                  width: 140,
                  height: 60,
                  color: const Color(0xACFF),
                ),
              ),
            ),
          if (!form_start & form_loaded && !inLogin)

            /// 3 CONDITIONS:
            /// (1) [form_start] FALSE | (2) [form_loaded] TRUE | (3) [inLogin] FALSE.
            /// Goes to first page of form.
            Positioned(
              top: height * 0.75,
              left: width * 0.16,
              child: GestureDetector(
                onTap: () {
                  // Fires the [go_toform] trigger and triggers a countdown of
                  // 3secs for incrementing the [currentPage] field.
                  print("taped!");
                  go_toform?.fire();
                  setState(() {
                    Future.delayed(const Duration(seconds: 3), () {
                      setState(() {
                        form_start = true;
                        userForm?.currentPage++;
                        updatePage();
                      });
                    });
                  });
                },
                child: Container(
                  height: 77,
                  width: 275,
                  color: const Color(0xFFFFB2),
                ),
              ),
            ),
          if (!form_start && form_loaded && display_start_buttons)
            Positioned(
              top: height * 0.88,
              left: width * 0.15,
              child: GestureDetector(
                onTap: () {
                  print("taped!");
                  already_click?.fire();
                  inLogin = true;
                  display_start_buttons = false;
                  checkLogin = true;
                  setState(() {});
                },
                child: Container(
                  height: 75,
                  width: 285,
                  color: const Color(0xFFFFB2),
                ),
              ),
            ),
          if (!form_start && form_loaded && display_login_buttons)
            Positioned(
              top: 395,
              left: 20,
              child: GestureDetector(
                onTap: () {
                  print("taped back button!");
                  Future.delayed(const Duration(seconds: 2), () {
                    display_start_buttons = true;
                    inLogin = false;
                    setState(() {});
                  });
                  back_login?.fire();
                  display_login_buttons = false;
                  setState(() {});
                },
                child: ClipOval(
                  child: Container(
                    height: 65,
                    width: 65,
                    color: const Color(0xFFFFB2),
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
                  color: const Color(0xFFF),
                  elevation: 0,
                  child: TextFormField(
                    controller: _mail_controller,
                    autofocus: true,
                    maxLines: 1,
                    style: const TextStyle(
                        color: Color(0xE0FFFFFF),
                        fontSize: 18,
                        fontFamily: 'Lexend'),
                    decoration: const InputDecoration(
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
                  color: const Color(0xFFF),
                  elevation: 0,
                  child: TextFormField(
                    controller: _password_controller,
                    obscureText: true,
                    autofocus: true,
                    maxLines: 1,
                    style: const TextStyle(
                        color: const Color(0xE0FFFFFF),
                        fontSize: 18,
                        fontFamily: 'Lexend'),
                    decoration: const InputDecoration(
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
                onTap: () async {
                  print("taped log in button!");
                  String? mailInput = _mail_controller.text.trim();
                  String? passwordInput = _password_controller.text.trim();
                  LogIn?.fire();
                  check_login?.value = false;
                  // TODO: IMPLEMENT FIREBASE LOGIN
                  print(mailInput);
                  print(passwordInput);
                  InsulixUser? insulixUser = await _auth
                      .signInWithEmailAndPassword(mailInput, passwordInput);
                  verifyLogin(insulixUser);
                },
                child: Container(
                  height: 65,
                  width: 130,
                  color: const Color(0xFFF),
                ),
              ),
            ),
          if (in_EmailPassForm?.value ?? false)
            EmailPassForm(
              pos1: [40, 5],
              pos2: [40, 102],
              pos3: [40, 197],
              pos4: [40, 292],
              pos5: [40, 387],
              onChange: check_EmailPassForm,
              verifyStatus1: correct_emailForm,
              verifyStatus2: correct_passForm,
              verifyStatus3: correct_confirmForm,
            ),
        ]),
      ])),
    );
  }
}
