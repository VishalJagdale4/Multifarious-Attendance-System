import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project/Pages/Class/Student.dart';
import 'package:project/Pages/student/dashboard.dart';
import 'package:project/Pages/student/registerFace.dart';
import 'package:project/Pages/student/profile.dart';

class StudentA extends StatefulWidget {
  const StudentA({Key? key, required this.user, required this.student}) : super(key: key);

  final User user;
  final Student student;

  @override
  State<StudentA> createState() => _StudentState();
}

class _StudentState extends State<StudentA> {

  List<Widget> _children = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _children = [
      Dashboard(user: widget.user, student: widget.student,),
      RegisterFace(user: widget.user, student: widget.student,),
      Profile(user: widget.user, student: widget.student,)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor:  Colors.white70,
          selectedItemColor: Colors.white,
          backgroundColor: Colors.redAccent,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Attendance',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.tag_faces),
              label: 'Register',
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
