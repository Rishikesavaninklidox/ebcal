// import 'dart:async';
// import 'dart:math';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
//
//
// class RandomPauseApp extends StatefulWidget {
//   @override
//   _RandomPauseAppState createState() => _RandomPauseAppState();
// }
//
// class _RandomPauseAppState extends State<RandomPauseApp> {
//   final FlutterLocalNotificationsPlugin notificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   @override
//   void initState() {
//     super.initState();
//     _initNotifications();
//     _scheduleRandomPause();
//   }
//
//   Future<void> _initNotifications() async {
//     const AndroidInitializationSettings androidInit =
//     AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     const InitializationSettings initSettings =
//     InitializationSettings(android: androidInit);
//
//     await notificationsPlugin.initialize(
//       initSettings,
//       onDidReceiveNotificationResponse: (response) {
//         _triggerPauseOverlay(context);
//       },
//     );
//   }
//
//   void _triggerPauseOverlay(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: false, // user cannot dismiss
//       builder: (context) => PauseOverlay(),
//     );
//   }
//
//   Future<void> _scheduleRandomPause() async {
//     final Random random = Random();
//     int randomHour = random.nextInt(24);
//     int randomMinute = random.nextInt(60);
//
//     final now = tz.TZDateTime.now(tz.local);
//     final scheduledTime = tz.TZDateTime(
//       tz.local,
//       now.year,
//       now.month,
//       now.day,
//       randomHour,
//       randomMinute,
//     );
//
//     await notificationsPlugin.zonedSchedule(
//       0,
//       "Mindfulness Pause",
//       "Time to take a 10-second break 🌿",
//       scheduledTime,
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           "pause_channel",
//           "Pause Notifications",
//           channelDescription: "Channel for pause reminders",
//           importance: Importance.max,
//           priority: Priority.high,
//         ),
//       ),
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//       matchDateTimeComponents: DateTimeComponents.time, // daily
//       // uiLocalNotificationDateInterpretation: null, // **remove deprecated**
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Random Pause',
//       home: Scaffold(
//         appBar: AppBar(title: const Text("Random Pause Utility")),
//         body: Center(
//           child: ElevatedButton(
//             onPressed: () => _triggerPauseOverlay(context),
//             child: const Text("Trigger Pause Now"),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class PauseOverlay extends StatefulWidget {
//   @override
//   _PauseOverlayState createState() => _PauseOverlayState();
// }
//
// class _PauseOverlayState extends State<PauseOverlay> {
//   int secondsLeft = 10;
//   Timer? timer;
//
//   @override
//   void initState() {
//     super.initState();
//     timer = Timer.periodic(const Duration(seconds: 1), (t) {
//       if (secondsLeft > 1) {
//         setState(() => secondsLeft--);
//       } else {
//         t.cancel();
//         Navigator.of(context).pop(); // close overlay
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     timer?.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Center(
//         child: Text(
//           "Pause\n$secondsLeft",
//           textAlign: TextAlign.center,
//           style: const TextStyle(color: Colors.white, fontSize: 40),
//         ),
//       ),
//     );
//   }
// }
