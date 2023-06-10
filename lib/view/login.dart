import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:project_firebase/controller/auth_controller.dart';
import 'package:project_firebase/model/user_model.dart';
import 'package:project_firebase/view/contact.dart';
import 'package:project_firebase/view/register.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formkey = GlobalKey<FormState>();
  final autCtr = AuthController();

  bool eyeToggle = true;

  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Form(
            key: formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 380,
                  height: 80,
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Username',
                        hintText: 'Username/Email',
                        prefixIcon: Icon(Icons.person)),
                    validator: (value) {
                      bool valid = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value!);

                      if (value.isEmpty) {
                        return 'Please Enter your username/email';
                      }
                    },
                    onChanged: (value) {
                      email = value;
                    },
                  ),
                ),
                Container(
                  width: 380,
                  height: 80,
                  child: TextFormField(
                    obscureText: eyeToggle,
                    decoration: InputDecoration(
                        labelText: "Password",
                        hintText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                        suffix: InkWell(
                          onTap: () {
                            setState(() {
                              eyeToggle = !eyeToggle;
                            });
                          },
                          child: Icon(eyeToggle
                              ? Icons.visibility_off
                              : Icons.visibility_off),
                        )),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter your password";
                      }
                    },
                    onChanged: (value) {
                      password = value;
                    },
                  ),
                ),
                ElevatedButton(
                    child: Text('Login'),
                    onPressed: () async {
                      if (formkey.currentState!.validate()) {
                        UserModel? signUser = await autCtr
                            .signInWithEmailAndPassword(email!, password!);

                        if (signUser != null) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Login Successful'),
                                content: const Text(
                                    'You have been successfully Loginned.'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Contact()));
                                      print(signUser.email);
                                      // Navigate to the next screen or perform any desired action
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          // Login failed
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Login Failed'),
                                content: const Text(
                                    'An error occurred during Login.'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Login()));
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }
                    }),
                Container(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(color: Colors.grey),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Register()));
                            },
                            child: Text(
                              "Sign Up",
                              style: TextStyle(color: Colors.amber),
                            ))
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
