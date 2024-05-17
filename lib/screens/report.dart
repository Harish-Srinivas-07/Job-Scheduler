import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../User/login_screen.dart';

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  late SharedPreferences _prefs;
  late String _loginTime;
  late String _logoutTime;
  late String _email;
  bool _isLoading = true;
  late int _task;
  late String _idle ;

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _email = _prefs.getString('email') ?? '';
    _loginTime = _prefs.getString('login_time') ?? '';
    // _loginTime = '09:00 PM';
    _logoutTime = _prefs.getString('logout_time') ?? '';
    _idle = _prefs.getString('_idleDuration') ?? '';
    _task  = _prefs.getInt('numTasksCompleted') ?? 0;

    await _prefs.setBool('credentials', false);
    await _prefs.setInt('_currentTab',0);
    await _prefs.setInt('numTasksCompleted',0);

    await _prefs.remove("email");
    print(_email);

    setState(() {
      _isLoading = false;
    });
  }

  String _formatIdleTime(String idleTime) {
    if (idleTime.isEmpty) {
      return 'Not available';
    }

    List<String> parts = idleTime.split(':');
    if (parts.length < 3) {
      return 'Invalid format';
    }

    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    int seconds = int.parse(parts[2].split('.')[0]);

    Duration duration = Duration(hours: hours, minutes: minutes, seconds: seconds);

    int totalMinutes = duration.inMinutes % 60;

    if (duration.inHours == 0 && totalMinutes == 0) {
      return 'Less than a minute';
    } else if (duration.inHours == 0) {
      return '$totalMinutes min';
    } else if (totalMinutes == 0) {
      return '${duration.inHours} hr';
    } else {
      return '${duration.inHours} hr $totalMinutes min';
    }
  }




// Inside your _calculateDuration method
  bool isDurationGreaterThanEightHours(String duration) {
    List<String> parts = duration.split(' ');
    int hours = int.parse(parts[0]);
    return hours > 8;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Prevent back navigation
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Report Page',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.blue[100],
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Today Date :',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                DateFormat('dd MMM yyyy').format(DateTime.now()), // Display today's date
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              Text(
                'Login Time:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                _loginTime.isNotEmpty ? _loginTime : 'Not available',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Logout Time:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                _logoutTime.isNotEmpty ? _logoutTime : 'Not available',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Task Completed :',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                _task.toString(),
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              Text(
                'Idle Duration :',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                _idle.isNotEmpty ? _formatIdleTime(_idle) : 'Not available',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Total Work Hours :',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                _calculateDuration(_loginTime, _logoutTime, '0:00:00'),
                style: TextStyle(
                  fontSize: 16,
                  color: isDurationGreaterThanEightHours(_calculateDuration(_loginTime, _logoutTime, '0:00:00'))
                      ? Colors.green
                      : Colors.red,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Total Active time:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                _idle.isNotEmpty
                    ? _calculateDuration(_loginTime, _logoutTime, _idle)
                    : 'Not available',
                style: TextStyle(
                  fontSize: 16,
                  color: _idle.isNotEmpty && isDurationGreaterThanEightHours(_calculateDuration(_loginTime, _logoutTime, _idle))
                      ? Colors.green
                      : Colors.red,
                ),
              ),
              SizedBox(height: 20),
              // Add the rounded button here
              Container(
                width: double.infinity,
                height: 50,
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: TextButton(
                  onPressed: () async {
                    await _prefs.setInt('_currentTab', 0);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.indigo[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Navigate to Home Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  String _calculateDuration(String loginTime, String logoutTime, String idleTime) {
    if (loginTime.isEmpty || logoutTime.isEmpty) {
      return 'Not available';
    }

    DateTime loginDateTime = DateFormat('hh:mm a').parse(loginTime);
    DateTime logoutDateTime = DateFormat('hh:mm a').parse(logoutTime);

    Duration totalDuration = logoutDateTime.difference(loginDateTime);
    Duration idleDuration = Duration();

    if (idleTime.isNotEmpty) {
      List<String> parts = idleTime.split(':');
      if (parts.length >= 3) {
        int hours = int.parse(parts[0]);
        int minutes = int.parse(parts[1]);
        int seconds = int.parse(parts[2].split('.')[0]);
        idleDuration = Duration(hours: hours, minutes: minutes, seconds: seconds);
      }
    }

    Duration activeDuration = totalDuration - idleDuration;

    String hours = (activeDuration.inHours % 24).toString().padLeft(2, '0');
    String minutes = (activeDuration.inMinutes % 60).toString().padLeft(2, '0');

    return hours == '00' ? '$minutes minutes.' : '$hours hours and $minutes minutes.';
  }


}
