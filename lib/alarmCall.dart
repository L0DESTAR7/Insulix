import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/services.dart';

class MyAlarmManager {

  static void createPeriodicAlarm(int hour, int minutes, List<int> days,
      {String title = "", bool skipUI = true}) async {

    try {
      if (Platform.isAndroid) {
        final AndroidIntent intent = AndroidIntent(
          action: "android.intent.action.SET_ALARM",
          arguments: <String, dynamic>{
            "android.intent.extra.alarm.HOUR": hour,
            "android.intent.extra.alarm.MINUTES": minutes,
            "android.intent.extra.alarm.DAYS": days as List<int>,
            "android.intent.extra.alarm.MESSAGE": title,
            "android.intent.extra.alarm.SKIP_UI": skipUI,
          }
        );
        print(await intent.canResolveActivity());
        await intent.launch();
      } else {
        print("not android!");
      }
    } on PlatformException {

    }
  }
}