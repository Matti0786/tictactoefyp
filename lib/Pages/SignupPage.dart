import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tictactoe/Pages/SigninPage.dart';
import 'package:tictactoe/utilities/Snackbar.dart';

class SignupPage extends StatefulWidget {
  SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String signupMessage = "";

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  Future<bool> signupWithEmailAndPassword(email, password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user?.sendEmailVerification();
      signupMessage = "Successfully Signup";
      return true;
    } catch (e) {
      if (e is FirebaseAuthException)
        signupMessage = e.message.toString();
      else
        signupMessage = e.toString();
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.fromLTRB(45, 50, 45, 10),
            child: Column(
              children: [
                // Logo
                Image.asset('images/logo.png', width: 250),
                SizedBox(height: 20),

                // Sign up Text
                Text("Sign up",
                    style: Theme.of(context).textTheme.headlineMedium),
                SizedBox(height: 10),
                const Text(
                  "Enter your email and password to create your accounnt",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17, color: Colors.grey),
                ),
                const SizedBox(height: 20),

                //Email Text Field
                Container(
                  padding: const EdgeInsets.only(left: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color.fromRGBO(237, 237, 237, 1),
                  ),
                  child: TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Email",
                    ),
                  ),
                ),
                SizedBox(height: 10),

                // Password Text Field
                Container(
                  padding: const EdgeInsets.only(left: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color.fromRGBO(237, 237, 237, 1),
                  ),
                  child: TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Password",
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Sign up Button
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () async {
                            bool isSignup = await signupWithEmailAndPassword(
                                emailController.text, passwordController.text);
                            ScaffoldMessenger.of(context).showSnackBar(
                                customSnackbar(signupMessage,
                                    isSignup ? Colors.green : Colors.red));
                            if (isSignup)
                              Navigator.pushReplacementNamed(
                                  context, '/signin');
                          },
                          child: Text("Signup"),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20),

                Text("Or Continue With"),
                SizedBox(height: 20),

                // Google Sign in
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Color.fromRGBO(245, 245, 245, 1)),
                          onPressed: () {},
                          child: Image.asset(
                            'images/google.png',
                            width: 25,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10),

                // Singup
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have account?"),
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/signin');
                        },
                        child: Text("Sign in"))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
