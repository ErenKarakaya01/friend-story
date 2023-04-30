import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import "add_story.dart";

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  SharedAxisTransitionType _transitionType = SharedAxisTransitionType.horizontal;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    AddStory(),
    Scaffold(
      body: Center(
        child: Text(
          'Index 1: Business',
          style: optionStyle,
        ),
      ),
    ),
    AddStory(),
    Scaffold(
      body: Center(
        child: Text(
          'Index 3: Settings',
          style: optionStyle,
        ),
      ),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _transitionType = _selectedIndex <= index
          ? SharedAxisTransitionType.horizontal
          : SharedAxisTransitionType.horizontal;
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageTransitionSwitcher(
        transitionBuilder: (child, primaryAnimation, secondaryAnimation) =>
            SharedAxisTransition(
          animation: primaryAnimation,
          secondaryAnimation: secondaryAnimation,
          transitionType: SharedAxisTransitionType.horizontal,
          child: child,
        ),
        child: _widgetOptions[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
            backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
            backgroundColor: Colors.pink,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
