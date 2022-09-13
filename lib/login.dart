import 'package:firedart/firestore/firestore.dart';
import 'package:flutter/material.dart';
import 'package:inventory_system/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Models/loading.dart';
import 'constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey formkey = GlobalKey();
  TextEditingController mail = TextEditingController();
  TextEditingController pass = TextEditingController();

  String uid = '';

  bool loading = false;

  String email = '';
  String password = '';
  String error = '';

  bool obscureText = true;
  // Icon eye = const Icon(Icons.visibility);
  // FaIcon eye = const FaIcon(FontAwesomeIcons.solidEye);
  Color eyeColor = Colors.black;
  // String eye = '\nshow';
  Icon eye = Icon(Icons.visibility, color: darkgrey);
  Icon show = Icon(Icons.visibility, color: darkgrey);
  Icon hide = Icon(Icons.visibility_off, color: black);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return loading
        ? const Loading()
        : Scaffold(
            backgroundColor: black,
            body: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: size.width * 0.5,
                    child: Image.asset(
                      'assets/img/logo.png',
                      height: size.height * 0.2,
                    ),
                  ),
                  // Image.network(
                  //   'assets/img/name-white.png',
                  //   height: size.height * 0.07,
                  // ),
                  // SizedBox(
                  //   height: size.height * 0.1,
                  // ),
                  Container(
                    decoration: BoxDecoration(
                      color: grey,
                    ),
                    height: size.height,
                    width: size.width * 0.5,
                    child: Center(
                      child: SizedBox(
                        height: size.height * 0.4,
                        child: Form(
                          key: formkey,
                          child: Column(
                            children: [
                              SizedBox(
                                height: size.height * 0.1,
                                width: size.width * 0.3,
                                child: TextFormField(
                                  controller: mail,
                                  decoration: InputDecoration(
                                    label: Text(
                                      'Username',
                                      style: TextStyle(color: black),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: black,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: black,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                  ),
                                  onChanged: (val) {
                                    setState(() => email = val.trim());
                                  },
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.04,
                              ),
                              SizedBox(
                                height: size.height * 0.1,
                                width: size.width * 0.3,
                                child: TextFormField(
                                  controller: pass,
                                  obscureText: obscureText,
                                  decoration: InputDecoration(
                                    label: Text(
                                      'Password',
                                      style: TextStyle(color: black),
                                    ),
                                    suffixIcon: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            obscureText = !obscureText;
                                            obscureText == true
                                                ? eye = show
                                                : eye = hide;
                                            obscureText == true
                                                ? eyeColor = darkgrey
                                                : eyeColor = black;
                                          });
                                        },
                                        child: eye),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: black,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: black,
                                        width: 2.0,
                                      ),
                                    ),
                                  ),
                                  onChanged: (val) {
                                    setState(() => password = val.trim());
                                  },
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.15,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      error,
                                      style: TextStyle(
                                          fontSize: size.height * 0.02,
                                          color: Colors.red),
                                    ),
                                    SizedBox(
                                      height: size.height * 0.06,
                                      width: size.width * 0.3,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();

                                          if (email.isNotEmpty &&
                                              password.isNotEmpty) {
                                            setState(() => loading = true);

                                            await Firestore.instance
                                                .collection("AWT")
                                                .document("admin")
                                                .get()
                                                .then((value) {
                                              if (email == value['username'] &&
                                                  password == value['pass']) {
                                                setState(() {
                                                  uid = value["id"];
                                                  prefs.setString("user", uid);
                                                });
                                                if (prefs.getString("user") ==
                                                    uid) {
                                                  loading = false;
                                                  // ignore: use_build_context_synchronously
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const HomeScreen()));
                                                } else {
                                                  setState(() {
                                                    error = 'Not an admin';
                                                  });
                                                }
                                              }
                                            });
                                          } else if (email.isEmpty ||
                                              password.isEmpty) {
                                            setState(() {
                                              error = 'Both fields required';
                                            });
                                          }
                                        },
                                        child: const Text("Let's go!"),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
