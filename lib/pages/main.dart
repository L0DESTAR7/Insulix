import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:hive/hive.dart';
import 'package:insulix/models/glucose_log.dart';
import 'package:insulix/models/insulin_log.dart';
import "package:rive/rive.dart";
import "dart:async";
import "package:flutter/services.dart";
import 'get_started.dart' as get_started;
import 'home.dart' as home;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:insulix/firebase_options.dart';

bool signedIn = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter("./Data");
  Hive.registerAdapter(GlucoseLogAdapter());
  Hive.registerAdapter(InsulinLogAdapter());
  await Hive.openBox<GlucoseLog>("GlucoseLogs");
  await Hive.openBox<InsulinLog>("InsulinLogs");
  var _user = FirebaseAuth.instance;
  if (_user.currentUser != null){
    signedIn = true;
    print("user signed in!");
  }
  else{
    signedIn = false;
  }
  runApp(const Mainscreen());
}

class Mainscreen extends StatefulWidget {
  const Mainscreen({Key? key}) : super(key: key);
  static const String id = "loading_screen";

  @override
  _MainscreenState createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Home(),
      debugShowCheckedModeBanner: false,
      routes: {
        Mainscreen.id : (context) => const Home(),
        get_started.Get_Started.id : (context) => const get_started.Get_Started(),
        home.HomeScreen.id : (context) => const home.HomeScreen()
      }
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  Artboard? _riveArtboard;
  RiveAnimationController? _rivecontroller;
  SMIInput<double>? load_prog;
  SMITrigger? go_next;
  AnimationController? _controller;
  bool transition = false;
  bool pushed = false;
  @override
  void _onRiveInit(Artboard artboard) {
    final controller =
        StateMachineController.fromArtboard(artboard, 'Loading screen machine');

    if (controller != null){
      artboard.addController(controller);
      load_prog = controller.findInput('load_prog');
      go_next = controller.findInput<bool>('go_next') as SMITrigger;
      setState(() {
        load_prog!.change(_controller!.value);
        _riveArtboard = artboard;
        print("Initialized!");
      });
    }
  }

  @override
  void initState() {
    super.initState();
    rootBundle.load('./assets/Rive/loading_screen.riv').then((data) async {
      final file = RiveFile.import(data);
      final artboard = file.mainArtboard;

      setState(() => _riveArtboard = artboard);
    });



    _controller = AnimationController(vsync: this,
      value: 0,
      lowerBound: 0,
      upperBound: 110,
      duration: const Duration(seconds: 5),
    );
    _controller!.forward();

  }


  @override
  Widget build(BuildContext context) {

    Timer.periodic(const Duration(milliseconds: 1), (Timer t) {
      load_prog!.change(_controller!.value);
      if (_controller!.isCompleted){
        t.cancel();
        Future.delayed(const Duration(seconds: 5),(){
          go_next?.fire();
          transition = true;
        });
      }
    });

    Timer.periodic(const Duration(seconds: 6), (Timer t) {
      if (transition){
        t.cancel();
        Future.delayed(const Duration(milliseconds: 1500),(){
          // The <if not pushed> condition was added because for some reason, flutter pushes 3 times on the stack?? Perhaps it checks too fast...
          if (!pushed) {
            print("I pushed on the page stack");
            signedIn ? Navigator.pushNamed(context, home.HomeScreen.id) : Navigator.pushNamed(context, get_started.Get_Started.id);
            pushed = true;
          }
        });
      }
    });

    double width = MediaQuery.of(context).size.width;


    double height = MediaQuery.of(context).size.height;

    return Stack(children: [
        Positioned(
          child: RiveAnimation.asset(
            "./assets/Rive/loading_screen.riv",
            fit: BoxFit.cover,
            onInit: _onRiveInit,
            stateMachines: ["Loading screen machine"],
          ),
          width: width,
          height: height,
        ),
      ]);
  }
}
