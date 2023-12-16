import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:project/Pages/admin/Add Faculty/faculties.dart';
import 'package:project/Pages/Class/Faculty.dart';

class EditFaculty extends StatefulWidget {
  const EditFaculty({Key? key, required this.faculty, required this.user}) : super(key: key);
  final Faculty faculty;
  final User user;

  @override
  State<EditFaculty> createState() => _EditFacultyState();
}

class _EditFacultyState extends State<EditFaculty> {

  @override
  void initState() {
    // TODO: implement initState
    db = FirebaseDatabase.instance.ref('Users/' + widget.faculty.department + '/Faculty');
    super.initState();
  }


  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController fidController = TextEditingController();
  TextEditingController departmentController = TextEditingController();

  var db;
  bool updating = false;

  Future<void> showAlert() async {

    showDialog(context: context,
        builder: (BuildContext context){
          return  AlertDialog(
            title: const Text("Information Updated!"),
            actions: [ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) =>
                    Faculties(department: widget.faculty.department,user: widget.user,))),
                child: const Text("Ok")
            )],
          );
        }
    );
  }

  Future<void> updateDetails(
      String name,
      String email,
      String phone,
      String dob,
      String fid,
      String department,)
  async {

    var location = db.child(widget.faculty.uid);

    name.length != 0?location.update({'name': name}):null;
    email.length != 0?location.update({'email': email}):null;
    phone.length != 0?location.update({'phone': phone}):null;
    dob.length != 0?location.update({'dob': dob}):null;
    fid.length != 0?location.update({'fid': fid}):null;
    department.length != 0?location.update({'department': department}):null;

    setState(() {
      updating = false;
      showAlert();
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
          title: Text('Edit Faculty'),
          backgroundColor: Colors.redAccent,
          centerTitle: true,
          leading: IconButton(
              onPressed: (){
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => Faculties(department: widget.faculty.department, user: widget.user,)));
                },
              icon: Icon(Icons.arrow_back)
          )
      ),

      body: updating?

      Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 10,),
            Text('Updating Deatails...')
          ],
        ),
      ):

      SingleChildScrollView(

        child: Container(
          margin: EdgeInsets.all(20),
          child: updating?
          Column(children: [CircularProgressIndicator(), SizedBox(height: 10,), Text('Updating...')],):
          Column(
            children: [
              SizedBox(
                height: 15,
              ),

              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                  hintText: widget.faculty.name
                ),
              ),

              SizedBox(
                height: 15,
              ),

              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                    hintText: widget.faculty.email
                ),
              ),

              SizedBox(
                height: 15,
              ),

              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Phone Number',
                    hintText: widget.faculty.phone
                ),
              ),

              SizedBox(
                height: 15,
              ),

              TextField(
                controller: dobController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'dob',
                    hintText: widget.faculty.dob
                ),
              ),

              SizedBox(
                height: 15,
              ),

              TextField(
                controller: fidController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Faculty ID',
                    hintText: widget.faculty.fid
                ),
              ),

              SizedBox(
                height: 15,
              ),

              TextField(
                controller: departmentController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Department',
                    hintText: widget.faculty.department
                ),
              ),

              SizedBox(height: 20,),

              Center(
                child: ElevatedButton(

                    onPressed: () {

                      setState(() {
                        updating = true;
                      });

                      updateDetails(
                        nameController.text,
                        emailController.text,
                        phoneController.text,
                        dobController.text,
                        fidController.text,
                        departmentController.text,
                      );
                    },
                    child: Text("Update", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10)
                      ),
                      fixedSize: Size(150, 50),
                    )
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}
