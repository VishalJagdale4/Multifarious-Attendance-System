import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:project/Pages/admin/Add%20Faculty/faculties.dart';
import 'package:project/Pages/home.dart';


class AddFaculty extends StatefulWidget {
  const AddFaculty({Key? key, required this.user}) : super(key: key);
  final User user;


  @override
  State<AddFaculty> createState() => _AddFacultyState();
}

class _AddFacultyState extends State<AddFaculty> {

  List<String> dept = [];

  var db = FirebaseDatabase.instance.ref('College/Department');

  fetchDepartment() async {

    var list = await db.get();
    var departmentList = list.value;

    final map = departmentList as Map<dynamic, dynamic>;

    setState(() {
      map.forEach((key, value) {dept.add(key);});
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchDepartment();
  }

  String? selectedDept;
  bool selected = false;

  @override
  Widget build(BuildContext context) {

    double height = (MediaQuery.of(context).size.height - 250)/4 - 100;

    return Scaffold(
      appBar: AppBar(
          title: Text('Faculties'),
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
                      selected = true;
                    });
                  },
                ),
              ),

              SizedBox(height: 20,),

              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Container(
                  height: 40,
                  width: 160,
                  decoration: BoxDecoration(
                      color: Colors.blue, borderRadius: BorderRadius.circular(20)),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
                    onPressed: () async{

                      selected?Navigator.push(
                          context, MaterialPageRoute(builder: (_) => Faculties(department: selectedDept!, user: widget.user,))):null;
                    },
                    child: Text(
                      'Add Faculty',
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
