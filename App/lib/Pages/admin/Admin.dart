import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/Pages/admin/Add Faculty/addFaculty.dart';
import 'package:project/Pages/admin/Add Student/addStudent.dart';
import 'package:project/Pages/admin/profile.dart';

class Admin extends StatefulWidget {
  const Admin({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {

  List<Widget> _children = [];

  @override
  void initState() {

    _children = [
      AddStudent(user: widget.user),
      AddFaculty(user: widget.user),
      Profile(user: widget.user),
    ];

    // TODO: implement initState
    super.initState();
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

              icon: Icon(Icons.face),
              label: 'Student',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.supervised_user_circle_outlined),
              label: 'Faculty',
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

