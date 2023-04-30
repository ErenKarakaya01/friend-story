import 'package:flutter/material.dart';
import 'package:textfield_search/textfield_search.dart';

class AddStory extends StatefulWidget {
  const AddStory({super.key});

  @override
  State<AddStory> createState() => _AddStoryState();
}

class _AddStoryState extends State<AddStory> {
  static const label = "Some Label";
  static const dummyList = ['Item 1', 'Item 2', 'Item 3', 'Item 4', 'Item 5'];

  TextEditingController searchPersonController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    searchPersonController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Start listening to changes.
    searchPersonController.addListener(_printLatestValue);
  }

  _printLatestValue() {
    print("Textfield value: ${searchPersonController.text}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Story'),
      ),
      body: Center(
        child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
            child: TextFieldSearch(
              initialList: dummyList,
              label: label,
              controller: searchPersonController,
            )),
      ),
    );
  }
}
