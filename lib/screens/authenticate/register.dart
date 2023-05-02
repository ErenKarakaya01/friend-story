import 'package:friend_story/models/user.dart';
import 'package:friend_story/services/auth.dart';
import 'package:friend_story/shared/constants.dart';
import 'package:friend_story/shared/loading.dart';
import 'package:flutter/material.dart';

import '../../services/database.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  const Register({super.key, required this.toggleView});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;
  TextEditingController dateController = TextEditingController();

  // text field state
  String _name = "";
  String _surname = "";
  String _username = "";
  String _email = '';
  String _password = '';
  DateTime _dateOfBirth = DateTime(1900);

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.blue[700],
            appBar: AppBar(
              backgroundColor: Colors.blue[400],
              elevation: 0.0,
              title: const Text('Register'),
              centerTitle: true,
            ),
            body: Stack(
              children: <Widget>[
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/background.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Center(
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50.0, vertical: 20.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.all(20),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                      width: 2, color: Colors.black)),
                              child: const Icon(
                                Icons.person,
                                color: Colors.black,
                                size: 80,
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            TextFormField(
                              decoration: textInputDecoration.copyWith(
                                  hintText: 'Name'),
                              validator: (val) =>
                                  val!.trim().isEmpty ? 'Enter a name' : null,
                              onChanged: (val) {
                                setState(() => _name = val.trim());
                              },
                            ),
                            const SizedBox(height: 20.0),
                            TextFormField(
                              decoration: textInputDecoration.copyWith(
                                  hintText: 'Surname'),
                              validator: (val) => val!.trim().isEmpty
                                  ? 'Enter a surname'
                                  : null,
                              onChanged: (val) {
                                setState(() => _surname = val.trim());
                              },
                            ),
                            const SizedBox(height: 20.0),
                            TextFormField(
                              decoration: textInputDecoration.copyWith(
                                  hintText: 'Username'),
                              validator: (val) => val!.trim().isEmpty
                                  ? 'Enter a username'
                                  : null,
                              onChanged: (val) {
                                setState(() => _username = val.trim());
                              },
                            ),
                            const SizedBox(height: 20.0),
                            TextFormField(
                              decoration: textInputDecoration.copyWith(
                                  hintText: 'Email'),
                              validator: (val) =>
                                  val!.trim().isEmpty ? 'Enter an email' : null,
                              onChanged: (val) {
                                setState(() => _email = val.trim());
                              },
                            ),
                            const SizedBox(height: 20.0),
                            TextFormField(
                              decoration: textInputDecoration.copyWith(
                                  hintText: 'Password'),
                              obscureText: true,
                              validator: (val) => val!.trim().length < 6
                                  ? 'Enter a password 6+ chars long'
                                  : null,
                              onChanged: (val) {
                                setState(() => _password = val.trim());
                              },
                            ),
                            const SizedBox(height: 20.0),
                            TextFormField(
                              decoration: textInputDecoration.copyWith(
                                  hintText: 'Confirm Password'),
                              obscureText: true,
                              validator: (val) => val!.trim() != _password
                                  ? "Passwords don't match"
                                  : null,
                            ),
                            const SizedBox(height: 20.0),
                            TextFormField(
                              controller: dateController,
                              decoration: textInputDecoration.copyWith(
                                  hintText: 'Date of Birth'),
                              validator: (val) => val!.trim().isEmpty
                                  ? "Enter a date of birth"
                                  : null,
                              onTap: () async {
                                DateTime? date = DateTime(1900);
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());

                                date = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100));

                                _dateOfBirth = date ?? _dateOfBirth;
                                dateController.text = date != null
                                    ? date.toString().substring(0, 10)
                                    : dateController.text;
                              },
                            ),
                            const SizedBox(height: 20.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                    child: const Text(
                                      "Sign In",
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    onPressed: () {
                                      widget.toggleView();
                                    }),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue[600],
                                    ),
                                    child: const Text(
                                      'Register',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        setState(() => loading = true);
                                        UserData? user = await DatabaseService()
                                            .getUserData(_username);

                                        if (user != null) {
                                          setState(() {
                                            loading = false;
                                            error = 'Username already exists';
                                          });
                                          return;
                                        }

                                        dynamic result = await _auth
                                            .registerWithEmailAndPassword(
                                                _email,
                                                _password,
                                                _name,
                                                _surname,
                                                _dateOfBirth,
                                                _username);
                                        if (result == null) {
                                          setState(() {
                                            loading = false;
                                            error =
                                                'Please supply a valid email';
                                          });
                                        }
                                      }
                                    }),
                              ],
                            ),
                            const SizedBox(height: 12.0),
                            Text(
                              error,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 14.0),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
