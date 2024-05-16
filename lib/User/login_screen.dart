import 'package:flutter/material.dart';
import '../utils/app_validator.dart';
import '../screens/home_screen.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _appValidator = AppValidator();

  bool _isLoading = false;
  Map<String, String> userCredentials = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Job Scheduler Login Portal',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true, // Align title at the center
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome, Buddy!', // Add welcoming text
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 40),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 60, // Increase text field height
                    child: TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: _buildInputDecoration('Email', Icons.email),
                      validator: (value) => _appValidator.validateEmail(value),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: 60, // Increase text field height
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: _buildInputDecoration('Password', Icons.lock),
                      validator: (value) => _appValidator.validatePassword(value),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
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
                minimumSize: Size(150, 60), // Minimize button width
                backgroundColor: const Color.fromARGB(255, 46, 48, 146),
                foregroundColor: Colors.white, // Dark blue background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0), // Rounded button corners
                ),
                padding: EdgeInsets.symmetric(vertical: 15), // Increase button height
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      // Simulating a login process for 2 seconds
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
          // Store user credentials upon successful login
          userCredentials[_emailController.text] = _passwordController.text;
        });
        // Navigate to HomeScreen on successful login
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen(email: _emailController.text)),
        );
      });
    }
  }

  InputDecoration _buildInputDecoration(String label, IconData suffixIcon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(suffixIcon),
      fillColor: Colors.white,
      filled: true,
      contentPadding: EdgeInsets.symmetric(vertical: 20), // Increase text field width
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
}
