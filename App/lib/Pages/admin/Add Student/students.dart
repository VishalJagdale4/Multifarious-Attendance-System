import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:project/Pages/admin/Add%20Student/verify.dart';
import 'package:project/Pages/admin/Admin.dart';
import 'package:project/Pages/Class/Student.dart';
import 'package:project/Pages/admin/Add Student/editStudent.dart';
import 'package:project/Pages/admin/Add Student/newStudent.dart';

class Students extends StatefulWidget {
  const Students({Key? key, required this.batch, required this.user}) : super(key: key);
  final String batch;
  final User user;


  @override
  State<Students> createState() => _StudentsState();
}

class _StudentsState extends State<Students> {

  var db;

  @override
  void initState() {
    db = FirebaseDatabase.instance.ref('Users/' + widget.batch.split('/')[0]).child(widget.batch.split('/')[1]);
    // TODO: implement initState
    super.initState();
    fetchStudents();
  }

  bool button = true;
  bool collected = false;
  List<Student> students = [];
  List<bool> verified = [];

  fetchStudents() async {

    var list = await db.get();
    var studentsList = list.value;
    final map = studentsList as Map<dynamic, dynamic>;

    map.forEach((key, value) {
      final student = Student.fromMap(value);
      students.add(student);
    });

    setState(() {
      collected = true;
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

        appBar: AppBar(
            title: Text('Manage Student'),
            backgroundColor: Colors.redAccent,
            centerTitle: true,
            leading: IconButton(
                onPressed: (){
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => Admin(user: widget.user,)));},
                icon: Icon(Icons.arrow_back)
            )
        ),

        body: !collected?
            Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10,),
                  Text('Fetching Students...')
                ],
              ),
            ):
          Padding(
            padding: EdgeInsets.all(10),

            child: ListView.builder(
              shrinkWrap: true,
              itemCount: students.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index){
                Student student = students[index];

                return Card(
                    margin: EdgeInsets.all(10),
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(student.prn, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                          subtitle: Text(student.name),
                          trailing: Switch(
                            value: student.status,
                            onChanged: (status){
                              db.child(student.uid).update({'status':status.toString()});
                              setState(() {
                                student.status = status;
                              });
                            },
                          ),
                        ),
                        Text(student.email, style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                        Container(
                          padding: EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Program: ' + student.program),
                              SizedBox(width: 20,),
                              Container(width: 80, child: Text('Branch: '  + student.branch),),
                              SizedBox(width: 20,),
                              Container(width: 80, child: Text('Year: '  + student.year),),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [

                            ElevatedButton(
                              onPressed: (){
                                Navigator.push(
                                    context, MaterialPageRoute(builder: (_) =>
                                    EditStudent(student: student, batch: widget.batch, user: widget.user)));
                              },
                              child: Text('Edit', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                            ),

                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange
                              ),
                              onPressed: (){
                                Navigator.push(
                                    context, MaterialPageRoute(builder: (_) =>
                                    VerifyPicture(student: student, batch: widget.batch, user: widget.user)));
                              },
                              child: Text('Verify', style:
                              TextStyle(fontWeight: FontWeight.bold,), textAlign: TextAlign.center,),
                            )

                          ],
                        ),
                      ],
                    )
                );

              },
            ),

        ),

      floatingActionButton: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent
        ),
          onPressed: (){
            Navigator.push(
            context, MaterialPageRoute(builder: (_) => AddNewStudent(batch: widget.batch, user: widget.user)));
          },
          icon: Icon(Icons.add),
          label: Text('Add', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),)
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      );
  }
}
