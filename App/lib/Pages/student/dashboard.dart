import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_calendar/horizontal_calendar.dart';
import 'package:project/Pages/Class/Lecture.dart';
import 'package:project/Pages/Class/Student.dart';
import 'package:project/Pages/home.dart';
import 'package:intl/intl.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key, required this.user, required this.student}) : super(key: key);
  final User user;
  final Student student;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  List<Lecture> lectures = [];
  DateTime date = DateTime.now();
  String? dateString = '';
  DateFormat f = DateFormat('dd MMMM yyyy');
  bool haveData = false;

  fetchLecture() async{
    var db = FirebaseDatabase.instance.ref('Attendance/${widget.student.branch}/${widget.student.year}/$dateString');
    var list = await db.get();
    var lecturesList = list.value;

    setState(() {
      if(lecturesList == null)
        haveData = false;
      else
        haveData = true;
    });

    var map = lecturesList as Map<dynamic, dynamic>;

    map.forEach((key, value) {

      setState(() {
        Lecture lecture = Lecture.fromMap(value);
        lectures.add(lecture);
      });

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dateString = f.format(date);
    fetchLecture();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text('Student'),
          backgroundColor: Colors.redAccent,
          leading: IconButton(
              onPressed: (){
                setState(() {FirebaseAuth.instance.signOut();});
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => Home()));},
              icon: Icon(Icons.logout)
          )
      ),
      body: SingleChildScrollView(

        child: Column(
          children: [

            SizedBox(height: 10,),

            HorizontalCalendar(
              initialDate: DateTime.parse('1900-01-01'),
              date: date,
              textColor: Colors.black45,
              backgroundColor: Colors.white,
              selectedColor: Colors.blue,
              onDateSelected: (selectedDate) {
                setState(() {
                  date = DateTime.parse(selectedDate.toString());
                  dateString = f.format(date);
                  lectures = [];
                  fetchLecture();
                });
              },
            ),

            SizedBox(
              height: 20,
            ),

            haveData?ListView.builder(

                shrinkWrap: true,
                itemCount: lectures.length,
                scrollDirection: Axis.vertical,

                itemBuilder: (BuildContext context,int index){

                  Lecture lecture = lectures[index];
                  bool present = lecture.present.contains(widget.user.uid);

                  return Card(
                      margin: EdgeInsets.all(10),
                      color: present?Colors.green:Colors.red.shade300,
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(lecture.name, style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),),
                            subtitle: Container(
                              margin: EdgeInsets.all(4),
                              child: Row(
                                  children:[
                                    Icon(Icons.watch_later_outlined, color: Colors.white, size: 20,),
                                    SizedBox(width: 5,),
                                    Text(lecture.duration, style: TextStyle(color: Colors.white),)
                                  ]
                              ),
                            ),
                            trailing: Text(
                              present?'Present':'Absent',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      )
                  );
                }
            ):
            Container(
              child: Center(

                child: Text('No data found!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),

              ),
            ),
          ],
        ),
      ),
    );
  }
}