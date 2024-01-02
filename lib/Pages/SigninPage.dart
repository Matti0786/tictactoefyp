import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tictactoe/utilities/Snackbar.dart';

class SigninPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String signinMessage = "";

  Future<bool> signinWithEmailAndPassword(email, password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      signinMessage = "Successfully Signin";
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('uid', userCredential.user!.uid);

      return true;
    } catch (e) {
      if (e is FirebaseAuthException)
        signinMessage = e.message.toString();
      else
        signinMessage = e.toString();
      return false;
    }
  }

  SigninPage({super.key});

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

                // Sign in Text
                Text("Sign in",
                    style: Theme.of(context).textTheme.headlineMedium),
                SizedBox(height: 10),
                const Text(
                  "Enter your email and password to enjoy game",
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
                SizedBox(height: 10),

                // Forgot Password Button
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  TextButton(
                    onPressed: () {
                      print("ALLAH");
                      Navigator.pushNamed(context, '/forgotPassword');
                    },
                    child: Text('Forgot Password'),
                  )
                ]),
                SizedBox(height: 10),

                // Signin Button
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () async {
                            bool isSignin = await signinWithEmailAndPassword(
                                emailController.text, passwordController.text);
                            ScaffoldMessenger.of(context).showSnackBar(
                                customSnackbar(signinMessage,
                                    isSignin ? Colors.green : Colors.red));
                            if (isSignin) {
                              final SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setBool('signin', true);
                              Navigator.pushReplacementNamed(
                                  context, '/mainMenu');
                            }
                          },
                          child: Text("Signin"),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20),

                Text("Or Sign in With"),
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
                    Text("Don't have account?"),
                    TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        child: Text("Sign up"))
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
