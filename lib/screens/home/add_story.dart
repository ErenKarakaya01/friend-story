import 'package:flutter/material.dart';
import 'package:friend_story/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:textfield_search/textfield_search.dart';
import "package:friend_story/services/database.dart";
import "package:friend_story/services/auth.dart";

import '../../models/user.dart';
import '../../shared/constants.dart';

class AddStory extends StatefulWidget {
  final Function changePage;
  const AddStory({super.key, required this.changePage});

  @override
  State<AddStory> createState() => _AddStoryState();
}

class _AddStoryState extends State<AddStory> {
  final AuthService _auth = AuthService();

  final TextEditingController _searchPersonController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  String _username = "";
  DateTime _meetDate = DateTime(1900);
  String _story = "";

  String _error = "";
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Start listening to changes.
    _searchPersonController.addListener(() {
      setState(() {
        _username = _searchPersonController.text;
      });
    });
  }

  /* @override
  void dispose() {
    _searchPersonController.dispose();
    _dateController.dispose();
    super.dispose();
  } */

  Future<List> _updateDropdownList() async {
    try {
      if (_searchPersonController.text.isEmpty) {
        return [];
      }
      return await DatabaseService().getUsernames(_searchPersonController.text);
    } catch (e) {
      print(e.toString());
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModal>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Story'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              await _auth.signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFieldSearch(
                      controller: _searchPersonController,
                      label: "Friend you want to add story",
                      future: _updateDropdownList,
                      minStringLength: 0,
                    ),
                    TextFormField(
                      controller: _dateController,
                      decoration:
                          const InputDecoration(labelText: "The date you met"),
                      validator: (val) =>
                          val!.trim().isEmpty ? "Enter a date of birth" : null,
                      onTap: () async {
                        DateTime? date = DateTime(1900);
                        FocusScope.of(context).requestFocus(FocusNode());

                        date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100));

                        _meetDate = date ?? _meetDate;
                        _dateController.text = date != null
                            ? date.toString().substring(0, 10)
                            : _dateController.text;
                      },
                    ),
                    const SizedBox(height: 40),
                    TextFormField(
                      minLines: 14,
                      maxLines: 18,
                      maxLength: 500,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        hintText: 'Enter your story...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                      ),
                      validator: (val) =>
                          val!.trim().isEmpty ? 'Enter a story' : null,
                      onChanged: (val) {
                        setState(() => _story = val.trim());
                      },
                    ),
                    const SizedBox(height: 10),

                    // Add story button
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          UserData? userData =
                              await DatabaseService().getUserData(_username);

                          if (userData == null) {
                            setState(() {
                              _error = "User not found";
                            });
                            return;
                          }

                          dynamic result = await DatabaseService(uid: user.uid)
                              .addStory(userData.uid, _meetDate, _story);
                          if (result == null) {
                            setState(() {
                              _error = "Something went wrong";
                            });
                          } else {
                            if (context.mounted) {
                              setState(() {
                                _error = "";
                                widget.changePage(1);
                              });
                            }
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size.fromHeight(50.0)),
                      child: const Text('Add Story'),
                    ),

                    const SizedBox(height: 12.0),
                    Text(
                      _error,
                      style: const TextStyle(color: Colors.red, fontSize: 14.0),
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
