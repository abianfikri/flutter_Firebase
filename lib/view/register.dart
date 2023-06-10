import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:project_firebase/controller/auth_controller.dart';
import 'package:project_firebase/model/user_model.dart';
import 'package:project_firebase/view/contact.dart';
import 'package:project_firebase/view/login.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formkey = GlobalKey<FormState>();
  final autCtr = AuthController();

  String? name;
  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: InputDecoration(hintText: "Name"),
                onChanged: (value) {
                  name = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(hintText: "Email"),
                onChanged: (value) {
                  email = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(hintText: "Password"),
                onChanged: (value) {
                  password = value;
                },
              ),
              ElevatedButton(
                child: Text('Register'),
                onPressed: () async {
                  if (formkey.currentState!.validate()) {
                    UserModel? registeredUser = await autCtr
                        .registerWithEmailAndPassword(email!, password!, name!);

                    if (registeredUser != null) {
                      // Registration successful
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Registration Successful'),
                            content: const Text(
                                'You have been successfully registered.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Login()));
                                  print(registeredUser.name);
                                  // Navigate to the next screen or perform any desired action
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      // Registration failed
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Registration Failed'),
                            content: const Text(
                                'An error occurred during registration.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Register()));
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
