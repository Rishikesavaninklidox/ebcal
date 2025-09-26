// // import 'dart:convert';
// // import 'package:http/http.dart' as http;
// //
// // class OpenAIService {
// //   final String apiKey = "YOUR_OPENAI_API_KEY";
// //
// //   Future<String> getSuggestion({
// //     required String prompt,
// //   }) async {
// //     final url = Uri.parse("https://api.openai.com/v1/chat/completions");
// //
// //     final headers = {
// //       "Content-Type": "application/json",
// //       "Authorization": "Bearer $apiKey",
// //     };
// //
// //     final body = jsonEncode({
// //       "model": "gpt-4o-mini", // or "gpt-4" if available
// //       "messages": [
// //         {"role": "system", "content": "You are an electricity bill assistant."},
// //         {"role": "user", "content": prompt},
// //       ],
// //       "temperature": 0.7,
// //       "max_tokens": 150,
// //     });
// //
// //     final response = await http.post(url, headers: headers, body: body);
// //
// //     if (response.statusCode == 200) {
// //       final data = jsonDecode(response.body);
// //       return data['choices'][0]['message']['content'].toString();
// //     } else {
// //       return "⚠️ Could not fetch AI suggestion.";
// //     }
// //   }
// // }
//
//
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
//
//
// enum UtilityType { electricity, water, gas, internet }
//
// class Bill {
//   UtilityType type;
//   int oldReading;
//   int newReading;
//   double rate;
//   DateTime date;
//   List<Split> splits;
//
//   Bill({
//     required this.type,
//     required this.oldReading,
//     required this.newReading,
//     required this.rate,
//     required this.date,
//     this.splits = const [],
//   });
// }
//
// class Split {
//   String person;
//   int oldReading;
//   int newReading;
//   double amount;
//
//   Split({required this.person, required this.oldReading, required this.newReading, this.amount = 0});
// }
//
// class MultiUtilityApp extends StatefulWidget {
//   @override
//   _MultiUtilityAppState createState() => _MultiUtilityAppState();
// }
//
// class _MultiUtilityAppState extends State<MultiUtilityApp> {
//   UtilityType selectedUtility = UtilityType.electricity;
//
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _oldController = TextEditingController();
//   final TextEditingController _newController = TextEditingController();
//   final TextEditingController _rateController = TextEditingController();
//   final TextEditingController _splitController = TextEditingController();
//
//   int numPeople = 0;
//   List<TextEditingController> oldSplitControllers = [];
//   List<TextEditingController> newSplitControllers = [];
//
//   String _result = "";
//
//   final Map<UtilityType, List<Bill>> _history = {};
//
//   void setupSplit(int n) {
//     numPeople = n;
//     oldSplitControllers = List.generate(n, (_) => TextEditingController());
//     newSplitControllers = List.generate(n, (_) => TextEditingController());
//   }
//
//   void calculateBill() {
//     int? oldVal = int.tryParse(_oldController.text);
//     int? newVal = int.tryParse(_newController.text);
//     double? rate = double.tryParse(_rateController.text);
//
//     if (oldVal == null || newVal == null || newVal < oldVal || rate == null) {
//       setState(() {
//         _result = "⚠️ Enter valid readings and rate!";
//       });
//       return;
//     }
//
//     int totalUnits = newVal - oldVal;
//     double totalAmount = totalUnits * rate;
//
//     String result = "${describeUtility(selectedUtility)} Bill\n"
//         "Old: $oldVal, New: $newVal, Units: $totalUnits, Rate: ₹$rate, Total: ₹${totalAmount.toStringAsFixed(2)}";
//
//     if (numPeople > 0) {
//       result += "\n\nSplit among $numPeople:";
//       for (int i = 0; i < numPeople; i++) {
//         int? oldSplit = int.tryParse(oldSplitControllers[i].text);
//         int? newSplit = int.tryParse(newSplitControllers[i].text);
//         if (oldSplit != null && newSplit != null && newSplit >= oldSplit) {
//           int units = newSplit - oldSplit;
//           double amt = units * rate;
//           result += "\nPerson ${i + 1} - Old: $oldSplit, New: $newSplit, Units: $units, Amount: ₹${amt.toStringAsFixed(2)}";
//         }
//       }
//     }
//
//     // Save history
//     var bill = Bill(
//       type: selectedUtility,
//       oldReading: oldVal,
//       newReading: newVal,
//       rate: rate,
//       date: DateTime.now(),
//       splits: List.generate(numPeople, (i) {
//         int o = int.tryParse(oldSplitControllers[i].text) ?? oldVal;
//         int n = int.tryParse(newSplitControllers[i].text) ?? newVal;
//         double amt = (n - o) * rate;
//         return Split(person: "Person ${i + 1}", oldReading: o, newReading: n, amount: amt);
//       }),
//     );
//
//     _history[selectedUtility] = [...(_history[selectedUtility] ?? []), bill];
//
//     setState(() {
//       _result = result;
//     });
//   }
//
//   String describeUtility(UtilityType type) {
//     switch (type) {
//       case UtilityType.electricity:
//         return "Electricity";
//       case UtilityType.water:
//         return "Water";
//       case UtilityType.gas:
//         return "Gas";
//       case UtilityType.internet:
//         return "Internet";
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Multi-Utility Tracker")),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16),
//         child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           DropdownButton<UtilityType>(
//             value: selectedUtility,
//             items: UtilityType.values.map((u) {
//               return DropdownMenuItem(
//                   value: u, child: Text(describeUtility(u)));
//             }).toList(),
//             onChanged: (val) {
//               setState(() {
//                 selectedUtility = val!;
//               });
//             },
//           ),
//           SizedBox(height: 10),
//           TextField(controller: _nameController, decoration: InputDecoration(labelText: "User / Household Name")),
//           TextField(controller: _oldController, decoration: InputDecoration(labelText: "Old Reading / Usage"), keyboardType: TextInputType.number),
//           TextField(controller: _newController, decoration: InputDecoration(labelText: "New Reading / Usage"), keyboardType: TextInputType.number),
//           TextField(controller: _rateController, decoration: InputDecoration(labelText: "Rate per unit / plan cost"), keyboardType: TextInputType.number),
//           SizedBox(height: 10),
//           Row(
//             children: [
//               Expanded(
//                 child: TextField(
//                   controller: _splitController,
//                   decoration: InputDecoration(labelText: "Number of people for split"),
//                   keyboardType: TextInputType.number,
//                   onChanged: (val) {
//                     int n = int.tryParse(val) ?? 0;
//                     if (n > 0) setupSplit(n);
//                   },
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 10),
//           ...List.generate(numPeople, (i) {
//             return Column(
//               children: [
//                 Text("Person ${i + 1}"),
//                 TextField(controller: oldSplitControllers[i], decoration: InputDecoration(labelText: "Old Reading")),
//                 TextField(controller: newSplitControllers[i], decoration: InputDecoration(labelText: "New Reading")),
//               ],
//             );
//           }),
//           SizedBox(height: 20),
//           ElevatedButton(onPressed: calculateBill, child: Text("Calculate Bill")),
//           SizedBox(height: 20),
//           Text("History:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//           ...(_history[selectedUtility] ?? []).map((bill) {
//             String dateStr = DateFormat('yyyy-MM-dd').format(bill.date);
//             return Card(
//               child: ListTile(
//                 title: Text("$dateStr - ${describeUtility(bill.type)}"),
//                 subtitle: Text("Old: ${bill.oldReading}, New: ${bill.newReading}, Total: ₹${((bill.newReading - bill.oldReading)*bill.rate).toStringAsFixed(2)}"),
//               ),
//             );
//           }).toList(),
//           SizedBox(height: 20),
//           Text(_result, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//         ]),
//       ),
//     );
//   }
// }

