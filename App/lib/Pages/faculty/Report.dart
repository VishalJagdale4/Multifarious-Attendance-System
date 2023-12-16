import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:project/Pages/Class/Faculty.dart';
import 'package:project/Pages/faculty/dashboard.dart';
import 'package:intl/intl.dart';
import 'package:project/Pages/faculty/downloadReport.dart';

class Report extends StatefulWidget {
  const Report({Key? key, required this.user, required this.faculty}) : super(key: key);

  final User user;
  final Faculty faculty;

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {

  List<String> year = [

    'First Year',
    'Second Year',
    'Third Year',
    'Final Year'

  ];

  List<String> batch = [

    'All',
    'T1',
    'T2',
    'B1',
    'B2',
    'B3',
    'B4'

  ];

  List<String> course = ['All'];

  String? selectedYear;
  String? selectedBatch;
  String? selectedCourse;

  bool ySelected = false;
  bool bSelected = false;
  bool cSelected = false;

  fetchCourses() async {

    var db = FirebaseDatabase.instance.ref('College/Department/${widget.faculty.department}/$selectedYear/Course');

    var list = await db.get();
    var coursesList = list.value;

    var map = coursesList as Map<dynamic, dynamic>;

    setState(() {
      map.forEach((key, value) {course.add(key);});
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Report Generation'),
          backgroundColor: Colors.redAccent,
          centerTitle: true,
          leading: IconButton(
              onPressed: (){
                setState(() {FirebaseAuth.instance.signOut();});
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => Dashboard(user: widget.user, faculty: widget.faculty,)));},
              icon: Icon(Icons.arrow_back)
          )
      ),

      body: Center(
        child: Column(
        children: [

          SizedBox(height: 50,),

          SizedBox(
            height: 200,
            child: Center(child:Image.asset('assets/logo/report_icon.png')),
          ),

          SizedBox(height: 20,),

          Container(height: 40,
            child: Text('Attendace Report', style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),

          ),

          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Center(
              child: Container(
                  child: Text('Year',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                    ),
                  )
              ),
            ),
          ),

          SizedBox(

            width: 300,

            child: DropdownButton(
              isExpanded: true,
              hint: Text('Select Year'),
              items: year.map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ))
                  .toList(),
              value: selectedYear,
              onChanged: (value) {
                setState(() {
                  ySelected = true;
                  selectedYear = value as String;
                });
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: Center(
              child: Container(
                  child: Text('Batch',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                    ),
                  )
              ),
            ),
          ),

          SizedBox(

            width: 300,

            child: DropdownButton(

              // dropdownColor: Colors.redAccent.shade100,
              isExpanded: true,
              hint: Text('Select Batch'),
              items: ySelected?batch.map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ))
                  .toList():null,
              value: selectedBatch,
              onChanged: (value) {
                setState(() {
                  bSelected = true;
                  course = ['All'];
                  selectedBatch = value as String;
                  fetchCourses();
                });
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: Center(
              child: Container(
                  child: Text('Course',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                    ),
                  )
              ),
            ),
          ),

          SizedBox(
            width: 300,
            child: DropdownButton(
              // dropdownColor: Colors.redAccent.shade100,
              isExpanded: true,
              hint: Text('Select Course'),
              items: bSelected?course.map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ))
                  .toList():null,
              value: selectedCourse,
              onChanged: (value) {
                setState(() {
                  cSelected = true;
                  selectedCourse = value as String;
                });
              },
            ),
          ),

          SizedBox(height: 30,),

          ElevatedButton(
            onPressed: () {
              cSelected?
              Navigator.push(
                      context, MaterialPageRoute(builder: (_) => DownloadReport(
                  user: widget.user, faculty: widget.faculty, use: '${selectedCourse}_${selectedYear}'))):
                  null;
            },
            child: const Text('Report', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent,),
          ),

        ],
        ),
      )
    );
  }
}