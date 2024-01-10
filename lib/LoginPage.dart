import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/pages/widgets/button.global.dart';
import 'package:flutter_application/pages/widgets/text.form.global.dart';
import 'package:flutter_application/constants/colors.dart';
import 'package:flutter_application/user_auth/firebase_auth_implementation/firebase_auth_services.dart';

String username = '';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String msg = '';

  Future<void> _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      User? user = userCredential.user;
      if (user != null) {
        // Navigate based on user role or any other logic
        Navigator.pushReplacementNamed(context, '/DashboardPage');
        // Update the username if needed
        setState(() {
          username = user.email!;
        });
      } else {
        setState(() {
          msg = "Login Fail";
        });
      }
    } catch (e) {
      setState(() {
        msg = "Login Fail: $e";
      });
    }
  }

  void _navigateToRegisterPage() {
    Navigator.pushNamed(context, '/RegisterPage');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'APKU!',
                    style: TextStyle(
                      color: CustomColors.mainColor,
                      fontSize: 35,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Text(
                  'Login to your account',
                  style: TextStyle(
                    color: CustomColors.textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                TextFormGlobal(
                  controller: emailController,
                  text: 'Email',
                  textInputType: TextInputType.emailAddress,
                  obscure: false,
                ),
                const SizedBox(height: 6),
                TextFormGlobal(
                  controller: passwordController,
                  text: 'Password',
                  textInputType: TextInputType.text,
                  obscure: true,
                ),
                const SizedBox(height: 10),
                ButtonGlobal(
                  buttonText: 'Sign In',
                  onPressed: _login,
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: _navigateToRegisterPage,
                  child: Text(
                    "Don't have an account? Sign up here!",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