/// this is kotlin code  for call tracking
// package com.example.calltracker
//
// import android.content.Context
// import android.os.Bundle
// import io.flutter.embedding.android.FlutterActivity
// import io.flutter.plugin.common.EventChannel
// import android.telephony.PhoneStateListener
// import android.telephony.TelephonyManager
//
// class MainActivity: FlutterActivity() {
//   private val CHANNEL = "com.example.calltracker/call_events"
//   private var events: EventChannel.EventSink? = null
//
//   override fun configureFlutterEngine(flutterEngine: io.flutter.embedding.engine.FlutterEngine) {
//   super.configureFlutterEngine(flutterEngine)
//
//   EventChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
//       .setStreamHandler(object : EventChannel.StreamHandler {
//   override fun onListen(arguments: Any?, sink: EventChannel.EventSink?) {
//   events = sink
//   startListening()
//   }
//
//   override fun onCancel(arguments: Any?) {
//   events = null
//   }
//   })
//   }
//
//   private fun startListening() {
//   val telephonyManager = getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager
//
//   telephonyManager.listen(object : PhoneStateListener() {
//   override fun onCallStateChanged(state: Int, phoneNumber: String?) {
//   when (state) {
//   TelephonyManager.CALL_STATE_RINGING -> {
//   events?.success("Incoming call from: $phoneNumber")
//   }
//   TelephonyManager.CALL_STATE_OFFHOOK -> {
//   events?.success("Call Answered/Outgoing")
//   }
//   TelephonyManager.CALL_STATE_IDLE -> {
//   events?.success("Call Ended")
//   }
//   }
//   }
//   }, PhoneStateListener.LISTEN_CALL_STATE)
//   }
// }
/// permisions
// <uses-permission android:name="android.permission.READ_PHONE_STATE"/>
// <uses-permission android:name="android.permission.READ_CALL_LOG"/>
// <uses-permission android:name="android.permission.PROCESS_OUTGOING_CALLS"/>
// <uses-permission android:name="android.permission.FOREGROUND_SERVICE"/>
//
// <application ...>
// <service android:name=".CallService" android:enabled="true" android:exported="true"/>
// </application>
