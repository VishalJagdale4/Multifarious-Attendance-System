import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:project/Pages/admin/Add Faculty/editFaculty.dart';
import 'package:project/Pages/admin/Add Faculty/newFaculty.dart';
import 'package:project/Pages/admin/Admin.dart';
import 'package:project/Pages/Class/Faculty.dart';

class Faculties extends StatefulWidget {
  const Faculties({Key? key, required this.department, required this.user}) : super(key: key);
  final String department;
  final User user;

  @override
  State<Faculties> createState() => _FacultiesState();
}

class _FacultiesState extends State<Faculties> {

  var db;

  @override
  void initState() {
    // TODO: implement initState
    db = FirebaseDatabase.instance.ref('Users/' + widget.department + '/Faculty');
    super.initState();
    fetchFaculties();
  }

  bool button = true;
  bool collected = false;
  List<Faculty> faculties = [];

  fetchFaculties() async {

    var list = await db.get();
    var facultiesList = list.value;

    final map = facultiesList as Map<dynamic, dynamic>;
    
    map.forEach((key, value) {
      final faculty = Faculty.fromMap(value);
      faculties.add(faculty);
    });

    setState(() {
      collected = true;
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

        appBar: AppBar(
            title: Text('Add Faculty'),
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
                  Text('Fetching Faculties...')
                ],
              ),
            ):
          Padding(
            padding: EdgeInsets.all(10),

            child: ListView.builder(
              shrinkWrap: true,
              itemCount: faculties.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index){
                Faculty faculty = faculties[index];

                return Card(
                    margin: EdgeInsets.all(10),
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(faculty.fid, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                          subtitle: Text(faculty.name),
                          trailing: Switch(
                            value: faculty.status,
                            onChanged: (status){
                              db.child(faculty.uid).update({'status':status.toString()});
                              setState(() {
                                faculty.status = status;
                              });
                            },
                          ),
                        ),
                        Text(faculty.email, style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                        Container(
                          padding: EdgeInsets.all(16.0),
                          child:Text('Department: ' + faculty.department, textAlign: TextAlign.center,),
                        ),
                        ElevatedButton(
                          onPressed: (){
                            Navigator.push(
                                context, MaterialPageRoute(builder: (_) => EditFaculty(faculty: faculty, user: widget.user,)));
                          },
                          child: Text('Edit', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                        )
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
            context, MaterialPageRoute(builder: (_) => AddNewFaculty(department: widget.department, user: widget.user,)));
          },
          icon: Icon(Icons.add),
          label: Text('Add', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),)
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      );
  }
}
