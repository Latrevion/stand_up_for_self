// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
//
// void main() {
//   tz.initializeTimeZones(); // 初始化 timezone
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: '久坐提醒助手',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const HomeScreen(),
//     );
//   }
// }
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   HomeScreenState createState() => HomeScreenState();
// }
//
// class HomeScreenState extends State<HomeScreen> {
//   late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
//   int reminderInterval = 60; // 默认60分钟
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeNotifications();
//     _loadSettings();
//     _requestPermissions();
//   }
//
//   void _initializeNotifications() {
//     flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//     var initializationSettingsAndroid =
//         const AndroidInitializationSettings('@mipmap/ic_launcher');
//     var initializationSettings =
//         InitializationSettings(android: initializationSettingsAndroid);
//
//     flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onDidReceiveNotificationResponse: (NotificationResponse response) {
//       // Handle notification tapped logic here
//     });
//   }
//
//   _loadSettings() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       reminderInterval = prefs.getInt('reminderInterval') ?? 60;
//     });
//   }
//
//   void _requestPermissions() async {
//     var status = await Permission.scheduleExactAlarm.status;
//     if (!status.isGranted) {
//       await Permission.scheduleExactAlarm.request();
//     }
//     print('Permission status: $status');
//   }
//
//   _setReminder() async {
//     var status = await Permission.scheduleExactAlarm.status;
//     if (!status.isGranted) {
//       await Permission.scheduleExactAlarm.request();
//       if (!await Permission.scheduleExactAlarm.isGranted) {
//         // 权限仍然没有授予
//         print('Permission not granted');
//         return;
//       }
//     }
//
//     var scheduledNotificationDateTime =
//         tz.TZDateTime.now(tz.local).add(Duration(minutes: reminderInterval));
//     print('Scheduled time: $scheduledNotificationDateTime');
//
//     var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
//       'reminder_channel',
//       'Reminder Channel',
//       channelDescription: 'Channel for sit reminder notifications',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//     var platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);
//
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       0,
//       '久坐提醒',
//       '该站起来活动一下啦！',
//       scheduledNotificationDateTime,
//       platformChannelSpecifics,
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//     );
//     print('Notification scheduled');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Center(child: Text('久坐提醒助手')),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text('设置提醒间隔时间（分钟）:'),
//             DropdownButton<int>(
//               value: reminderInterval,
//               items: <int>[1, 5, 30, 60, 90, 120].map((int value) {
//                 return DropdownMenuItem<int>(
//                   value: value,
//                   child: Text(value.toString()),
//                 );
//               }).toList(),
//               onChanged: (value) async {
//                 SharedPreferences prefs = await SharedPreferences.getInstance();
//                 prefs.setInt('reminderInterval', value!);
//                 setState(() {
//                   reminderInterval = value;
//                 });
//               },
//             ),
//             ElevatedButton(
//               onPressed: _setReminder,
//               child: const Text('开始提醒'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
// import 'dart:async';
//
// void main() {
//   tz.initializeTimeZones(); // 初始化 timezone
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: '久坐提醒助手',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const HomeScreen(),
//     );
//   }
// }
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   HomeScreenState createState() => HomeScreenState();
// }
//
// class HomeScreenState extends State<HomeScreen> {
//   late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
//   int reminderInterval = 60; // 默认60分钟
//   late DateTime nextReminderTime;
//   late Timer _timer;
//   String timeLeft = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeNotifications();
//     _loadSettings();
//     _requestPermissions();
//     _startTimer();
//   }
//
//   void _initializeNotifications() {
//     flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//     var initializationSettingsAndroid =
//         const AndroidInitializationSettings('@mipmap/ic_launcher');
//     var initializationSettings =
//         InitializationSettings(android: initializationSettingsAndroid);
//
//     flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onDidReceiveNotificationResponse: (NotificationResponse response) {
//       // Handle notification tapped logic here
//     });
//   }
//
//   _loadSettings() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       reminderInterval = prefs.getInt('reminderInterval') ?? 60;
//     });
//   }
//
//   void _requestPermissions() async {
//     var status = await Permission.scheduleExactAlarm.status;
//     if (!status.isGranted) {
//       await Permission.scheduleExactAlarm.request();
//     }
//     print('Permission status: $status');
//   }
//
//   _setReminder() async {
//     var status = await Permission.scheduleExactAlarm.status;
//     if (!status.isGranted) {
//       await Permission.scheduleExactAlarm.request();
//       if (!await Permission.scheduleExactAlarm.isGranted) {
//         // 权限仍然没有授予
//         print('Permission not granted');
//         return;
//       }
//     }
//
//     var scheduledNotificationDateTime =
//         tz.TZDateTime.now(tz.local).add(Duration(minutes: reminderInterval));
//     nextReminderTime = scheduledNotificationDateTime;
//     print('Scheduled time: $scheduledNotificationDateTime');
//
//     var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
//       'reminder_channel',
//       'Reminder Channel',
//       channelDescription: 'Channel for sit reminder notifications',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//     var platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);
//
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       0,
//       '久坐提醒',
//       '该站起来活动一下啦！',
//       scheduledNotificationDateTime,
//       platformChannelSpecifics,
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//     );
//     print('Notification scheduled');
//     setState(() {
//       _updateTimeLeft();
//     });
//   }
//
//   void _startTimer() {
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       setState(() {
//         _updateTimeLeft();
//       });
//     });
//   }
//
//   void _updateTimeLeft() {
//     final now = DateTime.now();
//     if (nextReminderTime.isAfter(now)) {
//       final difference = nextReminderTime.difference(now);
//       timeLeft = '${difference.inMinutes}分钟 ${difference.inSeconds % 60}秒';
//     } else {
//       timeLeft = '提醒时间到了!';
//     }
//   }
//
//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Center(child: Text('久坐提醒助手')),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text('设置提醒间隔时间（分钟）:'),
//             DropdownButton<int>(
//               value: reminderInterval,
//               items: <int>[1, 5, 30, 60, 90, 120].map((int value) {
//                 return DropdownMenuItem<int>(
//                   value: value,
//                   child: Text(value.toString()),
//                 );
//               }).toList(),
//               onChanged: (value) async {
//                 SharedPreferences prefs = await SharedPreferences.getInstance();
//                 prefs.setInt('reminderInterval', value!);
//                 setState(() {
//                   reminderInterval = value;
//                 });
//               },
//             ),
//             ElevatedButton(
//               onPressed: _setReminder,
//               child: const Text('开始提醒'),
//             ),
//             const SizedBox(height: 20),
//             Text('距离提醒还有: $timeLeft'),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:async';

void main() {
  tz.initializeTimeZones(); // 初始化 timezone
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '久坐提醒助手',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  int reminderInterval = 60; // 默认60分钟
  DateTime nextReminderTime = DateTime.now(); // 初始化为当前时间
  late Timer _timer;
  String timeLeft = '';

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _loadSettings();
    _requestPermissions();
    _startTimer();
  }

  void _initializeNotifications() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
      // Handle notification tapped logic here
    });
  }

  _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      reminderInterval = prefs.getInt('reminderInterval') ?? 60;
      String? nextReminderTimeString = prefs.getString('nextReminderTime');
      if (nextReminderTimeString != null) {
        nextReminderTime = DateTime.parse(nextReminderTimeString);
      }
    });
  }

  void _requestPermissions() async {
    var status = await Permission.scheduleExactAlarm.status;
    if (!status.isGranted) {
      await Permission.scheduleExactAlarm.request();
    }
    print('Permission status: $status');
  }

  _setReminder() async {
    var status = await Permission.scheduleExactAlarm.status;
    if (!status.isGranted) {
      await Permission.scheduleExactAlarm.request();
      if (!await Permission.scheduleExactAlarm.isGranted) {
        // 权限仍然没有授予
        print('Permission not granted');
        return;
      }
    }

    var scheduledNotificationDateTime =
        tz.TZDateTime.now(tz.local).add(Duration(minutes: reminderInterval));
    nextReminderTime = scheduledNotificationDateTime;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('nextReminderTime', nextReminderTime.toIso8601String());
    print('Scheduled time: $scheduledNotificationDateTime');

    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'reminder_channel',
      'Reminder Channel',
      channelDescription: 'Channel for sit reminder notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      '久坐提醒',
      '该站起来活动一下啦！',
      scheduledNotificationDateTime,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
    print('Notification scheduled');
    setState(() {
      _updateTimeLeft();
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _updateTimeLeft();
      });
    });
  }

  void _updateTimeLeft() {
    final now = DateTime.now();
    if (nextReminderTime.isAfter(now)) {
      final difference = nextReminderTime.difference(now);
      timeLeft = '${difference.inMinutes}分钟 ${difference.inSeconds % 60}秒';
    } else {
      timeLeft = '提醒时间到了!';
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('久坐提醒助手')),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('设置提醒间隔时间（分钟）:'),
            DropdownButton<int>(
              value: reminderInterval,
              items: <int>[1, 5, 30, 60, 90, 120].map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),
              onChanged: (value) async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setInt('reminderInterval', value!);
                setState(() {
                  reminderInterval = value;
                });
              },
            ),
            ElevatedButton(
              onPressed: _setReminder,
              child: const Text('开始提醒'),
            ),
            const SizedBox(height: 20),
            Text('距离提醒还有: $timeLeft'),
          ],
        ),
      ),
    );
  }
}
