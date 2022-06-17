import "package:flutter/material.dart";
import 'package:hive/hive.dart';
import 'package:insulix/glucose_data.dart';
import 'package:insulix/glucose_log.dart';
import 'package:insulix/insulin_log.dart';
import "package:rive/rive.dart";
import "dart:async";
import "package:flutter/services.dart";
import 'get_started.dart' as get_started;
import 'form.dart' as form;
import 'home.dart' as home;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter("./Data");
  Hive.registerAdapter(GlucoseLogAdapter());
  Hive.registerAdapter(InsulinLogAdapter());
  await Hive.openBox<GlucoseLog>("GlucoseLogs");
  await Hive.openBox<InsulinLog>("InsulinLogs");
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
      home: Home(),
      debugShowCheckedModeBanner: false,
      routes: {
        Mainscreen.id : (context) => Home(),
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
  Widget item0 = Container(
      height: 75,
      width: 290,
      color: Color(0xFF3E5468),
      child: Center(child: DefaultTextStyle(child: Text("Type 1"),style: TextStyle(color: Color(0xFFFFFFFF),fontSize: 36)))),
      item1 = Container(
          height: 75,
          width: 290,
          color: Color(0xFF3E5468),
          child: Center(child: DefaultTextStyle(child: Text("Type 2"),style: TextStyle(color: Color(0xFFFFFFFF),fontSize: 36)))),
      item2 = Container(
          height: 75,
          width: 290,
          color: Color(0xFF3E5468),
          child: Center(child: DefaultTextStyle(child: Text("Gestational"),style: TextStyle(color: Color(0xFFFFFFFF),fontSize: 36)))),
      item3 = Container(
          height: 75,
          width: 290,
          color: Color(0xFF3E5468),
          child: Center(child: DefaultTextStyle(child: Text("MODY"),style: TextStyle(color: Color(0xFFFFFFFF),fontSize: 36)))),
      item4 = Container(
          height: 75,
          width: 290,
          color: Color(0xFF3E5468),
          child: Center(child: DefaultTextStyle(child: Text("LADA"),style: TextStyle(color: Color(0xFFFFFFFF),fontSize: 36))));
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
      duration: Duration(seconds: 5),
    );
    _controller!.forward();

  }


  @override
  Widget build(BuildContext context) {

    Timer.periodic(Duration(milliseconds: 1), (Timer t) {
      load_prog!.change(_controller!.value);
      if (_controller!.isCompleted){
        t.cancel();
        Future.delayed(Duration(seconds: 5),(){
          go_next?.fire();
          transition = true;
        });
      }
    });

    Timer.periodic(Duration(seconds: 6), (Timer t) {
      if (transition){
        t.cancel();
        Future.delayed(Duration(milliseconds: 1500),(){
          // The <if not pushed> condition was added because for some reason, flutter pushes 3 times on the stack?? Perhaps it checks too fast...
          if (!pushed) {
            print("I pushed on the page stack");
            Navigator.pushNamed(context, get_started.Get_Started.id);
            pushed = true;
          }
        });
      }
    });

    double width = MediaQuery.of(context).size.width;


    List<Widget> ScrollList = [item0,item1,item2,item3,item4];

    double height = MediaQuery.of(context).size.height;
    final bottom = MediaQuery.of(context).viewInsets.bottom;

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
        //Center(
        //  child: ListWheelScrollView.useDelegate(itemExtent: 75,
        //    onSelectedItemChanged: (int i){
        //        if (i==0){
        //          item0 = Container(
        //              height: 75,
        //              width: 290,
        //              color: Color(0xFF3E5468),
        //              child: Center(child: DefaultTextStyle(child: Text("Type 1"),style: TextStyle(color: Color(
        //                  0xFF00C2FF),fontSize: 36))));
        //          item1 = Container(
        //              height: 75,
        //              width: 290,
        //              color: Color(0xFF3E5468),
        //              child: Center(child: DefaultTextStyle(child: Text("Type 2"),style: TextStyle(color: Color(
        //                  0xFFFFFFFF),fontSize: 36))));
        //          item2 = Container(
        //              height: 75,
        //              width: 290,
        //              color: Color(0xFF3E5468),
        //              child: Center(child: DefaultTextStyle(child: Text("Gestational"),style: TextStyle(color: Color(0xFFFFFFFF),fontSize: 36))));
        //          item3 = Container(
        //              height: 75,
        //              width: 290,
        //              color: Color(0xFF3E5468),
        //              child: Center(child: DefaultTextStyle(child: Text("MODY"),style: TextStyle(color: Color(0xFFFFFFFF),fontSize: 36))));
        //          item4 = Container(
        //              height: 75,
        //              width: 290,
        //              color: Color(0xFF3E5468),
        //              child: Center(child: DefaultTextStyle(child: Text("LADA"),style: TextStyle(color: Color(0xFFFFFFFF),fontSize: 36))));
        //        }
        //        else if (i==1){
        //          item0 = Container(
        //              height: 75,
        //              width: 290,
        //              color: Color(0xFF3E5468),
        //              child: Center(child: DefaultTextStyle(child: Text("Type 1"),style: TextStyle(color: Color(
        //                  0xFFFFFFFF),fontSize: 36))));
        //          item1 = Container(
        //              height: 75,
        //              width: 290,
        //              color: Color(0xFF3E5468),
        //              child: Center(child: DefaultTextStyle(child: Text("Type 2"),style: TextStyle(color: Color(
        //                  0xFF00C2FF),fontSize: 36))));
        //          item2 = Container(
        //              height: 75,
        //              width: 290,
        //              color: Color(0xFF3E5468),
        //              child: Center(child: DefaultTextStyle(child: Text("Gestational"),style: TextStyle(color: Color(0xFFFFFFFF),fontSize: 36))));
        //          item3 = Container(
        //              height: 75,
        //              width: 290,
        //              color: Color(0xFF3E5468),
        //              child: Center(child: DefaultTextStyle(child: Text("MODY"),style: TextStyle(color: Color(0xFFFFFFFF),fontSize: 36))));
        //          item4 = Container(
        //              height: 75,
        //              width: 290,
        //              color: Color(0xFF3E5468),
        //              child: Center(child: DefaultTextStyle(child: Text("LADA"),style: TextStyle(color: Color(0xFFFFFFFF),fontSize: 36))));
        //        }
        //        else if(i==2){
        //          item0 = Container(
        //              height: 75,
        //              width: 290,
        //              color: Color(0xFF3E5468),
        //              child: Center(child: DefaultTextStyle(child: Text("Type 1"),style: TextStyle(color: Color(
        //                  0xFFFFFFFF),fontSize: 36))));
        //          item1 = Container(
        //              height: 75,
        //              width: 290,
        //              color: Color(0xFF3E5468),
        //              child: Center(child: DefaultTextStyle(child: Text("Type 2"),style: TextStyle(color: Color(
        //                  0xFFFFFFFF),fontSize: 36))));
        //          item2 = Container(
        //              height: 75,
        //              width: 290,
        //              color: Color(0xFF3E5468),
        //              child: Center(child: DefaultTextStyle(child: Text("Gestational"),style: TextStyle(color: Color(
        //                  0xFF00C2FF),fontSize: 36))));
        //          item3 = Container(
        //              height: 75,
        //              width: 290,
        //              color: Color(0xFF3E5468),
        //              child: Center(child: DefaultTextStyle(child: Text("MODY"),style: TextStyle(color: Color(0xFFFFFFFF),fontSize: 36))));
        //          item4 = Container(
        //              height: 75,
        //              width: 290,
        //              color: Color(0xFF3E5468),
        //              child: Center(child: DefaultTextStyle(child: Text("LADA"),style: TextStyle(color: Color(0xFFFFFFFF),fontSize: 36))));
        //        }
        //        else if (i==3){
        //          item0 = Container(
        //              height: 75,
        //              width: 290,
        //              color: Color(0xFF3E5468),
        //              child: Center(child: DefaultTextStyle(child: Text("Type 1"),style: TextStyle(color: Color(
        //                  0xFFFFFFFF),fontSize: 36))));
        //          item1 = Container(
        //              height: 75,
        //              width: 290,
        //              color: Color(0xFF3E5468),
        //              child: Center(child: DefaultTextStyle(child: Text("Type 2"),style: TextStyle(color: Color(
        //                  0xFFFFFFFF),fontSize: 36))));
        //          item2 = Container(
        //              height: 75,
        //              width: 290,
        //              color: Color(0xFF3E5468),
        //              child: Center(child: DefaultTextStyle(child: Text("Gestational"),style: TextStyle(color: Color(0xFFFFFFFF),fontSize: 36))));
        //          item3 = Container(
        //              height: 75,
        //              width: 290,
        //              color: Color(0xFF3E5468),
        //              child: Center(child: DefaultTextStyle(child: Text("MODY"),style: TextStyle(color: Color(
        //                  0xFF00C2FF),fontSize: 36))));
        //          item4 = Container(
        //              height: 75,
        //              width: 290,
        //              color: Color(0xFF3E5468),
        //              child: Center(child: DefaultTextStyle(child: Text("LADA"),style: TextStyle(color: Color(0xFFFFFFFF),fontSize: 36))));
        //        }
        //        else if(i==4){
        //          item0 = Container(
        //              height: 75,
        //              width: 290,
        //              color: Color(0xFF3E5468),
        //              child: Center(child: DefaultTextStyle(child: Text("Type 1"),style: TextStyle(color: Color(
        //                  0xFFFFFFFF),fontSize: 36))));
        //          item1 = Container(
        //              height: 75,
        //              width: 290,
        //              color: Color(0xFF3E5468),
        //              child: Center(child: DefaultTextStyle(child: Text("Type 2"),style: TextStyle(color: Color(
        //                  0xFFFFFFFF),fontSize: 36))));
        //          item2 = Container(
        //              height: 75,
        //              width: 290,
        //              color: Color(0xFF3E5468),
        //              child: Center(child: DefaultTextStyle(child: Text("Gestational"),style: TextStyle(color: Color(0xFFFFFFFF),fontSize: 36))));
        //          item3 = Container(
        //              height: 75,
        //              width: 290,
        //              color: Color(0xFF3E5468),
        //              child: Center(child: DefaultTextStyle(child: Text("MODY"),style: TextStyle(color: Color(0xFFFFFFFF),fontSize: 36))));
        //          item4 = Container(
        //              height: 75,
        //              width: 290,
        //              color: Color(0xFF3E5468),
        //              child: Center(child: DefaultTextStyle(child: Text("LADA"),style: TextStyle(color: Color(
        //                  0xFF00C2FF),fontSize: 36))));
        //        }
        //        setState(() {
        //        });
        //    },
        //    diameterRatio: 1,
        //    magnification: 1,
        //    useMagnifier: true,
        //    overAndUnderCenterOpacity: 0.6,
        //    perspective: 0.001,
        //    childDelegate: ListWheelChildLoopingListDelegate(
        //      children: ScrollList,
        //    ),
        //  ),
        //),
      ]);
  }
}
