import 'package:flutter/material.dart';

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
  const TrackerItem({Key? key, required this.name, required this.value, required this.type}) : super(key: key);

  final String name;
  final int value;
  final String type;

  @override
  State<TrackerItem> createState() => _TrackerItemState();
}

class _TrackerItemState extends State<TrackerItem> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(widget.name)
      ],
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
    const TrackerItem(name: "Coke", value: 3, type: "limit"),
    const TrackerItem(name: "Water", value: 8, type: "goal")
  ];

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _nameController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  void _addTracker(BuildContext context) {
    _nameController.clear();
    _valueController.clear();
    Navigator.pop(context);
  }

  void _showAddTrackerModal() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding:
                EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              padding: const EdgeInsets.all(32),
              color: Colors.amber,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
              ),
            )
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
      body: ListView(
        padding: const EdgeInsets.all(32),
        children: trackers,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTrackerModal,
        tooltip: 'Add Tracker',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
