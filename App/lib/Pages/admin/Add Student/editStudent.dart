import 'package:flutter/material.dart';
import 'package:project/Pages/Class/Student.dart';
import 'package:project/Pages/admin/Add Student/students.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class EditStudent extends StatefulWidget {
  const EditStudent({Key? key, required this.student, required this.batch, required this.user}) : super(key: key);
  final Student student;
  final String batch;
  final User user;


  @override
  State<EditStudent> createState() => _EditStudentState();
}

class _EditStudentState extends State<EditStudent> {

  User? newStudentUser;
  Student? student;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController prnController = TextEditingController();
  TextEditingController sapidController = TextEditingController();
  TextEditingController programController = TextEditingController();
  TextEditingController branchController = TextEditingController();
  TextEditingController semisterController = TextEditingController();
  TextEditingController batchController = TextEditingController();
  TextEditingController yearController = TextEditingController();

  var db;
  bool updating = false;

  Future<void> showAlert() async {

    showDialog(context: context,
        builder: (BuildContext context){
          return  AlertDialog(
            title: const Text("Information Updated!"),
            actions: [ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) =>
                    Students(batch: widget.batch, user: widget.user))),
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
      String prn,
      String sapid,
      String program,
      String branch,
      String semister,
      String batch,
      String year)
  async {

    setState(() {
      updating = true;
    });

    var location = db.child(widget.student.uid);

    name.length != 0?location.update({'name': name}):null;
    email.length != 0?location.update({'email': email}):null;
    phone.length != 0?location.update({'phone': phone}):null;
    dob.length != 0?location.update({'dob': dob}):null;
    prn.length != 0?location.update({'prn': prn}):null;
    sapid.length != 0?location.update({'sap_id': sapid}):null;
    program.length != 0?location.update({'program': program}):null;
    branch.length != 0?location.update({'branch': branch}):null;
    semister.length != 0?location.update({'semister': semister}):null;
    batch.length != 0?location.update({'batch': batch}):null;
    year.length != 0?location.update({'year': year}):null;

    setState(() {
      updating = false;
      showAlert();
    });

  }

  @override
  void initState() {
    db = FirebaseDatabase.instance.ref('Users/'+ widget.batch);
    print(widget.batch);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
          title: Text('Create Student'),
          backgroundColor: Colors.redAccent,
          centerTitle: true,
          leading: IconButton(
              onPressed: (){
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => Students(batch: widget.batch, user: widget.user)));},
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
          Column(children: [CircularProgressIndicator(), Text('Updating...')],):
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
                  hintText: widget.student.name
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
                    hintText: widget.student.email
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
                    hintText: widget.student.phone
                ),
              ),

              SizedBox(
                height: 15,
              ),

              TextField(
                controller: dobController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'DOB',
                    hintText: widget.student.dob
                ),
              ),

              SizedBox(
                height: 15,
              ),

              TextField(
                controller: prnController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enrollment Number',
                    hintText: widget.student.prn
                ),
              ),

              SizedBox(
                height: 15,
              ),

              TextField(
                controller: sapidController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'SAP ID',
                    hintText: widget.student.sap_id
                ),
              ),

              SizedBox(
                height: 15,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: TextField(
                      controller: programController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Program',
                          hintText: widget.student.program
                      ),
                    ),
                  ),

                  SizedBox(width: 15,),

                  Flexible(
                    child: TextField(
                      controller: yearController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Year',
                          hintText: widget.student.year
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: 15,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: TextField(
                      controller: semisterController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Semister',
                          hintText: widget.student.semister
                      ),
                    ),
                  ),

                  SizedBox(width: 15,),

                  Flexible(
                    child: TextField(
                      controller: batchController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Batch',
                          hintText: widget.student.batch
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 15,),

              TextField(
                controller: branchController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Branch',
                    hintText: widget.student.branch
                ),
              ),

              SizedBox(height: 20,),

              Center(
                child: ElevatedButton(
                    onPressed: () => updateDetails(
                      nameController.text,
                      emailController.text,
                      phoneController.text,
                      dobController.text,
                      prnController.text,
                      sapidController.text,
                      programController.text,
                      branchController.text,
                      semisterController.text,
                      batchController.text,
                      yearController.text
                    ),
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
