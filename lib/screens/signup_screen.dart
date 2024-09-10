import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'signin_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _userNameTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade900, Colors.lightBlueAccent],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.09, 20, 0),
            child: Column(children: [
              Image.asset(
                "../assets/images/shopLogo.png",
                fit: BoxFit.fitWidth,
                width: 340,
                height: 340,
              ),
              TextField(
                controller: _userNameTextController,
                obscureText: false,
                enableSuggestions: !false,
                autocorrect: !false,
                cursorColor: Colors.yellow,
                style: TextStyle(color: Colors.blue.shade900),
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.person_2_outlined,
                    color: Colors.yellow,
                  ),
                  labelText: "Enter your Username",
                  labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
                  filled: true,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  fillColor: Colors.yellow.withOpacity(0.3),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide:
                          const BorderSide(width: 0, style: BorderStyle.none)),
                ),
                keyboardType:
                    false ? TextInputType.visiblePassword : TextInputType.name,
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _emailTextController,
                obscureText: false,
                enableSuggestions: !false,
                autocorrect: !false,
                cursorColor: Colors.yellow,
                style: TextStyle(color: Colors.blue.shade900),
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.person_2_outlined,
                    color: Colors.yellow,
                  ),
                  labelText: "Enter your Email",
                  labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
                  filled: true,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  fillColor: Colors.yellow.withOpacity(0.3),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide:
                          const BorderSide(width: 0, style: BorderStyle.none)),
                ),
                keyboardType: false
                    ? TextInputType.visiblePassword
                    : TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _passwordTextController,
                obscureText: true,
                enableSuggestions: !true,
                autocorrect: !true,
                cursorColor: Colors.yellow,
                style: TextStyle(color: Colors.blue.shade900),
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.lock_outline_rounded,
                    color: Colors.yellow,
                  ),
                  labelText: "Enter your Password",
                  labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
                  filled: true,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  fillColor: Colors.yellow.withOpacity(0.3),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide:
                          const BorderSide(width: 0, style: BorderStyle.none)),
                ),
                keyboardType: false
                    ? TextInputType.visiblePassword
                    : TextInputType.visiblePassword,
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 60,
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(90)),
                child: ElevatedButton(
                  onPressed: () {
                    FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: _emailTextController.text,
                            password: _passwordTextController.text)
                        .then(
                      (value) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SigninScreen(),
                          ),
                        );
                      },
                    ).onError(
                      (error, stackTrace) {
                        var invalidemailError =
                            "[firebase_auth/invalid-email] The email address is badly formatted.";
                        var emailExistError =
                            "[firebase_auth/email-already-in-use] The email address is already in use by another account.";
                        var weakPassword =
                            "[firebase_auth/weak-password] Password should be at least 6 characters";
                        print(error);
                        if (error.toString() == invalidemailError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.yellowAccent,
                              dismissDirection: DismissDirection.up,
                              duration: const Duration(seconds: 7),
                              content: const Text(
                                "       📛Invalid Email format📛",
                                style: TextStyle(
                                    backgroundColor: Colors.yellowAccent,
                                    color: Colors.red,
                                    fontSize: 30),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                            ),
                          );
                        } else if (error.toString() == emailExistError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.yellowAccent,
                              dismissDirection: DismissDirection.up,
                              duration: const Duration(seconds: 7),
                              content: const Text(
                                "       📛Email is already Exist📛",
                                style: TextStyle(
                                    backgroundColor: Colors.yellowAccent,
                                    color: Colors.red,
                                    fontSize: 30),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                            ),
                          );
                        } else if (error.toString() == weakPassword) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.yellowAccent,
                              dismissDirection: DismissDirection.up,
                              duration: const Duration(seconds: 7),
                              content: const Text(
                                "       📛Weak Password,Plz Enter at least 6 characters📛",
                                style: TextStyle(
                                    backgroundColor: Colors.yellowAccent,
                                    color: Colors.red,
                                    fontSize: 30),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                            ),
                          );
                        }
                      },
                    );
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.blue;
                        }
                        return Colors.yellow;
                      }),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)))),
                  child: const Text(
                    "SignUp",
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have account?",
                    style: TextStyle(color: Colors.white70),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SigninScreen()));
                    },
                    child: const Text(
                      " Sign In",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }
}
