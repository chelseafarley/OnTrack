import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'On Track',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'On Track'),
    );
  }
}

class TrackerItem extends StatefulWidget {
  TrackerItem({Key? key, required this.name, required this.value, this.counter = 0}) : super(key: key);

  final String name;
  final int value;
  int counter;

  @override
  State<TrackerItem> createState() => _TrackerItemState();

  String toJson() {
    return jsonEncode({
      "name": name,
      "value": value,
      "counter": counter
    });
  }
}

class _TrackerItemState extends State<TrackerItem> {
  int counter = 0;

  @override
  void initState() {
    super.initState();
    _loadTracker();
  }

  void _loadTracker() async {
    final prefs = await SharedPreferences.getInstance();
    final tracker = json.decode(prefs.get(widget.name).toString());
    setState(() {
      counter += tracker["counter"] as int;
    });
  }

  void _saveTracker(int counterAdjustment) async {
    final prefs = await SharedPreferences.getInstance();
    widget.counter += counterAdjustment;
    prefs.setString(widget.name, widget.toJson());
    setState(() {
      counter += counterAdjustment;
    });
  }

  @override
  Widget build(BuildContext context) {
    var value = widget.value;
    return Container(
      margin: const EdgeInsets.only(bottom: 32.0),
      child: Column(
        children: [
          Text(
            widget.name,
            style: const TextStyle(fontSize: 24),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Ink(
                decoration: const ShapeDecoration(
                  color: Colors.lightBlue,
                  shape: CircleBorder(),
                ),
                child: IconButton(
                  icon: const Icon(Icons.remove),
                  color: Colors.white,
                  tooltip: 'Decrease',
                  onPressed: () => _saveTracker(-1),
                )
              ),
              Text(
                '$counter/$value',
                style: const TextStyle(fontSize: 20),
              ),
              Ink(
                decoration: const ShapeDecoration(
                  color: Colors.lightBlue,
                  shape: CircleBorder(),
                ),
                child: IconButton(
                  icon: const Icon(Icons.add),
                  color: Colors.white,
                  tooltip: 'Increase',
                  onPressed: () => _saveTracker(1),
                )
              ),
            ],
          )
        ],
      )
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  List<TrackerItem> trackers = [
  ];

  @override
  void initState() {
    super.initState();
    _loadTrackers();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _nameController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  void _loadTrackers() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      trackers = prefs.getKeys().map((key) => _getTrackerItem(prefs, key)).toList();
    });
  }

  TrackerItem _getTrackerItem(SharedPreferences prefs, String key) {
    final map = json.decode(prefs.get(key).toString());
    return TrackerItem(name: map["name"], value: map["value"], counter: map["counter"]);
  }

  void _saveTracker(TrackerItem newTracker) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(newTracker.name, newTracker.toJson());
    setState(() {
      trackers.add(newTracker);
    });
  }

  void _addTracker(BuildContext context) {
    TrackerItem newTrackerItem = TrackerItem(name: _nameController.text, value: int.parse(_valueController.text));
    _saveTracker(newTrackerItem);

    _nameController.clear();
    _valueController.clear();
    Navigator.pop(context);
  }

  void _showAddTrackerModal() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.all(32),
            color: Colors.amber,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'Add Tracker',
                  style: TextStyle(fontSize: 24)
                ),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Name',
                  )
                ),
                TextField(
                  controller: _valueController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Goal/Limit',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      child: const Text('OK'),
                      onPressed: () => _addTracker(context),
                    ),
                    const SizedBox(width: 32),
                    ElevatedButton(
                      child: const Text('Cancel'),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                )
              ],
            ),
          )
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 32),
            Column(children: trackers)
          ]
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTrackerModal,
        tooltip: 'Add Tracker',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
