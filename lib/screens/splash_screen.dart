import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/home_screen.dart';
import '../User/login_screen.dart';

class SplashScreen extends StatelessWidget {
  late String email;

  Future<void> _checkCredentials(BuildContext context) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    bool? credentials = _prefs.getBool('credentials');
    String? email = _prefs.getString('email');

    if (credentials != null && credentials) {
      // Navigate to HomeScreen with email
      String? email = _prefs.getString('email');
      print(email);
      if (email != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen(email: email)),
        );
      } else {
        // If email is not available, navigate to login screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    } else {
      // Navigate to login screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginPage()),
        // MaterialPageRoute(builder: (context) => HomeScreen(email: "harish@gmail.com")),

      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      _checkCredentials(context);
    });

    return Scaffold(
      backgroundColor: Colors.blue[600], // Pale blue background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to Job Scheduler',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Manage all your tasks',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
