import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:langify/reusable_widgets/reusable_widget.dart';
import 'package:langify/screens/home_screen.dart';
import 'package:langify/screens/signup_screen.dart';
import 'package:langify/utils/color_utils.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

   TextEditingController _passwordTextController = TextEditingController();
   TextEditingController _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
       gradient: LinearGradient(colors: [ 
      hexStringToColor("191E29"),
      hexStringToColor("132D46"),
      hexStringToColor("01C38D")
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter  )),
      child: SingleChildScrollView(
        child: Padding(
        padding: EdgeInsets.fromLTRB(
          20, MediaQuery.of(context).size.height * 0.1, 20, 0),
          child: Column(
            children: <Widget>[
              logoWidget("assets/images/LangifyLogo.png"),
              SizedBox(
                height: 30,
              ),
              reusableTextField("Enter UserName", Icons.person_outline, false ,
               _emailTextController),
               SizedBox(
                height: 20,
              ),
              reusableTextField("Enter Password", Icons.lock_outline, true ,
               _passwordTextController),
                SizedBox(
                height: 20,
              ),
              signInSignUpButton(context, true , () {
                FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: _emailTextController.text,
                          password: _passwordTextController.text)
                      .then((value) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  }).onError((error, stackTrace) {
                    print("Error ${error.toString()}");
                  });
              }),
              signUpOption()
            ],
          ),
         ),
      ) ,
    )
   );
  }

   Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account?",
          style: TextStyle(color: Colors.white70) ),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => SignUpScreen()));
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}