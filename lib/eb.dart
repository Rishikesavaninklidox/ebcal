
//good to go
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ElecBillUI extends StatefulWidget {
  @override
  _ElecBillUIState createState() => _ElecBillUIState();
}

class _ElecBillUIState extends State<ElecBillUI> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _oldController = TextEditingController();
  final TextEditingController _newController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();

  String _result = "";

  // Store saved users with their latest readings
  final Map<String, Map<String, dynamic>> _savedUsers = {};

  void calculateBill() {
    String name = _nameController.text.trim();
    int? oldValue = int.tryParse(_oldController.text);
    int? newValue = int.tryParse(_newController.text);
    double? customRate = double.tryParse(_rateController.text);

    if (name.isEmpty || oldValue == null || newValue == null || newValue < oldValue || customRate == null) {
      setState(() {
        _result = "⚠️ Please enter valid details (present is lower then  old, rate valid)!";
      });
      return;
    }

    int units = newValue - oldValue;
    double amount = units * customRate;

    setState(() {
      _result = "Electricity Bill for $name\n"
          "Old Reading    : $oldValue\n"
          "Present Reading: $newValue\n"
          "Units Consumed : $units\n"
          "Rate per Unit  : ₹$customRate\n"
          "Total Amount   : ₹$amount";
    });
  }

  void saveUser() {
    String name = _nameController.text.trim();
    int? oldValue = int.tryParse(_oldController.text);
    int? newValue = int.tryParse(_newController.text);
    double? customRate = double.tryParse(_rateController.text);

    if (name.isEmpty || oldValue == null || newValue == null || customRate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ Please enter all fields before saving!")),
      );
      return;
    }

    _savedUsers[name] = {
      "old": oldValue,
      "new": newValue,
      "rate": customRate,
    };

    setState(() {}); // refresh list view

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("✅ Data saved for $name")),
    );
  }

  void loadUser(String name) {
    if (_savedUsers.containsKey(name)) {
      var user = _savedUsers[name]!;
      _nameController.text = name;
      _oldController.text = user["old"].toString();
      _newController.text = user["new"].toString();
      _rateController.text = user["rate"].toString();

      calculateBill(); // auto calculate after loading
    }
  }

  void deleteUser(String name) {
    if (_savedUsers.containsKey(name)) {
      _savedUsers.remove(name);
      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("🗑️ Deleted data for $name")),
      );

      if (_nameController.text.trim() == name) {
        _nameController.clear();
        _oldController.clear();
        _newController.clear();
        _rateController.clear();
        setState(() {
          _result = "";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Electricity Bill Calculator")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Enter your name"),
              ),
              TextField(
                controller: _oldController,
                decoration: InputDecoration(labelText: "Enter old reading"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _newController,
                decoration: InputDecoration(labelText: "Enter present reading"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _rateController,
                decoration: InputDecoration(labelText: "Enter rate per unit (₹)"),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: calculateBill,
                      child: Text("Calculate Bill"),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: saveUser,
                      child: Text("Save User"),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                "Saved Users:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _savedUsers.length,
                itemBuilder: (context, index) {
                  String name = _savedUsers.keys.elementAt(index);
                  var user = _savedUsers[name]!;

                  return Card(
                    child: ListTile(
                      title: Text(name),
                      subtitle: Text(
                          "Old: ${user['old']}, New: ${user['new']}, Rate: ₹${user['rate']}"),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deleteUser(name),
                      ),
                      onTap: () => loadUser(name), // tap to load data
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              Text(
                _result,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}





// import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
// import 'package:flutter/material.dart';
// import 'package:dart_openai/dart_openai.dart';
//
// class ElecBillUI extends StatefulWidget {
//   @override
//   _ElecBillUIState createState() => _ElecBillUIState();
// }
//
// class _ElecBillUIState extends State<ElecBillUI> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _oldController = TextEditingController();
//   final TextEditingController _newController = TextEditingController();
//   final TextEditingController _rateController = TextEditingController();
//   final TextEditingController _splitController = TextEditingController();
//
//   String _result = "";
//   String _aiTip = "";
//
//   // Store saved users
//   final Map<String, Map<String, dynamic>> _savedUsers = {};
//
//   // Initialize OpenAI client
//   final OpenAI openAI = OpenAI.instance.build(
//     token: 'YOUR_OPENAI_API_KEY',
//     enableLog: true,
//   );
//
//   void calculateBill() {
//     String name = _nameController.text.trim();
//     int? oldValue = int.tryParse(_oldController.text);
//     int? newValue = int.tryParse(_newController.text);
//     double? customRate = double.tryParse(_rateController.text);
//
//     if (name.isEmpty || oldValue == null || newValue == null || newValue < oldValue || customRate == null) {
//       setState(() {
//         _result = "⚠️ Please enter valid details (present lower than old, rate valid)!";
//       });
//       return;
//     }
//
//     int units = newValue - oldValue;
//     double amount = units * customRate;
//
//     int? numPeople = int.tryParse(_splitController.text);
//     double splitAmount = 0.0;
//     int splitUnits = 0;
//
//     if (numPeople != null && numPeople > 0) {
//       splitUnits = (units / numPeople).ceil();
//       splitAmount = amount / numPeople;
//     }
//
//     setState(() {
//       _result = "Electricity Bill for $name\n"
//           "Old Reading    : $oldValue\n"
//           "Present Reading: $newValue\n"
//           "Units Consumed : $units\n"
//           "Rate per Unit  : ₹$customRate\n"
//           "Total Amount   : ₹$amount";
//
//       if (numPeople != null && numPeople > 0) {
//         _result += "\nSplit Among $numPeople people:";
//         for (int i = 1; i <= numPeople; i++) {
//           _result += "\nPerson $i - Old: $oldValue, Present: $newValue, "
//               "Units: $splitUnits, Amount: ₹${splitAmount.toStringAsFixed(2)}";
//         }
//       }
//     });
//
//     // Optional: fetch AI tip
//     _getEnergyTip(name, units);
//   }
//
//   void saveUser() {
//     String name = _nameController.text.trim();
//     int? oldValue = int.tryParse(_oldController.text);
//     int? newValue = int.tryParse(_newController.text);
//     double? customRate = double.tryParse(_rateController.text);
//
//     if (name.isEmpty || oldValue == null || newValue == null || customRate == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("⚠️ Please enter all fields before saving!")),
//       );
//       return;
//     }
//
//     _savedUsers[name] = {
//       "old": oldValue,
//       "new": newValue,
//       "rate": customRate,
//     };
//
//     setState(() {}); // refresh list view
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("✅ Data saved for $name")),
//     );
//   }
//
//   void loadUser(String name) {
//     if (_savedUsers.containsKey(name)) {
//       var user = _savedUsers[name]!;
//       _nameController.text = name;
//       _oldController.text = user["old"].toString();
//       _newController.text = user["new"].toString();
//       _rateController.text = user["rate"].toString();
//
//       calculateBill(); // auto calculate after loading
//     }
//   }
//
//   void deleteUser(String name) {
//     if (_savedUsers.containsKey(name)) {
//       _savedUsers.remove(name);
//       setState(() {});
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("🗑️ Deleted data for $name")),
//       );
//
//       if (_nameController.text.trim() == name) {
//         _nameController.clear();
//         _oldController.clear();
//         _newController.clear();
//         _rateController.clear();
//         _splitController.clear();
//         setState(() {
//           _result = "";
//           _aiTip = "";
//         });
//       }
//     }
//   }
//
//   Future<void> _getEnergyTip(String name, int units) async {
//     setState(() {
//       _aiTip = "Fetching tip...";
//     });
//
//     try {
//       final request = ChatCompleteText(
//         model: ChatModel.gptTurbo,
//         messages: [
//           ChatMessage(
//             role: Role.user,
//             content:
//             "User $name consumed $units units of electricity. Give a short tip to save electricity at home in 2-3 sentences.",
//           ),
//         ],
//         maxTokens: 60,
//         temperature: 0.7,
//       );
//
//       final response = await openAI.chat.completions.create(request);
//
//       if (response.choices.isNotEmpty) {
//         setState(() {
//           _aiTip = response.choices.first.message.content.trim();
//         });
//       } else {
//         setState(() {
//           _aiTip = "No tip available at the moment.";
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _aiTip = "Failed to fetch tip. Please check your internet connection.";
//       });
//       print("Error fetching tip: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Electricity Bill Calculator")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextField(controller: _nameController, decoration: InputDecoration(labelText: "Enter your name")),
//               TextField(controller: _oldController, decoration: InputDecoration(labelText: "Enter old reading"), keyboardType: TextInputType.number),
//               TextField(controller: _newController, decoration: InputDecoration(labelText: "Enter present reading"), keyboardType: TextInputType.number),
//               TextField(controller: _rateController, decoration: InputDecoration(labelText: "Enter rate per unit (₹)"), keyboardType: TextInputType.number),
//               TextField(controller: _splitController, decoration: InputDecoration(labelText: "Split among how many people?"), keyboardType: TextInputType.number),
//               SizedBox(height: 20),
//               Row(
//                 children: [
//                   Expanded(child: ElevatedButton(onPressed: calculateBill, child: Text("Calculate Bill"))),
//                   SizedBox(width: 10),
//                   Expanded(child: ElevatedButton(onPressed: saveUser, child: Text("Save User"))),
//                 ],
//               ),
//               SizedBox(height: 20),
//               Text("Saved Users:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: _savedUsers.length,
//                 itemBuilder: (context, index) {
//                   String name = _savedUsers.keys.elementAt(index);
//                   var user = _savedUsers[name]!;
//
//                   return Card(
//                     child: ListTile(
//                       title: Text(name),
//                       subtitle: Text("Old: ${user['old']}, New: ${user['new']}, Rate: ₹${user['rate']}"),
//                       trailing: IconButton(icon: Icon(Icons.delete, color: Colors.red), onPressed: () => deleteUser(name)),
//                       onTap: () => loadUser(name),
//                     ),
//                   );
//                 },
//               ),
//               SizedBox(height: 20),
//               Text(_result, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               SizedBox(height: 10),
//               Text(_aiTip, style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.green)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// /// api open
///
// import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
// import 'package:flutter/material.dart';
//
//
// import 'package:flutter/material.dart';
// import 'package:dart_openai/dart_openai.dart' hide OpenAI;
//
// class ElecBillUI extends StatefulWidget {
//   @override
//   _ElecBillUIState createState() => _ElecBillUIState();
// }
//
// class _ElecBillUIState extends State<ElecBillUI> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _oldController = TextEditingController();
//   final TextEditingController _newController = TextEditingController();
//   final TextEditingController _rateController = TextEditingController();
//
//   String _result = "";
//   String _aiTip = "";
//
//   // Store saved users
//   final Map<String, Map<String, dynamic>> _savedUsers = {};
//
//   @override
//   void initState() {
//     super.initState();
//     OpenAI.apiKey = 'YOUR_OPENAI_API_KEY'; // Initialize OpenAI API
//   }
//
//   // Calculate electricity bill
//   void calculateBill() {
//     String name = _nameController.text.trim();
//     int? oldValue = int.tryParse(_oldController.text);
//     int? newValue = int.tryParse(_newController.text);
//     double? rate = double.tryParse(_rateController.text);
//
//     if (name.isEmpty || oldValue == null || newValue == null || newValue < oldValue || rate == null) {
//       setState(() {
//         _result = "⚠️ Please enter valid details!";
//         _aiTip = "";
//       });
//       return;
//     }
//
//     int units = newValue - oldValue;
//     double amount = units * rate;
//
//     setState(() {
//       _result =
//       "Electricity Bill for $name\nOld Reading: $oldValue\nNew Reading: $newValue\nUnits Consumed: $units\nRate per Unit: ₹$rate\nTotal Amount: ₹$amount";
//     });
//
//     // Fetch AI tip
//     _getEnergyTip(name, oldValue, newValue, units);
//   }
//
//   // Save user
//   void saveUser() {
//     String name = _nameController.text.trim();
//     int? oldValue = int.tryParse(_oldController.text);
//     int? newValue = int.tryParse(_newController.text);
//     double? rate = double.tryParse(_rateController.text);
//
//     if (name.isEmpty || oldValue == null || newValue == null || rate == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("⚠️ Please enter all fields before saving!")),
//       );
//       return;
//     }
//
//     _savedUsers[name] = {
//       "old": oldValue,
//       "new": newValue,
//       "rate": rate,
//     };
//
//     setState(() {});
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("✅ Data saved for $name")),
//     );
//   }
//
//   // Load user
//   void loadUser(String name) {
//     if (_savedUsers.containsKey(name)) {
//       var user = _savedUsers[name]!;
//       _nameController.text = name;
//       _oldController.text = user["old"].toString();
//       _newController.text = user["new"].toString();
//       _rateController.text = user["rate"].toString();
//
//       calculateBill(); // auto-calculate after loading
//     }
//   }
//
//   // Delete user
//   void deleteUser(String name) {
//     if (_savedUsers.containsKey(name)) {
//       _savedUsers.remove(name);
//       setState(() {});
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("🗑️ Deleted data for $name")),
//       );
//
//       if (_nameController.text.trim() == name) {
//         _nameController.clear();
//         _oldController.clear();
//         _newController.clear();
//         _rateController.clear();
//         setState(() {
//           _result = "";
//           _aiTip = "";
//         });
//       }
//     }
//   }
//
//   // Fetch AI energy-saving tip
//   Future<void> _getEnergyTip(String name, int oldValue, int newValue, int units) async {
//     setState(() {
//       _aiTip = "Fetching tip...";
//     });
//
//     try {
//       final prompt =
//           "User $name has old reading $oldValue and new reading $newValue, consuming $units units. "
//           "Give a short tip to save electricity at home in 2-3 sentences.";
//
//       final response = await OpenAI.instance.completions.create(
//         model: "text-davinci-003",
//         prompt: prompt,
//         maxTokens: 60,
//         temperature: 0.7,
//       );
//
//       if (response.choices.isNotEmpty) {
//         setState(() {
//           _aiTip = response.choices.first.text.trim();
//         });
//       } else {
//         setState(() {
//           _aiTip = "No tip available at the moment.";
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _aiTip = "Failed to fetch tip. Please check your internet connection.";
//       });
//       print("Error fetching tip: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Electricity Bill Calculator")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Autocomplete<String>(
//                 optionsBuilder: (TextEditingValue textEditingValue) {
//                   if (textEditingValue.text.isEmpty) return const Iterable<String>.empty();
//                   return _savedUsers.keys.where((name) =>
//                       name.toLowerCase().contains(textEditingValue.text.toLowerCase()));
//                 },
//                 onSelected: (String selection) {
//                   loadUser(selection);
//                 },
//                 fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
//                   _nameController.text = controller.text;
//                   return TextField(
//                     controller: _nameController,
//                     focusNode: focusNode,
//                     decoration: InputDecoration(labelText: "Enter your name"),
//                     onEditingComplete: onEditingComplete,
//                   );
//                 },
//               ),
//               TextField(
//                 controller: _oldController,
//                 decoration: InputDecoration(labelText: "Enter old reading"),
//                 keyboardType: TextInputType.number,
//               ),
//               TextField(
//                 controller: _newController,
//                 decoration: InputDecoration(labelText: "Enter present reading"),
//                 keyboardType: TextInputType.number,
//               ),
//               TextField(
//                 controller: _rateController,
//                 decoration: InputDecoration(labelText: "Enter rate per unit (₹)"),
//                 keyboardType: TextInputType.number,
//               ),
//               SizedBox(height: 20),
//               Row(
//                 children: [
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: calculateBill,
//                       child: Text("Calculate Bill"),
//                     ),
//                   ),
//                   SizedBox(width: 10),
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: saveUser,
//                       child: Text("Save User"),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 20),
//               Text(
//                 "Saved Users:",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: _savedUsers.length,
//                 itemBuilder: (context, index) {
//                   String name = _savedUsers.keys.elementAt(index);
//                   var user = _savedUsers[name]!;
//
//                   return Card(
//                     child: ListTile(
//                       title: Text(name),
//                       subtitle: Text(
//                           "Old: ${user['old']}, New: ${user['new']}, Rate: ₹${user['rate']}"),
//                       trailing: IconButton(
//                         icon: Icon(Icons.delete, color: Colors.red),
//                         onPressed: () => deleteUser(name),
//                       ),
//                       onTap: () => loadUser(name),
//                     ),
//                   );
//                 },
//               ),
//               SizedBox(height: 20),
//               Text(
//                 _result,
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 _aiTip,
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontStyle: FontStyle.italic,
//                   color: Colors.green[700],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }




/// video creation
// class ChatGPTVideoScreen extends StatefulWidget {
//   @override
//   _ChatGPTVideoScreenState createState() => _ChatGPTVideoScreenState();
// }
//
// class _ChatGPTVideoScreenState extends State<ChatGPTVideoScreen> {
//   final TextEditingController _promptController = TextEditingController();
//   String _response = "";
//
//   late OpenAI openAI;
//
//   @override
//   void initState() {
//     super.initState();
//     openAI = OpenAI.instance.build(
//       apiUrl: "YOUR_OPENAI_API_KEY", // Replace with your key
//       enableLog: true,
//     );
//   }
//
//   Future<void> generateVideoScript() async {
//     final prompt = _promptController.text.trim();
//     if (prompt.isEmpty) return;
//
//     setState(() {
//       _response = "Generating script...";
//     });
//
//     final request = CompleteText(prompt: "Write a video script about: $prompt", model: Model.textDavinci3);
//
//     final result = await openAI.onCompletion(request: request);
//
//     setState(() {
//       _response = result?.choices.first.text ?? "No response";
//     });
//   }
//
//   @override
//   void dispose() {
//     // openAI.close();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("ChatGPT Video Generator")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _promptController,
//               decoration: InputDecoration(
//                 labelText: "Enter video topic",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 12),
//             ElevatedButton(
//               onPressed: generateVideoScript,
//               child: Text("Generate Video Script"),
//             ),
//             SizedBox(height: 20),
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Text(_response, style: TextStyle(fontSize: 16)),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


