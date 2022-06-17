import 'package:hive/hive.dart';
import 'package:insulix/glucose_log.dart';

import 'insulin_log.dart';

class Boxes {
  static Box<GlucoseLog> getGlucoseLogs (){
    return Hive.box<GlucoseLog>('GlucoseLogs');
  }
  static Box<InsulinLog> getInsulinLogs(){
    return Hive.box<InsulinLog>('InsulinLogs');
  }
}