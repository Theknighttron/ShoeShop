import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:signin/screens/Resert_Password.dart';
import 'package:signin/screens/home_screen.dart';
import 'signup_screen.dart';

class SigninScreen extends StatefulWidget {
    const SigninScreen({super.key});

    @override
    State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
    final TextEditingController _passwordTextController = TextEditingController();
    final TextEditingController _emailTextController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    String? _errorMessage;

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.blue.shade900, Colors.lightBlueAccent],
                    ),
                ),
                child: SafeArea(
                    child: Center(
                        child: SingleChildScrollView(
                            padding: const EdgeInsets.all(24.0),
                            child: Form(
                                key: _formKey,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                        Image.asset(
                                            "../assets/images/shopLogo.png",
                                            width: 150,
                                            height: 150,
                                        ),
                                        const SizedBox(height: 48),
                                        TextFormField(
                                            controller: _emailTextController,
                                            decoration: _inputDecoration('Email', Icons.email),
                                            keyboardType: TextInputType.emailAddress,
                                            validator: (value) {
                                                if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                                                return null;
                                            },
                                        ),
                                        const SizedBox(height: 16),
                                        TextFormField(
                                            controller: _passwordTextController,
                                            decoration: _inputDecoration('Password', Icons.lock),
                                            obscureText: true,
                                            validator: (value) {
                                                if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                                                return null;
                                            },
                                        ),
                                        const SizedBox(height: 24),
                                        if (_errorMessage != null)
                                        Padding(
                                            padding: const EdgeInsets.only(bottom: 16),
                                            child: Text(
                                                _errorMessage!,
                                                style: const TextStyle(color: Colors.red, fontSize: 14),
                                                textAlign: TextAlign.center,
                                            ),
                                        ),
                                        ElevatedButton(
                                            onPressed: _signIn,
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.yellow,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(30),
                                                ),
                                                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                                            ),
                                            child: const Text(
                                                "Sign In",
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                ),
                                            ),
                                        ),
                                        const SizedBox(height: 24),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                                const Text(
                                                    "Don't have an account?",
                                                    style: TextStyle(color: Colors.white70),
                                                ),
                                                TextButton(
                                                    onPressed: () => Navigator.push(
                                                        context,
                                                        MaterialPageRoute(builder: (context) => const SignUpScreen()),
                                                    ),
                                                    child: const Text(
                                                        "Sign Up",
                                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                    ),
                                                ),
                                            ],
                                        ),
                                        TextButton(
                                            onPressed: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => const ResetPasswordScreen()),
                                            ),
                                            child: const Text(
                                                "Forgot Password?",
                                                style: TextStyle(color: Colors.white70),
                                            ),
                                        ),
                                    ],
                                ),
                            ),
                        ),
                    ),
                ),
            ),
        );
    }

    InputDecoration _inputDecoration(String label, IconData icon) {
        return InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon, color: Colors.white70),
            labelStyle: TextStyle(color: Colors.white70),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.white70),
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.white),
            ),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.red),
            ),
            filled: true,
            fillColor: Colors.white.withOpacity(0.1),
        );
    }

    void _signIn() async {
        if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailTextController.text,
          password: _passwordTextController.text,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } on FirebaseAuthException catch (e) {
        setState(() {
          if (e.code == 'user-not-found') {
            _errorMessage = 'No user found for that email.';
          } else if (e.code == 'wrong-password') {
            _errorMessage = 'Wrong password provided for that user.';
          } else if (e.code == 'invalid-email') {
            _errorMessage = 'The email address is badly formatted.';
          } else {
            _errorMessage = 'An error occurred. Please try again.';
          }
        });
      }
    }
    }
}
