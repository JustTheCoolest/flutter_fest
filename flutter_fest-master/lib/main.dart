import 'package:flutter/material.dart';

void main() {
  runApp(LandingPage());
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
