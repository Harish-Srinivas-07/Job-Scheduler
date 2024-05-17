import 'package:flutter/material.dart';
import '../utils/app_validator.dart';
import '../screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _appValidator = AppValidator();

  late int tab;

  bool _isLoading = false;
  Map<String, String> userCredentials = {};

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      // Simulate network request delay
      await Future.delayed(Duration(seconds: 2));

      // Save email and credentials
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', _emailController.text);
      await prefs.setBool('credentials', true);
      await prefs.setInt('_currentTab', 0);

      // Navigate to HomeScreen on successful login
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen(email: _emailController.text)),
      );
    }
  }

  InputDecoration _buildInputDecoration(String label, IconData suffixIcon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(suffixIcon),
      fillColor: Colors.white,
      filled: true,
      contentPadding: EdgeInsets.symmetric(vertical: 30),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(80.0),
        borderSide: BorderSide(color: Color.fromARGB(255, 46, 48, 146)),
      ),
      labelStyle: TextStyle(color: Colors.black),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(80.0),
        borderSide: BorderSide(color: Color.fromARGB(255, 46, 48, 146)),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(80.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Prevent back navigation
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Job Scheduler Login Portal',
            style: TextStyle(
              fontWeight: FontWeight.bold,color: Colors.white
            ),
          ),
          centerTitle: false, // Align title to the left
          backgroundColor: Colors.blue[600],
        ),
        backgroundColor: Colors.blue[50], // Pale blue background color
        body: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MediaQuery.of(context).size.width > 600
                  ? Expanded(
                flex: 1,
                child: Image.asset(
                  'assets/images/office.png',
                  height: 550,
                  width: 500, // Adjust image height as needed
                ),
              )
                  : SizedBox(),
              MediaQuery.of(context).size.width > 600 ? SizedBox(width: 40) : SizedBox(height: 20),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Welcome, Buddy!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 40),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 55,
                            // width: 400, // Removed width constraint
                            child: TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: _buildInputDecoration('Enter your email id', Icons.email),
                              validator: (value) => _appValidator.validateEmail(value),
                            ),
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            height: 55,
                            // width: 400, // Removed width constraint
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: _buildInputDecoration('Provide Password', Icons.lock),
                              validator: (value) => _appValidator.validatePassword(value),
                              // Less rounded border

                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _submitForm,
                      child: _isLoading
                          ? SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator(),
                      )
                          : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.done_all),
                          SizedBox(width: 10),
                          Text(
                            'Sign in',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(150, 60), // Fixed size
                        backgroundColor: Colors.blue[700],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



}
