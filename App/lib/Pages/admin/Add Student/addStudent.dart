import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:project/Pages/admin/Add Student/students.dart';
import 'package:project/Pages/home.dart';


class AddStudent extends StatefulWidget {
  const AddStudent({Key? key, required this.user}) : super(key: key);
  final User user;


  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {

  var db = FirebaseDatabase.instance.ref('College/Department');

  List<String> dept = [];
  List<String> year = [];

  bool selected = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchDepartment();
  }

  fetchDepartment() async {

    var list = await db.get();
    var departmentList = list.value;

    final map = departmentList as Map<dynamic, dynamic>;

    setState(() {
      map.forEach((key, value) {dept.add(key);});
    });

  }

  fetchClass() async {

    var list = await db.get();
    var departmentList = list.value;

    final map = departmentList as Map<dynamic, dynamic>;

    setState(() {
      map.forEach((key, value) { (key.toString() != 'name' && key.toString() != 'did' && key.toString() != 'Course')?year.add(key):null;});
    });
  }


  String? selectedDept;
  String? selectedYear;

  @override
  Widget build(BuildContext context) {

    double height = (MediaQuery.of(context).size.height - 250)/4 - 100;

    return Scaffold(
      appBar: AppBar(
          title: Text('Students'),
          backgroundColor: Colors.redAccent,
          centerTitle: true,
          leading: IconButton(
              onPressed: (){

                setState(() {FirebaseAuth.instance.signOut();});

                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => Home()));
              },

              icon: Icon(Icons.logout)
          )
      ),

      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [

              SizedBox(height: height,),

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

              SizedBox(height: 60,),

              Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: Center(
                  child: Container(
                      child: Text('Department',
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
                  hint: Text('Select Department'),
                  items: dept.map((item) => DropdownMenuItem<String>(
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
                  value: selectedDept,
                  onChanged: (value) {
                    setState(() {
                      selectedDept = value as String;
                      db = FirebaseDatabase.instance.ref('College/Department/' + selectedDept!);
                      year = [];
                      fetchClass();
                    });
                  },
                ),
              ),

              SizedBox(height: 20,),

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
                      selectedYear = value as String;
                      selected = true;
                    });
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Container(
                  height: 40,
                  width: 180,
                  decoration: BoxDecoration(
                      color: Colors.blue, borderRadius: BorderRadius.circular(20)),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
                    onPressed: () async{

                      selected?Navigator.push(
                          context, MaterialPageRoute(builder: (_) =>
                          Students(batch: (selectedDept! + '/' + selectedYear!), user: widget.user))):null;
                    },
                    child: Text(
                      'Manage Student',
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
