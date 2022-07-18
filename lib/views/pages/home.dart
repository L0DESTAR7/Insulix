
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insulix/models/glucose_log.dart';
import 'package:insulix/models/insulin_log.dart';
import 'package:insulix/models/reminder_log.dart';
import 'package:rive/rive.dart';
import 'package:insulix/models/Boxes.dart';
import 'package:insulix/models/alarmCall.dart';
import 'package:insulix/services/auth_service.dart';
import 'get_started.dart' as get_started;






class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const String id = "Home Screen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // GLUCOSE LOG CONTROLLERS ------
  final glucose_controller = TextEditingController();
  // ------------------------------

  // INSULIN LOG CONTROLLERS ------
  final fastacting_insulin_controller = TextEditingController();
  final basal_insulin_controller = TextEditingController();
  // ------------------------------

  // PILL ALARM CONTROLLERS -------
  final reminder_comment_controller =  TextEditingController();
  // ------------------------------

  DateTime dateTimeGlucose = DateTime.now();
  DateTime dateTimeInsulin = DateTime.now();
  DateTime dateTimeReminder = DateTime.now();
  bool haschoosen_TimeGlucose = false;
  bool haschoosen_TimeInsulin = false;
  bool haschoosen_TimeReminder = false;
  final mySystemTheme = SystemUiOverlayStyle.dark.copyWith(systemNavigationBarColor: const Color(
      0x1A000000));

  GlucoseLog currentGlucoseLog = GlucoseLog(0,0,DateTime.now());
  InsulinLog currentInsulinLog = InsulinLog(0,0,0,DateTime.now());
  InsulinLog maxInsulinlog = InsulinLog(123,123,3,DateTime.now());
  ReminderLog currentReminderLog = ReminderLog([],DateTime.now(),false,"");
  double  maxFast = 123;
  double maxBasal = 123;
  final glucoseBox = Boxes.getGlucoseLogs(); // Creates an instance of GlucoseLogs BOX.
  final insulinBox = Boxes.getInsulinLogs(); // Creates an instance of InsulinLogs BOX.
  bool noLatest = false;
  double fastStep = 0; // The value by which Fast acting insulin is decremented depending on the refresh rate.
  double basalStep = 0;// The value by which Basal insulin is decremented depending on the refresh rate.
  double fastActingInsulin = 0;
  double basalInsulin = 0;


  // STATE BOOLEANS ---------------
  bool inDrawer = false; // Boolean to indicate if the app's Drawer is open or not.
  bool inGlucoseLog = false; // Boolean to indicate if the app's Glucose add log is open or not.
  bool inHome = true; // Boolean to indicate if the app's is in the Home state or not.
  bool inMainButton = false; // Boolean to indicate if the app's main button is active or not.
  bool inInsulinLog = false; // Boolean to indicate if the app's Insulin add log is open or not.
  bool inReminderLog = false; // Boolean to indicate if the app's Reminder add log is open or not.
  bool inPhysical = false;
  bool inFood = false;
  // ------------------------------

  // DISPLAY BOOLEANS -------------
  bool displayGlucoseTime = false; // Boolean to indicate if the app should display Time selector or not.
  bool displayInsulinTime = false; // Boolean to indicate if the app should display Time selector or not.
  bool displayReminderTime = false; // Boolean to indicate if the app should display Time selector or not.
  bool displayReminderComment = false; // Boolean to indicate if the app should display comment field or not.
  // ------------------------------

  // TRIGGERS ---------------------
  SMITrigger? drawer;
  SMITrigger? home_drawer;
  SMITrigger? log_out;
  SMITrigger? left_most_click;
  SMITrigger? left_click;
  SMITrigger? right_click;
  SMITrigger? right_most_click;
  SMITrigger? before_meal;
  SMITrigger? after_meal;
  SMITrigger? add_glucose_log;
  SMITrigger? save_glucose_log;
  SMITrigger? close_glucose_log;
  SMITrigger? main_button;
  SMITrigger? button_up_left;
  SMITrigger? button_up_right;
  SMITrigger? add_insulin_log;
  SMITrigger? save_insulin_log;
  SMITrigger? close_insulin_log;
  SMITrigger? after_meal_insulin;
  SMITrigger? before_meal_insulin;
  SMITrigger? monday_click;
  SMITrigger? tuesday_click;
  SMITrigger? wednesday_click;
  SMITrigger? thursday_click;
  SMITrigger? friday_click;
  SMITrigger? saturday_click;
  SMITrigger? sunday_click;
  SMITrigger? yes_click;
  SMITrigger? no_click;
  SMITrigger? add_reminder;
  SMITrigger? close_reminder;
  SMITrigger? save_reminder;
  SMITrigger? view_physical;
  SMITrigger? close_physical;
  SMITrigger? to_page1;
  SMITrigger? to_page2;
  SMITrigger? view_food;
  SMITrigger? close_food;
  // ------------------------------

  // BOOLEANS ---------------------
  // ------------------------------

  // NUMBERS ----------------------
  SMIInput<double>? Liquid1_level;
  SMIInput<double>? Liquid2_level;
  // ------------------------------

  // drawer.riv -------------------
  @override
  void _onRiveInit1(Artboard artboard){
    final controller = 
        StateMachineController.fromArtboard(artboard, 'Drawer Machine');
    if (controller != null){
      artboard.addController(controller);
      drawer = controller.findInput<bool>('drawer') as SMITrigger;
      log_out = controller.findInput<bool>('log_out') as SMITrigger;
    }
  }
  // ------------------------------

  // home.riv ---------------------
  @override
  void _onRiveInit2(Artboard artboard){
    final controller =
        StateMachineController.fromArtboard(artboard, 'State Machine 1');
    if (controller != null) {
      artboard.addController(controller);
      home_drawer = controller.findInput<bool>('drawer') as SMITrigger;
      Liquid1_level = controller.findInput('Liquid1_level');
      Liquid2_level = controller.findInput('Liquid2_level');
      right_most_click = controller.findInput<bool>('right_most_click') as SMITrigger;
      right_click = controller.findInput<bool>('right_click') as SMITrigger;
      left_click = controller.findInput<bool>('left_click') as SMITrigger;
      left_most_click = controller.findInput<bool>('left_most_click') as SMITrigger;
      main_button = controller.findInput<bool>('main_button') as SMITrigger;
      button_up_left = controller.findInput<bool>('button_up_left') as SMITrigger;
      button_up_right = controller.findInput<bool>('button_up_right') as SMITrigger;
    }
  }
  // ------------------------------

  // glucose_log.riv --------------
  @override
  void _onRiveInit3(Artboard artboard){
    final controller =
        StateMachineController.fromArtboard(artboard, "Before After Machine");
    if (controller != null){
      artboard.addController(controller);
      before_meal = controller.findInput<bool>('before_meal') as SMITrigger;
      after_meal = controller.findInput<bool>('after_meal') as SMITrigger;
      add_glucose_log = controller.findInput<bool>('add_glucose_log') as SMITrigger;
      save_glucose_log = controller.findInput<bool>('save_glucose_log') as SMITrigger;
      close_glucose_log = controller.findInput<bool>('close_glucose_log') as SMITrigger;
    }
  }
  // ------------------------------

  // insulin_log.riv --------------
  @override
  void _onRiveInit4(Artboard artboard){
    final controller =
        StateMachineController.fromArtboard(artboard, "Insulin Machine");
    if (controller != null){
      artboard.addController(controller);
      add_insulin_log = controller.findInput<bool>('add_insulin_log') as SMITrigger;
      save_insulin_log = controller.findInput<bool>('save_insulin_log') as SMITrigger;
      close_insulin_log = controller.findInput<bool>('close_insulin_log') as SMITrigger;
      after_meal_insulin = controller.findInput<bool>('after_meal_insulin') as SMITrigger;
      before_meal_insulin = controller.findInput<bool>('before_meal_insulin') as SMITrigger;
    }
  }
  // ------------------------------

  // add_reminder.riv -------------
  @override
  void _onRiveInit5(Artboard artboard){
    final controller =
        StateMachineController.fromArtboard(artboard, "Reminder Machine");
    if (controller != null){
      artboard.addController(controller);
      monday_click = controller.findInput<bool>('monday_click') as SMITrigger;
      tuesday_click = controller.findInput<bool>('tuesday_click') as SMITrigger;
      wednesday_click = controller.findInput<bool>('wednesday_click') as SMITrigger;
      thursday_click = controller.findInput<bool>('thursday_click') as SMITrigger;
      friday_click = controller.findInput<bool>('friday_click') as SMITrigger;
      saturday_click = controller.findInput<bool>('saturday_click') as SMITrigger;
      sunday_click = controller.findInput<bool>('sunday_click') as SMITrigger;
      yes_click = controller.findInput<bool>('yes_click') as SMITrigger;
      no_click = controller.findInput<bool>('no_click') as SMITrigger;
      add_reminder = controller.findInput<bool>('add_reminder') as SMITrigger;
      close_reminder = controller.findInput<bool>('close_reminder') as SMITrigger;
      save_reminder = controller.findInput<bool>('save_reminder') as SMITrigger;
    }
  }

  // physical.riv -----------------
  @override
  void _onRiveInit6(Artboard artboard){
    final controller =
        StateMachineController.fromArtboard(artboard, "Physical Machine");
    if (controller != null){
      artboard.addController(controller);
      view_physical = controller.findInput<bool>('view_physical') as SMITrigger;
      close_physical = controller.findInput<bool>('close_physical') as SMITrigger;
      to_page1 = controller.findInput<bool>('to_page1') as SMITrigger;
      to_page2 = controller.findInput<bool>('to_page2') as SMITrigger;

    }
  }

  // food.riv ---------------------
  void _onRiveInit7(Artboard artboard){
    final controller =
        StateMachineController.fromArtboard(artboard, "Food Machine");
    if (controller != null){
      artboard.addController(controller);
      view_food = controller.findInput<bool>('view_food') as SMITrigger;
      close_food = controller.findInput<bool>('close_food') as SMITrigger;
    }
  }

  // METHODS ----------------------
  Future<TimeOfDay?> pickTime() => showTimePicker(
    context: context,
    initialTime: const TimeOfDay(hour: 0, minute: 0),
    builder: (context, child) {
      return Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            surface: Color(0xFF161822),
            primary: Color(0xFF00FFA3),
            onSurface: Color(0x78FFFFFF),
          ),
          buttonTheme: const ButtonThemeData(
            colorScheme: ColorScheme.dark(
              primary: Color(0x78FFFFFF),
            )
          ),
        ),
        child: child!,
      );
    }
  );

  int computeAVG(List<GlucoseLog> logs){
    double sum = 0;
    int n = logs.length;
    if (n == 0){
      return 0;
    }
    print("Glucose logs = [");
    for (var element in logs) {
      print("${element.log}");
      sum += element.log;
    }
    print("]");
    return (sum ~/ n);
  }

  GlucoseLog getLastGlucoseLog(){
    try {
      List<GlucoseLog> L = glucoseBox.values.toList();
      noLatest = false;
      setState(() {

      });
      return L.last;
    }
    catch (e){
      noLatest = true;
      setState(() {

      });
      return currentGlucoseLog;
    }
  }


  void updateInBlood(double lastFastEntry, double lastBasalEntry){
    print("updateInBlood has been called! Beginning update...");
    var updatedLog = insulinBox.get("inBlood");
    print(updatedLog);
    updatedLog!.fastinsulin_dose += lastFastEntry;
    updatedLog.basalinsulin_dose += lastBasalEntry;
    print("Values updated! FAST = ${updatedLog.fastinsulin_dose} | BASAL = ${updatedLog.basalinsulin_dose}");
    maxInsulinlog.fastinsulin_dose = updatedLog.fastinsulin_dose;
    maxInsulinlog.basalinsulin_dose = updatedLog.basalinsulin_dose;
    fastStep = maxInsulinlog.fastinsulin_dose / 5400;
    print("FAST STEP ${fastStep}");
    basalStep = maxInsulinlog.basalinsulin_dose / 14400;
    print("BASAL STEP ${basalStep}");
    insulinBox.put("steps",InsulinLog(fastStep,basalStep,4,DateTime.now()));
    print("New fast MAX = ${maxInsulinlog.fastinsulin_dose} | New basal MAX = ${maxInsulinlog.basalinsulin_dose}");
    insulinBox.put("inBlood",updatedLog);
    insulinBox.put("maxLog",maxInsulinlog);
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // The following code calculates the difference in date between
    // "inBlood" insulinLog and DateTime.now() and subtracts the adequate ammount

    var lastSteps = insulinBox.get("steps");
    double lastFastStep = 0;
    double lastBasalStep = 0;
    if (lastSteps != null){
      lastFastStep = lastSteps.fastinsulin_dose;
      lastBasalStep = lastSteps.basalinsulin_dose;
      print("Last stepps werent null!");
      print("LAST FAST STEP = ${lastFastStep}");
      print("LAST BASAL STEP = ${lastBasalStep}");
      fastStep = lastFastStep;
      basalStep = lastBasalStep;
    }
    var updateInBlood = insulinBox.get("inBlood");
    double lastFastInsulin = 0;
    double lastBasalInsulin = 0;
    int dateDiff = 0;
    if (updateInBlood != null){
      print("last inblood Was not null!");
      lastFastInsulin = updateInBlood.fastinsulin_dose;
      print("Last Fast Insulin = ${lastFastInsulin}");
      lastBasalInsulin = updateInBlood.basalinsulin_dose;
      print("Last Basal Insulin = ${lastBasalInsulin}");
      dateDiff = DateTime.now().difference(updateInBlood.dateTime!).inSeconds;
      print("Date diff = ${dateDiff}");
      lastFastInsulin -= lastFastStep * dateDiff;
      lastFastInsulin = lastFastInsulin < 0 ? 0 : lastFastInsulin;
      print("FINAL VALUE LAST FAST INSULIN = ${lastFastInsulin}");
      lastBasalInsulin -= lastBasalStep * dateDiff;
      lastBasalInsulin = lastBasalInsulin < 0 ? 0 : lastBasalInsulin;
      print("FINAL VALUE LAST BASAL INSULIN = ${lastBasalInsulin}");
      insulinBox.put("inBlood", InsulinLog(lastFastInsulin,lastBasalInsulin,2,DateTime.now()));
    }




    Timer.periodic(const Duration(seconds: 2),(Timer t){
      var inBloodLog = insulinBox.get("inBlood");
      if (inBloodLog == null){
        insulinBox.put("inBlood", InsulinLog(0,0,2,DateTime.now()));
        print("inBlood was not found, a new one was created !");
        inBloodLog = insulinBox.get("inBlood");
      }
      print("oui");
      basalInsulin = inBloodLog!.basalinsulin_dose;
      fastActingInsulin = inBloodLog.fastinsulin_dose;
      var maxLog = insulinBox.get("maxLog");
      if (maxLog == null){
        insulinBox.put("maxLog",InsulinLog(1,1,3,DateTime.now()));
        print("maxLog was not found, a new one was created !");
        maxLog = insulinBox.get("maxLog");
      }
      maxFast = maxLog!.fastinsulin_dose;
      print("oui");
      maxBasal = maxLog.basalinsulin_dose;
      print("inBlood log retrieved!");
      print("Fast Step  = ${fastStep} | Basal Step = ${basalStep}");
      if (fastActingInsulin >= fastStep ) {
        print(fastStep);
        fastActingInsulin -= fastStep;
        print("Value of Fast acting has been decremented!\nFast acting = ${fastActingInsulin}");
      }
      else{
        print("Values have are 0!\nFast acting = ${fastActingInsulin}"
            " | Basal = ${basalInsulin}");
      }
      if (basalInsulin >= basalStep){
        basalInsulin -= basalStep;
        print("Value of Basal has been decremented!\n| Basal = ${basalInsulin}");
      }
      else {
        print("Values have are 0!\nFast acting = ${fastActingInsulin}"
            " | Basal = ${basalInsulin}");
      }
      inBloodLog.fastinsulin_dose = fastActingInsulin;
      inBloodLog.basalinsulin_dose = basalInsulin;
      insulinBox.put("inBlood",inBloodLog);
      print("inBlood Log has been put inside the box / updated: ${inBloodLog}");
      if (mounted){
        /// The mounted property indicates whether or not the current widget is still in the Widget Tree.
        /// Calling setState with mounted being false results in an error!
        setState(() {
          print("Current maxFast = ${maxFast}");
          if (fastActingInsulin < fastStep){
            if (fastActingInsulin < 0.009){
              Liquid1_level?.change(0);
            }
            else {
              fastStep = fastStep / 2;
              fastActingInsulin -= fastStep;
              Liquid1_level?.change(123 * fastActingInsulin / maxFast);
            }
          }
          else {
            Liquid1_level?.change( 123 * fastActingInsulin / maxFast);
          }
          print("Fast acting Liquid1 level changed!");
          if (basalInsulin < basalStep){
            if (basalInsulin < 0.009){
              Liquid2_level?.change(0);
            }
            else {
              basalStep = basalStep / 2;
              basalInsulin -= basalStep;
              Liquid2_level?.change(123 * basalInsulin / maxBasal);
            }
          }
          else{
            Liquid2_level?.change(123 * basalInsulin / maxBasal);
          }
          print("Basal Liquid2 level changed!");
        });
      }
      else {
        // No reason to keep the Timer going if the widget is no longer in the Widget Tree.
        t.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Liquid1 level = ${Liquid1_level?.value}");
    print("Liquid2 level = ${Liquid2_level?.value}");
    print("MAX FAST = ${maxFast}");
    print("MAX BASAL = ${maxBasal}");
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final hoursGlucose = dateTimeGlucose.hour.toString().padLeft(2,'0');
    final minutesGlucose = dateTimeGlucose.minute.toString().padLeft(2,'0');
    final hoursInsulin = dateTimeInsulin.hour.toString().padLeft(2,'0');
    final minutesInsulin = dateTimeInsulin.minute.toString().padLeft(2,'0');
    final hoursReminder = dateTimeReminder.hour.toString().padLeft(2,'0');
    final minutesReminder = dateTimeReminder.minute.toString().padLeft(2,'0');
    SystemChrome.setSystemUIOverlayStyle(mySystemTheme);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: (){
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [Stack(
                children: [
                  Container(
                  width: width,
                  height: height,
                  color: const Color(0xFFFF),
                ),
                  Positioned(
                    width: width,
                    height: height,
                    child: RiveAnimation.asset(
                      "./assets/Rive/home.riv",
                      fit: BoxFit.cover,
                      onInit: _onRiveInit2,
                      stateMachines: ["State Machine 1"],
                    ),
                  ),

                  // TODO: INBETWEEN THESE TWO WIDGETS, PUT THE TEXT / NUMBER WIDGETS !
                  // AVERAGE GLUCOSE ----------
                    Positioned(
                      top: height*0.232,
                      left: width*0.40,
                      child: Text(
                        computeAVG(Boxes.getGlucoseLogs().values.toList().cast<GlucoseLog>()).toString(),
                        style: TextStyle(
                          color: inHome ? const Color(0xFF00FFA3) : const Color(0x8C00FFA3),
                          fontFamily: "Lexend",
                          fontSize: 22,
                          shadows: [Shadow(
                            offset: const Offset(0,0),
                            blurRadius: 20,
                            color: inHome ? const Color(0xFF0FFFA3) : const Color(0x240FFFA3),
                          )]
                        ),
                      )
                    ),
                  Positioned(
                      top: 208,
                      left: 212,
                      child: Text(
                        "mg/dl",
                        style: TextStyle(
                            color: inHome ? const Color(0xFF00FFA3) : const Color(0x8C00FFA3),
                            fontFamily: "Lexend",
                            fontSize: 16,
                          shadows: [Shadow(
                            offset: const Offset(0,0),
                            blurRadius: 20,
                            color: inHome ? const Color(0xFF0FFFA3) : const Color(0x240FFFA3),
                          )]
                        ),
                      )
                  ),
                  // --------------------------

                  // LATEST LOG ---------------
                    Positioned(
                        top: height*0.232,
                        left: width*0.70,
                        child: Text(
                          getLastGlucoseLog().log.toInt().toString(),
                          style: TextStyle(
                              color: inHome ? const Color(0xFF00FFA3) : const Color(0x8C00FFA3),
                              fontFamily: "Lexend",
                              fontSize:22,
                              shadows: [Shadow(
                                offset: const Offset(0,0),
                                blurRadius: 20,
                                color: inHome ? const Color(0xFF0FFFA3) : const Color(0x240FFFA3),
                              )]
                          ),
                        )
                    ),
                  Positioned(
                      top: 208,
                      left: 332,
                      child: Text(
                        "mg/dl",
                        style: TextStyle(
                            color: inHome ? const Color(0xFF00FFA3) : const Color(0x8C00FFA3),
                            fontFamily: "Lexend",
                            fontSize: 16,
                            shadows: [Shadow(
                              offset: const Offset(0,0),
                              blurRadius: 20,
                              color: inHome ? const Color(0xFF0FFFA3) : const Color(0x240FFFA3),
                            )]
                        ),
                      )
                  ),
                  Positioned(
                      top: 610,
                      left: 20,
                      child: Text(
                        fastActingInsulin.toStringAsFixed(2),
                        style: TextStyle(
                            color: inHome ? const Color(0xFF00FFA3) : const Color(0x8C00FFA3),
                            fontFamily: "Lexend",
                            fontSize: 28,
                            shadows: [Shadow(
                              offset: const Offset(3,3),
                              blurRadius: 15,
                              color: inHome ? const Color(0xAD0FFFA3) : const Color(0x240FFFA3),
                            )]
                        ),
                      )
                  ),
                  Positioned(
                      top: 618,
                      left: 92,
                      child: Text(
                        "remaining",
                        style: TextStyle(
                            color: inHome ? const Color(0xFF00FFA3) : const Color(0x8C00FFA3),
                            fontFamily: "Lexend",
                            fontSize: 18,
                            letterSpacing: -1,
                            shadows: [Shadow(
                              offset: const Offset(3,3),
                              blurRadius: 15,
                              color: inHome ? const Color(0xAD0FFFA3) : const Color(0x240FFFA3),
                            )]
                        ),
                      )
                  ),
                  Positioned(
                      top: 610,
                      left: 220,
                      child: Text(
                        basalInsulin.toStringAsFixed(2),
                        style: TextStyle(
                            color: inHome ? const Color(0xFF00FFA3) : const Color(0x8C00FFA3),
                            fontFamily: "Lexend",
                            fontSize: 28,
                            shadows: [Shadow(
                              offset: const Offset(3,3),
                              blurRadius: 15,
                              color: inHome ? const Color(0xAD0FFFA3) : const Color(0x240FFFA3),
                            )]
                        ),
                      )
                  ),
                  Positioned(
                      top: 618,
                      left: 290,
                      child: Text(
                        "remaining",
                        style: TextStyle(
                            color: inHome ? const Color(0xFF00FFA3) : const Color(0x8C00FFA3),
                            fontFamily: "Lexend",
                            fontSize: 18,
                            letterSpacing: -1,
                            shadows: [Shadow(
                              offset: const Offset(3,3),
                              blurRadius: 15,
                              color: inHome ? const Color(0xAD0FFFA3) : const Color(0x240FFFA3),
                            )]
                        ),
                      )
                  ),
                  Positioned(
                      top: 423,
                      left: 55,
                      child: Text(
                        maxFast.toStringAsFixed(2),
                        style: TextStyle(
                            color: inHome ? const Color(0xFFFFFFFF) : const Color(0x8CFFFFFF),
                            fontFamily: "Lexend",
                            fontSize: 24,
                            letterSpacing: -2,
                            shadows: [Shadow(
                              offset: const Offset(0,0),
                              blurRadius: 20,
                              color: inHome ? const Color(0xFFFFFFFF) : const Color(0x24FFFFFF),
                            )]
                        ),
                      )
                  ),
                  Positioned(
                      top: 423,
                      left: 110,
                      child: Text(
                        "units",
                        style: TextStyle(
                            color: inHome ? const Color(0xFFFFFFFF) : const Color(0x8CFFFFFF),
                            fontFamily: "Lexend",
                            fontSize: 22,
                            letterSpacing: -3,
                            shadows: [Shadow(
                              offset: const Offset(3,3),
                              blurRadius: 15,
                              color: inHome ? const Color(0xADFFFFFF) : const Color(0x24FFFFFF),
                            )]
                        ),
                      )
                  ),
                  Positioned(
                      top: 423,
                      left: 252,
                      child: Text(
                        maxBasal.toStringAsFixed(2),
                        style: TextStyle(
                            color: inHome ? const Color(0xFFFFFFFF) : const Color(0x8CFFFFFF),
                            fontFamily: "Lexend",
                            fontSize: 24,
                            letterSpacing: -2,
                            shadows: [Shadow(
                              offset: const Offset(0,0),
                              blurRadius: 20,
                              color: inHome ? const Color(0xFFFFFFFF) : const Color(0x24FFFFFF),
                            )]
                        ),
                      )
                  ),
                  Positioned(
                      top: 423,
                      left: 308,
                      child: Text(
                        "units",
                        style: TextStyle(
                            color: inHome ? const Color(0xFFFFFFFF) : const Color(0x8CFFFFFF),
                            fontFamily: "Lexend",
                            fontSize: 22,
                            letterSpacing: -3,
                            shadows: [Shadow(
                              offset: const Offset(3,3),
                              blurRadius: 15,
                              color: inHome ? const Color(0xADFFFFFF) : const Color(0x24FFFFFF),
                            )]
                        ),
                      )
                  ),
                  // TODO: INBETWEEN THESE TWO WIDGETS, PUT THE TEXT / NUMBER WIDGETS !

                  Positioned(
                    child: RiveAnimation.asset(
                      "./assets/Rive/drawer.riv",
                      fit: BoxFit.cover,
                      onInit: _onRiveInit1,
                      stateMachines: ["Drawer Machine"],
                    ),
                    width: width,
                    height: height,
                  ),
                  Positioned(
                    width: width,
                    height: height,
                    child: RiveAnimation.asset(
                      "./assets/Rive/glucose_log.riv",
                      fit: BoxFit.cover,
                      onInit: _onRiveInit3,
                      stateMachines: ["Before After Machine"],
                    ),
                  ),
                  Positioned(
                    width: width,
                    height: height,
                    child: RiveAnimation.asset(
                      "./assets/Rive/insulin_log.riv",
                      fit: BoxFit.cover,
                      onInit: _onRiveInit4,
                      stateMachines: ["Insulin Machine"],
                    ),
                  ),
                  Positioned(
                    width: width,
                    height: height,
                    child: RiveAnimation.asset(
                      "./assets/Rive/add_reminder.riv",
                      fit: BoxFit.cover,
                      onInit: _onRiveInit5,
                      stateMachines: ["Reminder Machine"],
                    ),
                  ),
                  Positioned(
                    width: width,
                    height: height,
                    child: RiveAnimation.asset(
                      "./assets/Rive/physical.riv",
                      fit: BoxFit.cover,
                      onInit: _onRiveInit6,
                      stateMachines: ["Physical Machine"],
                    ),
                  ),
                  Positioned(
                    width: width,
                    height: height,
                    child: RiveAnimation.asset(
                      "./assets/Rive/food.riv",
                      fit: BoxFit.cover,
                      onInit: _onRiveInit7,
                      stateMachines: ["Food Machine"],
                    ),
                  ),
                  // TODO: UNDER HERE, PUT THE BUTTON WIDGETS!
                  // Drawer -------------------------
                  if (inHome)
                    Positioned(
                      top: 25,
                      left: 25,
                      child: GestureDetector(
                          onTap: (){
                            print('Drawer opened!');
                            drawer?.fire();
                            home_drawer?.fire();
                            setState(() {
                              inInsulinLog = false;
                              inDrawer = true;
                              inHome = false;
                              inGlucoseLog = false;
                              inMainButton = false;
                              print("The current state is:\ninHome = ${inHome} | inDrawer = ${inDrawer} "
                                  "| inGlucoseLog = ${inGlucoseLog} | inMainButton = ${inMainButton}"
                                  " | inInsulinLog = ${inInsulinLog}\nState"
                                  " variables changing soon due to transition time: NONE");
                            });
                          },
                          child: Container(
                            width: 55,
                            height: 55,
                            color: const Color(0xE70000),
                          ),
                      ),
                    ),
                  if (inDrawer)
                    Positioned(
                      top: 230,
                      left: 275,
                      child: GestureDetector(
                        onPanUpdate: (details){
                          if (details.delta.dx < -2){
                              print('Drawer closed!');
                              drawer?.fire();
                              home_drawer?.fire();
                              setState(() {
                                inInsulinLog = false;
                                inDrawer = false;
                                inHome = true;
                                inGlucoseLog = false;
                                inMainButton = false;
                                print("The current state is:\ninHome = ${inHome} | inDrawer = ${inDrawer} "
                                  "| inGlucoseLog = ${inGlucoseLog} | inMainButton = ${inMainButton}"
                                    " | inInsulinLog = ${inInsulinLog}\nState"
                                  " variables changing soon due to transition time: NONE");
                              });
                          }
                        },
                        child: Container(
                          width: 60,
                          height: 390,
                          color: const Color(0xE70000),
                        ),
                      ),
                    ),
                  if (inDrawer)
                    Positioned(
                      top: 310,
                      left: 0,
                      child: GestureDetector(
                        onTap: (){
                          print("USER LOGGING OUT...");
                          AuthService _a = AuthService();
                          _a.signOut();
                          Future.delayed(const Duration(milliseconds: 500),(){
                            Navigator.pushReplacementNamed(context, get_started.Get_Started.id);
                            print("Pushed on the stack!");
                          });
                          setState(() {
                            inInsulinLog = false;
                            inDrawer = false;
                            inHome = false;
                            inGlucoseLog = false;
                            inMainButton = false;
                            print("The current state is:\ninHome = ${inHome} | inDrawer = ${inDrawer} "
                                "| inGlucoseLog = ${inGlucoseLog} | inMainButton = ${inMainButton}"
                                " | inInsulinLog = ${inInsulinLog}\nState"
                                " variables changing soon due to transition time: NONE");
                          });
                        },
                        child: Container(
                          width: 230,
                          height: 50,
                          color: const Color(0xE70000),
                        ),
                      ),
                    ),
                  // --------------------------------
                  // Tool bar -----------------------
                  if (inHome)
                    Positioned(
                      top: 725,
                      left: 155,
                      child: GestureDetector(
                        onTap: (){
                          print("User tapped main button!");
                          main_button?.fire();
                          setState(() {
                            inInsulinLog = false;
                            inDrawer = false;
                            inGlucoseLog = false;
                            print("The current state is:\ninHome = ${inHome} | inDrawer = ${inDrawer} "
                                "| inGlucoseLog = ${inGlucoseLog} | inMainButton = ${inMainButton}"
                                " | inInsulinLog = ${inInsulinLog}\nState"
                                " variables changing soon due to transition time: inHome | inMainButton");
                          });
                          Future.delayed(const Duration(milliseconds: 100),(){
                            setState(() {
                              inHome = false;
                              print("The current state is:\ninHome = ${inHome} | inDrawer = ${inDrawer} "
                                  "| inGlucoseLog = ${inGlucoseLog} | inMainButton = ${inMainButton}"
                                  " | inInsulinLog = ${inInsulinLog}\nState"
                                  " variables changing soon due to transition time: inMainButton");
                            });
                          });
                          Future.delayed(const Duration(milliseconds: 2500),(){
                            setState(() {
                              inMainButton = true;
                              print("The current state is:\ninHome = ${inHome} | inDrawer = ${inDrawer} "
                                  "| inGlucoseLog = ${inGlucoseLog} | inMainButton = ${inMainButton}"
                                  " | inInsulinLog = ${inInsulinLog}");
                            });
                          });
                        },
                        child: ClipOval(
                          child: Container(
                            width: 80,
                            height: 80,
                            color: const Color(0xFFF),
                          ),
                        ),
                      ),
                    ),
                  if (inHome)
                    Positioned(
                      top: 760,
                      child: GestureDetector(
                        onTap: (){
                          print('User tapped the food icon!');
                          left_most_click?.fire();
                          view_food?.fire();
                          inHome = false;
                          inFood = true;
                          setState(() {

                          });
                        },
                        child: Container(
                          width: 80,
                          height: 120,
                          color: const Color(0xE70000),
                        ),
                      )
                    ),
                  if (inHome)
                    Positioned(
                      top: 760,
                      left: -15,
                      child:  GestureDetector(
                        onTap: (){
                          print('User tapped the food icon!');
                          left_most_click?.fire();
                          view_food?.fire();
                          inHome = false;
                          inFood = true;
                          setState(() {

                          });
                        },
                        child: Container(
                          width: 120,
                          height: 40,
                          color: const Color(0xE70000),
                        ),
                      ),
                    ),
                  if (inHome)
                    Positioned(
                      top: 820,
                      left: 80,
                      child:  GestureDetector(
                        onTap: (){
                          print('User tapped the blood icon!');
                          left_click?.fire();
                          setState(() {
                            glucoseBox.clear();

                          });
                        },
                        child: Container(
                          width: 110,
                          height: 40,
                          color: const Color(0xFF9E),
                        ),
                      ),
                    ),
                  if (inHome)
                    Positioned(
                      top: 760,
                      left: 110,
                      child:  GestureDetector(
                        onTap: (){
                          print('User tapped the blood icon!');
                          left_click?.fire();
                          setState(() {
                            glucoseBox.clear();
                          });
                        },
                        child: Container(
                          width: 50,
                          height: 110,
                          color: const Color(0xFF9E),
                        ),
                      ),
                    ),
                  if (inHome)
                    Positioned(
                      top: 820,
                      left: 195,
                      child:  GestureDetector(
                        onTap: (){
                          print('User tapped the running icon!');
                          right_click?.fire();
                          view_physical?.fire();
                          inHome = false;
                          inPhysical = true;
                          setState(() {

                          });
                        },
                        child: Container(
                          width: 110,
                          height: 40,
                          color: const Color(0xFF9E),
                        ),
                      ),
                    ),
                  if (inHome)
                    Positioned(
                      top: 760,
                      left: 230,
                      child:  GestureDetector(
                        onTap: (){
                          print('User tapped the running icon!');
                          right_click?.fire();
                          view_physical?.fire();
                          inHome = false;
                          inPhysical = true;
                          setState(() {

                          });
                        },
                        child: Container(
                          width: 50,
                          height: 110,
                          color: const Color(0xFF9E),
                        ),
                      ),
                    ),
                  if (inHome)
                    Positioned(
                        top: 760,
                        right: 0,
                        child: GestureDetector(
                          onTap: (){
                            print('User tapped the pills icon!');
                            right_most_click?.fire();
                            insulinBox.clear();
                            Liquid1_level?.change(0);
                            Liquid2_level?.change(0);
                            print("Insulin Box CLEARED!");
                            setState(() {

                            });
                          },
                          child: Container(
                            width: 80,
                            height: 120,
                            color: const Color(0xE70000),
                          ),
                        )
                    ),
                  if (inHome)
                    Positioned(
                      top: 760,
                      right: -15,
                      child:  GestureDetector(
                        onTap: (){
                          print('User tapped the pills icon!');
                          right_most_click?.fire();
                          setState(() {

                          });
                        },
                        child: Container(
                          width: 120,
                          height: 40,
                          color: const Color(0xE70000),
                        ),
                      ),
                    ),
                  // --------------------------------

                  // Big main button ----------------
                  if (inMainButton)
                    Positioned(
                      top: 320,
                      left: 87,
                      child: GestureDetector(
                        onTap: (){
                          main_button?.fire();
                          setState(() {
                            inInsulinLog = false;
                            inDrawer = false;
                            inGlucoseLog = false;
                            print("The current state is:\ninHome = ${inHome} | inDrawer = ${inDrawer} "
                                "| inGlucoseLog = ${inGlucoseLog} | inMainButton = ${inMainButton}"
                                " | inInsulinLog = ${inInsulinLog}\nState"
                                " variables changing soon due to transition time: inHome | inMainButton");
                          });
                          Future.delayed(const Duration(seconds: 1),(){
                            setState(() {
                              inHome = true;
                              inMainButton = false;
                              print("The current state is:\ninHome = ${inHome} | inDrawer = ${inDrawer} "
                                  "| inGlucoseLog = ${inGlucoseLog} | inMainButton = ${inMainButton}"
                                  " | inInsulinLog = ${inInsulinLog}");
                            });
                          });
                        },
                        child: ClipOval(
                          child: Container(
                            width: 215,
                            height: 215,
                            color: const Color(0xFFF),
                          ),
                        )
                      )
                    ),
                  if (inMainButton)
                    Positioned(
                      top: 255,
                      left: 65,
                      child: GestureDetector(
                        onTap: (){
                          button_up_left?.fire();
                          add_glucose_log?.fire();
                          setState(() {
                            inInsulinLog = false;
                            inMainButton = false;
                            inDrawer = false;
                            inHome = false;
                            print("The current state is:\ninHome = ${inHome} | inDrawer = ${inDrawer} "
                                "| inGlucoseLog = ${inGlucoseLog} | inMainButton = ${inMainButton}"
                                " | inInsulinLog = ${inInsulinLog}\nState"
                                " variables changing soon due to transition time: inGlucoseLog");
                          });
                          Future.delayed(const Duration(seconds: 1),(){
                            setState(() {
                              inGlucoseLog = true;
                              displayGlucoseTime = true;
                              haschoosen_TimeGlucose = false;
                              print("The current state is:\ninHome = ${inHome} | inDrawer = ${inDrawer} "
                                  "| inGlucoseLog = ${inGlucoseLog} | inMainButton = ${inMainButton}"
                                  " | inInsulinLog = ${inInsulinLog}");
                            });
                          });
                        },
                        child: Container(
                          width: 130,
                          height: 70,
                          color: const Color(0xFFF)
                        ),
                      )
                    ),
                  if (inMainButton)
                    Positioned(
                        top: 258,
                        left: 200,
                        child: GestureDetector(
                          onTap: (){
                            button_up_right?.fire();
                            add_insulin_log?.fire();
                            setState(() {
                              currentInsulinLog = InsulinLog(0,0,0,DateTime.now());
                              inInsulinLog = false;
                              inMainButton = false;
                              haschoosen_TimeInsulin = false;
                              inDrawer = false;
                              inHome = false;
                              print("The current state is:\ninHome = ${inHome} | inDrawer = ${inDrawer} "
                                  "| inGlucoseLog = ${inGlucoseLog} | inMainButton = ${inMainButton}"
                                  " | inInsulinLog = ${inInsulinLog}\nState"
                                  " variables changing soon due to transition time: inInsulinLog");
                            });
                            Future.delayed(const Duration(seconds: 1),(){
                              setState(() {
                                inInsulinLog = true;
                                displayInsulinTime = true;
                                print("The current state is:\ninHome = ${inHome} | inDrawer = ${inDrawer} "
                                    "| inGlucoseLog = ${inGlucoseLog} | inMainButton = ${inMainButton}"
                                    " | inInsulinLog = ${inInsulinLog}");
                              });
                            });
                          },
                          child: Container(
                              width: 130,
                              height: 70,
                              color: const Color(0xFFF)
                          ),
                        )
                    ),
                  if (inMainButton)
                    Positioned(
                      top: 315,
                      left: 300,
                      child: GestureDetector(
                        onTap: (){
                          print("User opened new reminder log!");
                          print(add_reminder);
                          add_reminder?.fire();
                          inMainButton = false;
                          setState(() {

                          });
                          Future.delayed(const Duration(seconds: 1),(){
                            setState(() {
                              inReminderLog = true;
                              displayReminderTime = true;
                              displayReminderComment = true;
                              print("The current state is:\ninHome = ${inHome} | inDrawer = ${inDrawer} "
                                  "| inGlucoseLog = ${inGlucoseLog} | inMainButton = ${inMainButton}"
                                  " | inInsulinLog = ${inInsulinLog} | inReminderLog = ${inReminderLog}");
                            });
                          });
                        },
                        child: Container(
                          width: 100,
                          height: 120,
                          color: const Color(0xFF),
                        ),
                      ),
                    ),
                  // --------------------------------

                  // Glucose log --------------------
                  if (inGlucoseLog)
                    Positioned(
                      top: 195,
                      left: 292,
                      child: GestureDetector(
                        onTap: (){
                          close_glucose_log?.fire();
                          setState(() {
                            glucose_controller.clear();
                            inInsulinLog = false;
                            currentGlucoseLog = GlucoseLog(0,0,DateTime.now());
                            displayGlucoseTime = false;
                            print("The current state is:\ninHome = ${inHome} | inDrawer = ${inDrawer} "
                                "| inGlucoseLog = ${inGlucoseLog} | inMainButton = ${inMainButton}"
                                " | inInsulinLog = ${inInsulinLog}\nState"
                                " variables changing soon due to transition time: inMainButton | inGlucoseLog");
                          });
                          Future.delayed(const Duration(seconds: 1),(){
                            setState(() {
                              inGlucoseLog = false;
                              inMainButton = true;
                              print("The current state is:\ninHome = ${inHome} | inDrawer = ${inDrawer} "
                                  "| inGlucoseLog = ${inGlucoseLog} | inMainButton = ${inMainButton}"
                                  " | inInsulinLog = ${inInsulinLog}");
                            });
                          });
                        },
                        child: ClipOval(
                          child: Container(
                            width: 40,
                            height: 40,
                            color: const Color(0xFFF)
                          ),
                        ),
                      )
                    ),
                  if (inGlucoseLog)
                    Positioned(
                      top: 395,
                      left: 190,
                      child: GestureDetector(
                        onTap: (){
                          after_meal?.fire();
                          print("User selected after meal !");
                          setState(() {
                            currentGlucoseLog.before_after = 1;
                          });
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          color: const Color(0xFFF),
                        ),
                      ),
                    ),
                  if (inGlucoseLog)
                    Positioned(
                      top: 395,
                      left: 240,
                      child: GestureDetector(
                        onTap: (){
                          before_meal?.fire();
                          print("User selected before meal !");
                          setState(() {
                            currentGlucoseLog.before_after = 0;
                          });
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          color: const Color(0xFF00DD),
                        ),
                      ),
                    ),
                  if (inGlucoseLog)
                    Positioned(
                      top: 641,
                      left: 160,
                      child: GestureDetector(
                        onTap: (){
                          save_glucose_log?.fire();
                          print("User saved glucose log!");
                          String? logEntry = glucose_controller.text;
                          print("Glucose entered is ${logEntry}");
                          currentGlucoseLog.log = double.parse(logEntry);

                          // --------------------------------------------
                          // TODO: SAVE GLUCOSE LOG TO PERSISTENT MEMORY!
                          final glucoseBox = Boxes.getGlucoseLogs();
                          // --------------------------------------------

                          setState(() {
                            inInsulinLog = false;
                            displayGlucoseTime = false;
                            glucoseBox.add(currentGlucoseLog);
                            print("The current state is:\ninHome = ${inHome} | inDrawer = ${inDrawer} "
                                "| inGlucoseLog = ${inGlucoseLog} | inMainButton = ${inMainButton}"
                                " | inInsulinLog = ${inInsulinLog}\nState"
                                " variables changing soon due to transition time: inMainButton | inGlucoseLog");
                            currentGlucoseLog = GlucoseLog(0,0,DateTime.now());
                          });
                          Future.delayed(const Duration(seconds: 1),(){
                            setState(() {
                              glucose_controller.clear();
                              displayGlucoseTime = false;
                              inGlucoseLog = false;
                              inMainButton = true;
                              print("The current state is:\ninHome = ${inHome} | inDrawer = ${inDrawer} "
                                  "| inGlucoseLog = ${inGlucoseLog} | inMainButton = ${inMainButton}"
                                  " | inInsulinLog = ${inInsulinLog}");
                            });
                          });
                        },
                        child: Container(
                          width: 100,
                          height: 35,
                          color: const Color(0xFF00DD),
                        ),
                      ),
                    ),
                  if (inGlucoseLog)
                    Positioned(
                      width: 40,
                      top: 550,
                      left: 215,
                      child: TextField(
                        controller: glucose_controller,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "--"
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        style: const TextStyle(
                          color: Color(0xFF212431),
                          fontFamily: "Lexend",
                          fontSize: 14
                        ),
                      ),
                    ),
                  if (displayGlucoseTime)
                    Positioned(
                      top: 263,
                      left: 117,
                      child: Container(
                        width: 170,
                        height: 40,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(const Color(0x78FFFFFF)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)
                              )
                            )
                          ),
                          child: Text(
                            haschoosen_TimeGlucose ? "$hoursGlucose:$minutesGlucose" : "Time",
                          style: const TextStyle(
                            color: Color(0xFF313546),
                            fontFamily: "Lexend",
                            fontSize: 32
                          ),),
                          onPressed: () async {
                            final time = await pickTime();
                            if (time == null) return;
                            haschoosen_TimeGlucose = true;
                            final newDateTime = DateTime(
                              dateTimeGlucose.year,
                              dateTimeGlucose.month,
                              dateTimeGlucose.day,
                              time.hour,
                              time.minute
                            );
                            setState(() {
                              dateTimeGlucose = newDateTime;
                              currentGlucoseLog.dateTime = newDateTime;
                            });
                          },
                        ),
                      ),
                    ),
                  // Insulin log --------------
                  if (inInsulinLog)
                    Positioned(
                        top: 195,
                        left: 292,
                        child: GestureDetector(
                          onTap: (){
                            close_insulin_log?.fire();
                            setState(() {
                              fastacting_insulin_controller.clear();
                              basal_insulin_controller.clear();
                              inInsulinLog = false;
                              currentInsulinLog = InsulinLog(0,0,0,DateTime.now());
                              displayInsulinTime = false;
                              print("The current state is:\ninHome = ${inHome} | inDrawer = ${inDrawer} "
                                  "| inGlucoseLog = ${inGlucoseLog} | inMainButton = ${inMainButton}"
                                  " | inInsulinLog = ${inInsulinLog}\nState"
                                  " variables changing soon due to transition time: inMainButton |");
                            });
                            Future.delayed(const Duration(seconds: 1),(){
                              setState(() {
                                inMainButton = true;
                                print("The current state is:\ninHome = ${inHome} | inDrawer = ${inDrawer} "
                                    "| inGlucoseLog = ${inGlucoseLog} | inMainButton = ${inMainButton}"
                                    " | inInsulinLog = ${inInsulinLog}");
                              });
                            });
                          },
                          child: ClipOval(
                            child: Container(
                                width: 40,
                                height: 40,
                                color: const Color(0xFFF)
                            ),
                          ),
                        )
                    ),
                  if (inInsulinLog)
                    Positioned(
                      top: 383,
                      left: 260,
                      child: GestureDetector(
                        onTap: (){
                          before_meal_insulin?.fire();
                          print("User selected before meal !");
                          setState(() {
                            // Change to the Insulin log here
                            currentInsulinLog.before_after = 0;
                          });
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          color: const Color(0xFF00DD),
                        ),
                      ),
                    ),
                  if (inInsulinLog)
                    Positioned(
                      top: 383,
                      left: 210,
                      child: GestureDetector(
                        onTap: (){
                          after_meal_insulin?.fire();
                          print("User selected after meal !");
                          setState(() {
                            // Change to the Insulin log here
                            currentInsulinLog.before_after = 1;
                          });
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          color: const Color(0x51FF),
                        ),
                      ),
                    ),
                  if (inInsulinLog)
                    Positioned(
                      width: 40,
                      top: 505,
                      left: 240,
                      child: TextField(
                        controller: fastacting_insulin_controller,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "--"
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        style: const TextStyle(
                            color: Color(0xFF212431),
                            fontFamily: "Lexend",
                            fontSize: 14
                        ),
                      ),
                    ),
                  if (inInsulinLog)
                    Positioned(
                      width: 40,
                      top: 565,
                      left: 240,
                      child: TextField(
                        controller: basal_insulin_controller,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "--"
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        style: const TextStyle(
                            color: Color(0xFF212431),
                            fontFamily: "Lexend",
                            fontSize: 14
                        ),
                      ),
                    ),
                  if (displayInsulinTime)
                    Positioned(
                      top: 255,
                      left: 127,
                      child: Container(
                        width: 170,
                        height: 40,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(const Color(0x78FFFFFF)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)
                                  )
                              )
                          ),
                          child: Text(
                            haschoosen_TimeInsulin ? "$hoursInsulin:$minutesInsulin" : "Time",
                            style: const TextStyle(
                                color: const Color(0xFF313546),
                                fontFamily: "Lexend",
                                fontSize: 32
                            ),),
                          onPressed: () async {
                            final time = await pickTime();
                            if (time == null) return;
                            haschoosen_TimeInsulin = true;
                            final newDateTime = DateTime(
                                dateTimeInsulin.year,
                                dateTimeInsulin.month,
                                dateTimeInsulin.day,
                                time.hour,
                                time.minute
                            );
                            setState(() {
                              dateTimeInsulin = newDateTime;
                              currentInsulinLog.dateTime = dateTimeInsulin;
                            });
                          },
                        ),
                      ),
                    ),
                  if (inInsulinLog)
                    Positioned(
                      top: 641,
                      left: 160,
                      child: GestureDetector(
                        onTap: (){
                          save_insulin_log?.fire();
                          print("User saved insulin log!");
                          String? fastlogEntry = fastacting_insulin_controller.text;
                          String? basalogEntry = basal_insulin_controller.text;
                          print("Fast acting insulin entered is ${fastlogEntry}");
                          print("Basal insulin entered is ${basalogEntry}");
                          currentInsulinLog.fastinsulin_dose = double.parse(fastlogEntry);
                          currentInsulinLog.basalinsulin_dose = double.parse(basalogEntry);

                          // --------------------------------------------
                          // TODO: SAVE INSULIN LOG TO PERSISTENT MEMORY!
                          final insulinBox = Boxes.getInsulinLogs();
                          if (DateTime.now().difference(currentInsulinLog.dateTime!).inHours >= 3){
                            print("DIFFERENCE GREATER THAN 3");
                            currentInsulinLog = InsulinLog(0,0,0,DateTime.now());
                            insulinBox.add(currentInsulinLog);
                            print("New log has been added to box!");
                          }
                          else {
                            insulinBox.add(currentInsulinLog);
                            print("New log has been added to box!");
                            var dateDiff = DateTime.now().difference(currentInsulinLog.dateTime!).inMinutes;
                            var addedFastInsulin = currentInsulinLog.fastinsulin_dose * (1-(dateDiff/180));
                            var addedBasalInsulin = currentInsulinLog.basalinsulin_dose *(1-(dateDiff/480));
                            updateInBlood(addedFastInsulin,
                                addedBasalInsulin);
                          }
                          // --------------------------------------------

                          setState(() {
                            inInsulinLog = false;
                            displayInsulinTime = false;
                            print("The currentInsulin log is: ${currentInsulinLog}");
                            print("NOW = ${DateTime.now()} | LOG TIME = ${currentInsulinLog.dateTime}");
                            print(DateTime.now().difference(currentInsulinLog.dateTime!).inHours);
                            print("The current state is:\ninHome = ${inHome} | inDrawer = ${inDrawer} "
                                "| inGlucoseLog = ${inGlucoseLog} | inMainButton = ${inMainButton}"
                                " | inInsulinLog = ${inInsulinLog}\nState"
                                " variables changing soon due to transition time: inMainButton");
                          });
                          Future.delayed(const Duration(seconds: 1),(){
                            setState(() {
                              fastacting_insulin_controller.clear();
                              basal_insulin_controller.clear();
                              displayGlucoseTime = false;
                              inGlucoseLog = false;
                              inMainButton = true;
                              print("The current state is:\ninHome = ${inHome} | inDrawer = ${inDrawer} "
                                  "| inGlucoseLog = ${inGlucoseLog} | inMainButton = ${inMainButton}"
                                  " | inInsulinLog = ${inInsulinLog}");
                            });
                          });
                        },
                        child: Container(
                          width: 100,
                          height: 35,
                          color: const Color(0xFF00DD),
                        ),
                      ),
                    ),
                  // inReminderLog ------------
                  if (inReminderLog)
                    Positioned(
                        top: 195,
                        left: 292,
                        child: GestureDetector(
                          onTap: (){
                            displayReminderTime = false;
                            displayReminderComment = false;
                            close_reminder?.fire();
                            setState(() {
                              print("The current state is:\ninHome = ${inHome} | inDrawer = ${inDrawer} "
                                  "| inGlucoseLog = ${inGlucoseLog} | inMainButton = ${inMainButton}"
                                  " | inInsulinLog = ${inInsulinLog} | inReminderLog = ${inReminderLog}\nState"
                                  " variables changing soon due to transition time: inMainButton | inReminderLog");
                            });
                            Future.delayed(const Duration(seconds: 1),(){
                              setState(() {
                                inReminderLog = false;
                                inMainButton = true;
                                print("The current state is:\ninHome = ${inHome} | inDrawer = ${inDrawer} "
                                    "| inGlucoseLog = ${inGlucoseLog} | inMainButton = ${inMainButton}"
                                    " | inInsulinLog = ${inInsulinLog}");
                              });
                            });
                          },
                          child: ClipOval(
                            child: Container(
                                width: 40,
                                height: 40,
                                color: const Color(0xFF)
                            ),
                          ),
                        )
                    ),
                  if (inReminderLog)
                    Positioned(
                      top: 475,
                      left: 262,
                      child: GestureDetector(
                        onTap: (){
                          print("User selected NO PERIODIC!");
                          no_click?.fire();
                          setState(() {
                            currentReminderLog.periodic = false;
                          });
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          color: const Color(0xFF)
                        ),
                      )
                    ),
                  if (inReminderLog)
                    Positioned(
                        top: 475,
                        left: 210,
                        child: GestureDetector(
                          onTap: (){
                            print("User selected YES PERIODIC!");
                            yes_click?.fire();
                            setState(() {
                              currentReminderLog.periodic = true;
                            });
                          },
                          child: Container(
                              width: 50,
                              height: 50,
                              color: const Color(0xFF)
                          ),
                        )
                    ),
                  if (inReminderLog)
                    Positioned(
                        top: 250,
                        left: 124,
                        child: GestureDetector(
                          onTap: (){
                            print("User selected MONDAY!");
                            monday_click?.fire();
                            setState(() {
                              if (currentReminderLog.days.contains(2)){
                                currentReminderLog.days.remove(2);
                              }
                              else{
                                currentReminderLog.days.add(2);
                              }
                            });
                          },
                          child: Container(
                              width: 35,
                              height: 50,
                              color: const Color(0xFF)
                          ),
                        )
                    ),
                  if (inReminderLog)
                    Positioned(
                        top: 250,
                        left: 159,
                        child: GestureDetector(
                          onTap: (){
                            print("User selected TUESDAY!");
                            tuesday_click?.fire();
                            setState(() {
                              if (currentReminderLog.days.contains(3)){
                                currentReminderLog.days.remove(3);
                              }
                              else{
                                currentReminderLog.days.add(3);
                              }
                            });
                          },
                          child: Container(
                              width: 25,
                              height: 50,
                              color: const Color(0xFF)
                          ),
                        )
                    ),
                  if (inReminderLog)
                    Positioned(
                        top: 250,
                        left: 182,
                        child: GestureDetector(
                          onTap: (){
                            print("User selected WEDNESDAY!");
                            wednesday_click?.fire();
                            setState(() {
                              if (currentReminderLog.days.contains(4)){
                                currentReminderLog.days.remove(4);
                              }
                              else{
                                currentReminderLog.days.add(4);
                              }
                            });
                          },
                          child: Container(
                              width: 25,
                              height: 50,
                              color: const Color(0xFF)
                          ),
                        )
                    ),
                  if (inReminderLog)
                    Positioned(
                        top: 250,
                        left: 205,
                        child: GestureDetector(
                          onTap: (){
                            print("User selected THURSDAY!");
                            thursday_click?.fire();
                            setState(() {
                              if (currentReminderLog.days.contains(5)){
                                currentReminderLog.days.remove(5);
                              }
                              else{
                                currentReminderLog.days.add(5);
                              }
                            });
                          },
                          child: Container(
                              width: 25,
                              height: 50,
                              color: const Color(0xFF)
                          ),
                        )
                    ),
                  if (inReminderLog)
                    Positioned(
                        top: 250,
                        left: 228,
                        child: GestureDetector(
                          onTap: (){
                            print("User selected FRIDAY!");
                            friday_click?.fire();
                            setState(() {
                              if (currentReminderLog.days.contains(6)){
                                currentReminderLog.days.remove(6);
                              }
                              else{
                                currentReminderLog.days.add(6);
                              }
                            });
                          },
                          child: Container(
                              width: 25,
                              height: 50,
                              color: const Color(0xFF)
                          ),
                        )
                    ),
                  if (inReminderLog)
                    Positioned(
                        top: 250,
                        left: 251,
                        child: GestureDetector(
                          onTap: (){
                            print("User selected SATURDAY!");
                            saturday_click?.fire();
                            setState(() {
                              if (currentReminderLog.days.contains(7)){
                                currentReminderLog.days.remove(7);
                              }
                              else{
                                currentReminderLog.days.add(7);
                              }
                            });
                          },
                          child: Container(
                              width: 25,
                              height: 50,
                              color: const Color(0xFF)
                          ),
                        )
                    ),
                  if (inReminderLog)
                    Positioned(
                        top: 250,
                        left: 274,
                        child: GestureDetector(
                          onTap: (){
                            print("User selected SUNDAY!");
                            sunday_click?.fire();
                            setState(() {
                              if (currentReminderLog.days.contains(1)){
                                currentReminderLog.days.remove(1);
                              }
                              else{
                                currentReminderLog.days.add(1);
                              }
                            });
                          },
                          child: Container(
                              width: 35,
                              height: 50,
                              color: const Color(0xFF)
                          ),
                        )
                    ),
                  if (displayReminderComment)
                    Positioned(
                      width: 200,
                      top: 555,
                      left: 120,
                      child: TextField(
                          controller: reminder_comment_controller,
                          autofocus: false,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Add a comment...",
                              hintStyle: TextStyle(
                                color: Color(0xFFC9C9C9),
                                fontFamily: "Lexend"
                              )
                          ),
                          style: const TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontFamily: "Lexend",
                              fontSize: 14
                          ),
                          maxLines: 3,
                        ),
                      ),
                  if (displayReminderTime)
                    Positioned(
                      top: 363,
                      left: 127,
                      child: Container(
                        width: 170,
                        height: 40,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(const Color(0x78FFFFFF)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)
                                  )
                              )
                          ),
                          child: Text(
                            haschoosen_TimeReminder ? "$hoursReminder:$minutesReminder" : "Time",
                            style: const TextStyle(
                                color: Color(0xFF313546),
                                fontFamily: "Lexend",
                                fontSize: 32
                            ),),
                          onPressed: () async {
                            final time = await pickTime();
                            if (time == null) return;
                            haschoosen_TimeReminder = true;
                            final newDateTime = DateTime(
                                dateTimeReminder.year,
                                dateTimeReminder.month,
                                dateTimeReminder.day,
                                time.hour,
                                time.minute
                            );
                            setState(() {
                              // TODO: FILL REMINDER OBJECT HERE
                              dateTimeReminder = newDateTime;
                              currentReminderLog.dateTime = newDateTime;
                            });
                          },
                        ),
                      ),
                    ),
                  if (inReminderLog)
                  Positioned(
                    top: 649,
                    left: 160,
                    child: GestureDetector(
                      onTap: (){
                        save_reminder?.fire();
                        print("User saved reminder log!");
                        String? reminderComment = reminder_comment_controller.text;
                        currentReminderLog.comment = reminderComment;

                        // --------------------------------------------

                        // --------------------------------------------

                        setState(() {
                          inInsulinLog = false;
                          displayReminderTime = false;
                          displayReminderComment = false;
                          print("The current state is:\ninHome = ${inHome} | inDrawer = ${inDrawer} "
                              "| inGlucoseLog = ${inGlucoseLog} | inMainButton = ${inMainButton}"
                              " | inInsulinLog = ${inInsulinLog}\nState"
                              " variables changing soon due to transition time: inMainButton | inGlucoseLog");
                          print("DAYS = ${currentReminderLog.days}");
                        });
                        print("Parameters passed are:\n"
                            "HOUR : MINUTES = ${currentReminderLog.dateTime.hour} : ${currentReminderLog.dateTime.minute}\n"
                            "DAYS = ${currentReminderLog.days }\n"
                            "MESSAGE = ${currentReminderLog.comment}");
                        MyAlarmManager.createPeriodicAlarm(currentReminderLog.dateTime.hour,
                            currentReminderLog.dateTime.minute,currentReminderLog.days, title: currentReminderLog.comment);
                        currentReminderLog = ReminderLog([], DateTime.now(), false, "");
                        haschoosen_TimeReminder = false;
                        Future.delayed(const Duration(seconds: 1),(){
                          setState(() {
                            reminder_comment_controller.clear();
                            inReminderLog = false;
                            inMainButton = true;
                            print("The current state is:\ninHome = ${inHome} | inDrawer = ${inDrawer} "
                                "| inGlucoseLog = ${inGlucoseLog} | inMainButton = ${inMainButton}"
                                " | inInsulinLog = ${inInsulinLog} | inReminderLog = ${inReminderLog}");
                          });
                        });
                      },
                      child: Container(
                        width: 102,
                        height: 35,
                        color: const Color(0xFF),
                      ),
                    ),
                  ),
                  if (inPhysical)
                    Positioned(
                        top: 195,
                        left: 292,
                        child: GestureDetector(
                          onTap: (){
                            close_physical?.fire();
                            inPhysical = false;
                            inHome = true;
                          },
                          child: ClipOval(
                            child: Container(
                                width: 40,
                                height: 40,
                                color: const Color(0xFF)
                            ),
                          ),
                        )
                    ),
                  if (inPhysical)
                    Positioned(
                      top: 265,
                      left: 155,
                      child: GestureDetector(
                        onTap:(){
                          to_page1?.fire();
                        },
                        child: Container(
                          width: 60,
                          height: 20,
                          color: const Color(0xFF),
                        ),
                      )
                    ),
                  if (inPhysical)
                    Positioned(
                        top: 265,
                        left: 215,
                        child: GestureDetector(
                          onTap:(){
                            to_page2?.fire();
                          },
                          child: Container(
                            width: 60,
                            height: 20,
                            color: const Color(0xFFFFFF),
                          ),
                        )
                    ),
                  if (inFood)
                    Positioned(
                        top: 195,
                        left: 292,
                        child: GestureDetector(
                          onTap: (){
                            close_food?.fire();
                            inFood = false;
                            inHome = true;
                            setState(() {

                            });
                          },
                          child: ClipOval(
                            child: Container(
                                width: 40,
                                height: 40,
                                color: const Color(0xFF)
                            ),
                          ),
                        )
                    ),
                ]
              ),]
            ),
          ),
        ),
      ),
    );
  }
}

