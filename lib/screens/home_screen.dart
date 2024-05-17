import 'package:flutter/material.dart';
import '../screens/add_task_screen.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/report.dart';
import '../User/login_screen.dart';
import 'dart:async';
import 'package:idle_detector_wrapper/idle_detector_wrapper.dart';

class HomeScreen extends StatefulWidget {
  final String email;
  HomeScreen({required this.email});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  List<Map<String, dynamic>> tasks = [];
  late SharedPreferences _prefs;
  late Timer _taskTimer;
  Timer? _idleTimer; // Make _idleTimer nullable
  late String _loginTime;
  late int tab;
  Duration _idleDuration = Duration.zero;
  bool _isIdle = false;
  int numTasksCompleted = 0;

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
    WidgetsBinding.instance.addObserver(this);
    _loginTime = DateFormat('hh:mm a').format(DateTime.now());
    _startTaskTimer();
  }

  @override
  void dispose() {
    _taskTimer.cancel();
    _idleTimer?.cancel(); // Use null-aware operator to cancel if not null
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _startTaskTimer() {
    _taskTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      if (!_isDialogOpen) {
        _checkIncompleteTasks();
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      // Start tracking idle time
      _startIdleTimer();
    } else if (state == AppLifecycleState.resumed) {
      // Stop tracking idle time
      _stopIdleTimer();
    }
  }


  void _startIdleTimer() {
    _idleTimer?.cancel(); // Cancel any existing idle timer
    _idleTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _idleDuration += Duration(seconds: 1);
      });
      _prefs.setString('_idleDuration', _idleDuration.toString().split('.').first);
    });
  }

  void _stopIdleTimer() {
    _idleTimer?.cancel(); // Use null-aware operator to cancel if not null
    if (_hasIncompleteTasks() && !_isHaltDialogOpen) {
      _showIdleResumeDialog();
    }
  }


  bool _isDialogOpen = false;
  bool _isHaltDialogOpen = false;

  void _showIdleResumeDialog() {
    _isHaltDialogOpen = true;
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        String haltReason = '';
        return WillPopScope(
          onWillPop: () async => false, // Prevent dismissing by pressing the back button
          child: AlertDialog(
            title: Text(
              'You are here after a idle state',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: TextField(
              onChanged: (value) {
                haltReason = value;
              },
              decoration: InputDecoration(
                labelText: 'mention the reason for the halt',
                border: OutlineInputBorder(),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  if (haltReason.isNotEmpty) {
                    setState(() {
                      var task = tasks.firstWhere((task) => !task['completed']);
                      String currentTime = DateFormat('hh:mm a').format(DateTime.now());
                      String newEntry = 'Halt stamp: $currentTime - $haltReason';
                      if (task.containsKey('haltReasons')) {
                        task['haltReasons'] += '\n$newEntry';
                      } else {
                        task['haltReasons'] = newEntry;
                      }
                    });
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please enter a reason for the halt.'),
                      ),
                    );
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        );
      },
    ).then((_) {
      _isHaltDialogOpen = false;
    });
  }

  void _checkIncompleteTasks() {
    bool hasIncompleteTasks = _hasIncompleteTasks();
    if (hasIncompleteTasks) {
      _isDialogOpen = true;
      showDialog(
        context: context,
        barrierDismissible: false, // Prevent dismissing by tapping outside
        builder: (BuildContext context) {
          String progressStatus = '';
          return WillPopScope(
            onWillPop: () async => false, // Prevent dismissing by pressing the back button
            child: AlertDialog(
              title: Text(
                'Still in progress?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('Update your recent task status over here.'),
                  SizedBox(height: 20),
                  TextField(
                    onChanged: (value) {
                      progressStatus = value;
                    },
                    decoration: InputDecoration(
                      labelText: 'Progress Status',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    if (progressStatus.isNotEmpty) {
                      setState(() {
                        var task = tasks.firstWhere((task) => !task['completed']);
                        String currentTime = DateFormat('hh:mm a').format(DateTime.now());
                        String newEntry = 'Progress stamp: $currentTime - $progressStatus';
                        if (task.containsKey('progressStatuses')) {
                          task['progressStatuses'] += '\n$newEntry';
                        } else {
                          task['progressStatuses'] = newEntry;
                        }
                      });
                      Navigator.of(context).pop();
                      _isDialogOpen = false;
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please enter a progress status.'),
                        ),
                      );
                    }
                  },
                  child: Text('Yes'),
                ),
              ],
            ),
          );
        },
      );
    }
  }





  void _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _loginTime = DateFormat('hh:mm a').format(DateTime.now());
    _prefs.setString('login_time', _loginTime);
    print('Login time saved: $_loginTime');

    tab = _prefs.getInt('_currentTab') ?? 0;
    _prefs.setString('_idleDuration', _idleDuration.toString().split('.').first);

    if (tab > 0) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
              onWillPop: () async => false, // Prevent back navigation
              child: AlertDialog(
                title: Text(
                  'You have a Loggedin Session .',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: RichText(
                  text: TextSpan(
                    text: 'Redirecting you to the login page...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      _prefs.setInt('_currentTab', 0);
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: Text('Close'),
                  ),
                ],
              )
          );
        },
      );
      Future.delayed(Duration(seconds: 5), () {
        _prefs.setInt('_currentTab', 2);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      });
    }

    _prefs.setInt('_currentTab', tab + 2);
    print("here the tab value after init");
    print(_prefs.getInt('_currentTab'));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false, // Prevent back navigation
        child:IdleDetector(
      idleTime: const Duration(seconds: 10),
      onIdle: () {
        setState(() {
          // Reset idle duration when idle
          _idleDuration += const Duration(seconds: 10);
          _prefs.setString('_idleDuration', _idleDuration.toString().split('.').first);
        });
      },
      child: Scaffold(
        appBar: AppBar(
        title: Text(
        'Job Scheduler',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
          backgroundColor: Colors.blue[100],
          actions: [
            ElevatedButton(
              onPressed: _logout,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Colors.red,
              ),
              child: Text('Logout',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
            ),
          ],
        ),
        body: SingleChildScrollView( // Wrap your body with SingleChildScrollView to enable scrolling
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome ${widget.email.split('@').first.split('.')[0][0].toUpperCase()}${widget.email.split('@').first.split('.')[0].substring(1)} 👋',
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Logged in: $_loginTime',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'Idle Duration: ${_formatDuration(_idleDuration)}', // Display idle duration
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              tasks.isEmpty
                  ? Center(
                child: Text(
                  'Seems like no job today ...',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              )
                  : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
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
                            if (task.containsKey('progressStatuses'))
                              Text(
                                task['progressStatuses'],
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black54,
                                ),
                              ),
                            if (task.containsKey('haltReasons'))
                              Text(
                                task['haltReasons'],
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black54,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )


            ],
          ),
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
      ),
    ));
  }



  String _formatDuration(Duration duration) {
    return '${duration.inHours}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  bool _hasIncompleteTasks() {
    return tasks.any((task) => !task['completed']);
  }


  void _logout() async {
    String logoutTime = DateFormat('hh:mm a').format(DateTime.now());
    _prefs.setString('logout_time', logoutTime);
    print('Logout time saved: $logoutTime');
    if (_hasIncompleteTasks()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please complete all tasks before logging out.'),
        ),
      );
      return; // Prevent logout if there are incomplete tasks
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => ReportPage()),
          (Route<dynamic> route) => false, // Clear the navigation stack
    );
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
                  numTasksCompleted++;
                  _prefs.setInt('numTasksCompleted', numTasksCompleted);
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
