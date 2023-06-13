import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    final Map<String, String> keys = jsonDecode('assets/keys.json');
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: keys['apiKey'],
            appId: keys['appId'],
            messagingSenderId: keys['messagingSenderId'],
            projectId: keys['projectId']));
  } else {
    Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const NewPostPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
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
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

Future<List<String>> getData(collectionRef) async {
  // Get docs from collection reference
  QuerySnapshot querySnapshot = await collectionRef.get();

  // Get data from docs and convert map to List
  final allData = querySnapshot.docs.map((doc) => doc.id).toList();
  return allData;
}

class NewPostPage extends StatelessWidget {
  const NewPostPage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget buildTitle(String title){
      return Container(
        height: 50,
        padding: const EdgeInsets.all(8),
        child: Align(
            alignment: Alignment.centerLeft,
            child: Text(title)
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Connection'),
        shadowColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          buildTitle('Title'),
          const DropdownButtonExample(collection: "categories"),
        ],
      )
    );
  }
}

class DropdownButtonExample extends StatefulWidget {
  final String collection;
  const DropdownButtonExample({super.key, required this.collection});
  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  String dropdownValue = "";
  List<String> list = [];
  @override
  void initState() {
    super.initState();
    final CollectionReference collectionRef = FirebaseFirestore.instance.collection(widget.collection);
    list = getData(collectionRef) as List<String>;
    dropdownValue = list.first;
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
        future: getData(
            FirebaseFirestore.instance.collection(widget.collection)),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          else if (snapshot.hasData) {
            return DropdownButton<String>(
              value: dropdownValue,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  dropdownValue = value!;
                });
              },
              items: list.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            );
          }
          else {
            return const CircularProgressIndicator();
          }
        }
    );
  }
}









class Task {
  final String title;
  final String description;

  Task({required this.title, required this.description});
}

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  List<Task> ongoingTasks = [];

  @override
  void initState() {
    super.initState();
    fetchTasksFromDatabase();
  }

  void fetchTasksFromDatabase() {
    // Simulate fetching tasks from the user database
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        ongoingTasks = [
          Task(
            title: 'Task 1',
            description: 'Task 1 description',
          ),
          Task(
            title: 'Task 2',
            description: 'Task 2 description',
          ),
          Task(
            title: 'Task 3',
            description: 'Task 3 description',
          ),
          Task(
            title: 'Task 4',
            description: 'Task 4 description',
          ),
          Task(
            title: 'Task 5',
            description: 'Task 5 description',
          ),
        ];
      });
    });
  }

  void navigateToTaskPage(Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskPage(task: task),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Landing Page'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 150, // Decrease the height of the task container
                color: Colors.blue,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: ongoingTasks.length,
                  itemBuilder: (context, index) {
                    final task = ongoingTasks[index];
                    return ElevatedButton(
                      onPressed: () => navigateToTaskPage(task),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: Colors.blue,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.all(16),
                        minimumSize: Size(150, 150),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            task.title,
                            style: TextStyle(
                                fontSize:
                                    16), // Decrease the font size of the task title
                          ),
                          SizedBox(height: 4),
                          Text(
                            task.description,
                            style: TextStyle(
                                fontSize:
                                    12), // Decrease the font size of the task description
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                height: 500,
                color: Colors.green,
                child: Center(
                  child: Text(
                    'Second Container',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
              ),
              Container(
                height: 800,
                color: Colors.orange,
                child: Center(
                  child: Text(
                    'Third Container',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TaskPage extends StatelessWidget {
  final Task task;

  TaskPage({required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Task: ${task.title}',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            Text(
              'Description: ${task.description}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
