import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:project/Pages/Class/Faculty.dart';
import 'package:project/Pages/faculty/captureImages.dart';
import 'package:project/Pages/home.dart';


class Dashboard extends StatefulWidget {
  const Dashboard({Key? key, required this.user, required this.faculty}) : super(key: key);

  final User user;
  final Faculty faculty;


  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  List<String> session = [

    'Lecture',
    'Tutorial',
    'Practical',

  ];

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

  List<String> course = [];

  String? selectedSession;
  String? selectedYear;
  String? selectedBatch;
  String? selectedCourse;

  bool sSelected = false;
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
          title: Text('Attendance'),
          backgroundColor: Colors.redAccent,
          centerTitle: true,
          leading: IconButton(
              onPressed: (){
                setState(() {FirebaseAuth.instance.signOut();});
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => Home()));},
              icon: Icon(Icons.logout)
          )
      ),
      body: SingleChildScrollView(

        child: Center(

          child: Column(

            children: [

              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Center(
                  child: Container(
                      width: 200,
                      height: 150,
                      child: Image.asset('assets/logo/wide_logo.png')
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Center(
                  child: Container(
                      child: Text('Session',
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
                  hint: Text('Select Session'),
                  items: session.map((item) => DropdownMenuItem<String>(
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
                  value: selectedSession,
                  onChanged: (value) {
                    setState(() {
                      sSelected = true;
                      selectedSession = value as String;
                    });
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 25.0),
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
                  items: sSelected?year.map((item) => DropdownMenuItem<String>(
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
                  value: selectedYear,
                  onChanged: (value) {
                    setState(() {
                      ySelected = true;
                      course = [];
                      selectedYear = value as String;
                      fetchCourses();
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
                      selectedBatch = value as String;
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

              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Container(
                  height: 40,
                  width: 250,
                  decoration: BoxDecoration(
                      color: Colors.blue, borderRadius: BorderRadius.circular(20)),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
                    onPressed: () async{

                      cSelected?Navigator.push(
                          context, MaterialPageRoute(builder: (_) =>
                          TakeAttendance(user: widget.user,
                            faculty: widget.faculty, session: '$selectedSession/$selectedYear/$selectedBatch/$selectedCourse',),)):null;
                    },
                    child: Text(
                      'Take Attendance',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}
