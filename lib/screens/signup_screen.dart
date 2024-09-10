import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'signin_screen.dart';

class SignUpScreen extends StatefulWidget {
    const SignUpScreen({Key? key}) : super(key: key);

    @override
    State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
    final TextEditingController _passwordController = TextEditingController();
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _userNameController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    bool _isLoading = false;
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
                                        const SizedBox(height: 40),
                                        if (_errorMessage != null)
                                        Container(
                                            padding: const EdgeInsets.all(12),
                                            margin: const EdgeInsets.only(bottom: 20),
                                            decoration: BoxDecoration(
                                                color: Colors.red.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                                _errorMessage!,
                                                style: const TextStyle(color: Colors.white),
                                                textAlign: TextAlign.center,
                                            ),
                                        ),
                                        _buildTextField(
                                            controller: _userNameController,
                                            hintText: "Username",
                                            icon: Icons.person,
                                            validator: (value) {
                                                if (value == null || value.isEmpty) {
                          return 'Please enter a username';
                        }
                                                return null;
                                            },
                                        ),
                                        const SizedBox(height: 16),
                                        _buildTextField(
                                            controller: _emailController,
                                            hintText: "Email",
                                            icon: Icons.email,
                                            keyboardType: TextInputType.emailAddress,
                                            validator: (value) {
                                                if (value == null || value.isEmpty) {
                          return 'Please enter an email';
                        }
                                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                                                return null;
                                            },
                                        ),
                                        const SizedBox(height: 16),
                                        _buildTextField(
                                            controller: _passwordController,
                                            hintText: "Password",
                                            icon: Icons.lock,
                                            obscureText: true,
                                            validator: (value) {
                                                if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                                                if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                                                return null;
                                            },
                                        ),
                                        const SizedBox(height: 24),
                                        _buildSignUpButton(),
                                        const SizedBox(height: 16),
                                        _buildSignInLink(),
                                    ],
                                ),
                            ),
                        ),
                    ),
                ),
            ),
        );
    }

    Widget _buildTextField({
        required TextEditingController controller,
        required String hintText,
        required IconData icon,
        bool obscureText = false,
        TextInputType? keyboardType,
        String? Function(String?)? validator,
    }) {
        return TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                prefixIcon: Icon(icon, color: Colors.white70),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                ),
                errorStyle: const TextStyle(color: Colors.white),
            ),
            validator: validator,
        );
    }

    Widget _buildSignUpButton() {
        return SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: _isLoading ? null : _handleSignUp,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                    ),
                ),
                child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                        strokeWidth: 2,
                    ),
                )
                : const Text(
                    "Sign Up",
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                    ),
                ),
            ),
        );
    }

    Widget _buildSignInLink() {
        return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                const Text(
                    "Already have an account?",
                    style: TextStyle(color: Colors.white70),
                ),
                TextButton(
                    onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SigninScreen()),
                        );
                    },
                    child: const Text(
                        "Sign In",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                        ),
                    ),
                ),
            ],
        );
    }

    void _handleSignUp() async {
        setState(() {
            _errorMessage = null;
        });

        if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SigninScreen()),
        );
      } on FirebaseAuthException catch (e) {
        setState(() {
          _errorMessage = _getErrorMessage(e.code);
        });
      } finally {
        setState(() => _isLoading = false);
      }
    }
    }

    String _getErrorMessage(String errorCode) {
        switch (errorCode) {
            case 'weak-password':
                return 'The password provided is too weak.';
            case 'email-already-in-use':
                return 'An account already exists for that email.';
            case 'invalid-email':
                return 'The email address is badly formatted.';
            default:
                return 'An error occurred. Please try again.';
        }
    }
}
