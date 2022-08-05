import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasedb/home.dart';
import 'package:firebasedb/login.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repasswordController = TextEditingController();
  Widget _buildName() {
    return TextFormField(
      autofocus: false,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return "Enter your name";
        }

        return null;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: "Enter your Name",
        hintText: "Name",
      ),
    );
  }

  Widget _buildEmail() {
    return TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return "Enter your email";
        }
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please Enter a valid email");
        }
        return null;
      },
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: "Enter your Email",
        hintText: "Email",
      ),
    );
  }

  Widget _buildPassword() {
    return TextFormField(
      autofocus: false,
      obscureText: true,
      controller: passwordController,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Password is required for login");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid Password(Min. 6 Character)");
        }
      },
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: "Enter your Password",
        hintText: "Password",
      ),
    );
  }

  Widget _buildRePassword() {
    return TextFormField(
      autofocus: false,
      obscureText: true,
      controller: repasswordController,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Password is required for login");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid Password(Min. 6 Character)");
        }
        if (passwordController.text == repasswordController.text) {
          return null;
        }
      },
      onSaved: (value) {
        repasswordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: "Enter your Password",
        hintText: "Password",
      ),
    );
  }

  Widget _SignUpButton() {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.blue,
      child: MaterialButton(
        padding: EdgeInsets.only(top: 15, left: 20, right: 20, bottom: 15),
        onPressed: () {
          SignUp(emailController.text, passwordController.text, context);

          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomeScreen()));
        },
        child: Text(
          "Register",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                _buildName(),
                SizedBox(
                  height: 15,
                ),
                _buildEmail(),
                SizedBox(
                  height: 15,
                ),
                _buildPassword(),
                SizedBox(
                  height: 15,
                ),
                _buildRePassword(),
                SizedBox(
                  height: 30,
                ),
                _SignUpButton(),
              ],
            ),
          )),
    );
  }

  void SignUp(String email, String password, BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {print("Sign up")})
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }
}
