import 'package:flutter/material.dart';
import 'package:preparia_ma/api_service.dart';
import 'package:preparia_ma/utils/ProgressUHD.dart';
import 'package:preparia_ma/models/customer.dart';
import 'package:preparia_ma/pages/home_page.dart'; // Import HomePage

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool isApiCallProcess = false;
  bool hidePassword = true;
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  String? username;
  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
      ),
      body: ProgressHUD(
        child: _uiSetup(context),
        inAsyncCall: isApiCallProcess,
        opacity: 0.3,
      ),
    );
  }

  Widget _uiSetup(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.purple],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: globalKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 100),
                Text(
                  'Create a new account',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 40),
                Container(
                  width: double.infinity,
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Username",
                      prefixIcon: Icon(Icons.person),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    onSaved: (input) => username = input,
                    validator: (input) => input!.isEmpty ? "Username cannot be empty" : null,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Email",
                      prefixIcon: Icon(Icons.email),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    onSaved: (input) => email = input,
                    validator: (input) => !input!.contains('@') ? "Email should be valid" : null,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  child: TextFormField(
                    obscureText: hidePassword,
                    decoration: InputDecoration(
                      hintText: "Password",
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(hidePassword ? Icons.visibility_off : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            hidePassword = !hidePassword;
                          });
                        },
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    onSaved: (input) => password = input,
                    validator: (input) => input!.length < 6 ? "Password should be at least 6 characters" : null,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (validateAndSave()) {
                      setState(() {
                        isApiCallProcess = true;
                      });

                      APIService().createCustomer(CustomerModel(
                        email: email!,
                        password: password!,
                        firstName: '',
                        lastName: '',
                      )).then((response) {
                        setState(() {
                          isApiCallProcess = false;
                        });

                        if (response) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Signup successful!')),
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Signup failed. Please try again.')),
                          );
                        }
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Colors.blue, Colors.purple]),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      alignment: Alignment.center,
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
