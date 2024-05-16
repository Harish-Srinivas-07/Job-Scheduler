import 'package:flutter/material.dart';
import '../screens/add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  final String email;

  HomeScreen({required this.email});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> tasks = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Job Scheduler',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue[100],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome ${widget.email.split('@').first.split('.')[0]} 👋',
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
          tasks.isEmpty
              ? Center(
            child: Text(
              'Seems like no job today ...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey
              ),
            ),
          )
              : Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return InkWell(
                  onTap: () {
                    if (!task['completed']) {
                      _showCompletionConfirmation(context, task, index);
                    }
                  },
                  child: Card(
                    color: task['completed'] ? Colors.green[300] : Colors.red[100],
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task['title'] ?? '',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              decoration: task['completed'] ? TextDecoration.lineThrough : null,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(task['description'] ?? ''),
                          SizedBox(height: 10),
                          Text(
                            'Job Assigned time: ${task['startTime']}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            task['completed'] ? 'Completed' : 'Assigned',
                            style: TextStyle(
                              fontSize: 20,
                              color: task['completed'] ? Colors.green[900] : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: tasks.isNotEmpty && _hasIncompleteTasks()
          ? null
          : FloatingActionButton.extended(
        onPressed: () async {
          final newTask = await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddTaskScreen()),
          );
          if (newTask != null) {
            setState(() {
              tasks.add(newTask);
            });
          }
        },
        icon: Icon(Icons.add),
        label: Text('Create Task'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  bool _hasIncompleteTasks() {
    return tasks.any((task) => !task['completed']);
  }

  void _showCompletionConfirmation(BuildContext context, Map<String, dynamic> task, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Task Completion Confirmation',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text('Have you completed the task?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  tasks[index]['completed'] = true;
                  tasks[index]['completedTime'] = DateTime.now().toString();
                });
                Navigator.of(context).pop();
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
