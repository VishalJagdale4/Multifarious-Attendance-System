import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/Pages/Class/Faculty.dart';
import 'package:project/Pages/faculty/dashboard.dart';
import 'package:project/Pages/faculty/profile.dart';
import 'package:project/Pages/faculty/Report.dart';

class FacultyA extends StatefulWidget {
  const FacultyA({Key? key, required this.user, required this.faculty}) : super(key: key);
  final User user;
  final Faculty faculty;

  @override
  State<FacultyA> createState() => _FacultyState();
}

class _FacultyState extends State<FacultyA> {
  List<Widget> _children = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _children = [
      Dashboard(user: widget.user, faculty: widget.faculty,),
      Report(user: widget.user, faculty: widget.faculty,),
      Profile(user: widget.user, faculty: widget.faculty,),
    ];
  }

  @override
  int _selectedIndex = 0;
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor:  Colors.white70,
          selectedItemColor: Colors.white,
          backgroundColor: Colors.redAccent,

          items: const <BottomNavigationBarItem>[

            //New
            BottomNavigationBarItem(

              icon: Icon(Icons.list),
              label: 'Attendance',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.assignment),
              label: 'Report',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),

          ],

          currentIndex: _selectedIndex,
          onTap: _onItemTapped
      ),
    );
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

