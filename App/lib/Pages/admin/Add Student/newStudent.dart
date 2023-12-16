import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project/Pages/admin/Add Student/students.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AddNewStudent extends StatefulWidget {
  const AddNewStudent({Key? key, required this.batch, required this.user}) : super(key: key);
  final String batch;
  final User user;

  @override
  State<AddNewStudent> createState() => _AddNewStudentState();
}

class _AddNewStudentState extends State<AddNewStudent> {

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

  bool alreadyExist = false;
  bool updating = false;

  Future<void> showAlert() async {

    showDialog(context: context,
        builder: (BuildContext context){
          return  AlertDialog(
            title: const Text("Email Already In Use"),
            content: const Text("Please try different Email ID\nOR\nCheck phone number",),
            actions: [ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Ok")
            )],
          );
        }
    );
  }

  Future<bool> createUser(
      name,
      email,
      password,
      dob,
      prn,
      sapid,
      program,
      branch,
      semister,
      batch,
      year
      ) async {

    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final db = FirebaseDatabase.instance.ref('Users/' + widget.batch);

    try{
      await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      User? user = firebaseAuth.currentUser;
      user!.updateDisplayName('student');

      db.child(user.uid).set({
        'uid':user.uid,
        'email':'$email',
        'name':'$name',
        'phone':'$password',
        'dob':'$dob',
        'prn':'$prn',
        'sap_id':'$sapid',
        'program':'$program',
        'branch':widget.batch.split('/')[0],
        'semister':'$semister',
        'batch':'$batch',
        'year':widget.batch.split('/')[1],
        'status':'true',
        'profile_url':'https://firebasestorage.googleapis.com/v0/b/multifarious-attendance-system.appspot.com/o/Users%2Fuser.png?alt=media&token=860e666d-c53b-4899-9403-412dfa749701'
      });
      setState(() {
        updating = false;
        alreadyExist = false;
      });
      return true;
    }catch(signUpError) {
      print(signUpError);
      showAlert();
      setState(() {
        updating = false;
        alreadyExist = true;
      });
      return false;
    }
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
            Text('Creating Student...')
          ],
        ),
      ):

      SingleChildScrollView(

        child: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),

              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                ),
              ),

              SizedBox(
                height: 15,
              ),

              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  enabledBorder: alreadyExist?OutlineInputBorder(borderSide: BorderSide(color: Colors.red)):null,
                  focusedBorder: alreadyExist?OutlineInputBorder(borderSide: BorderSide(color: Colors.red)):null,
                  labelText: 'Email',
                ),
              ),

              SizedBox(
                height: 15,
              ),

              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  enabledBorder: alreadyExist?OutlineInputBorder(borderSide: BorderSide(color: Colors.red)):null,
                  focusedBorder: alreadyExist?OutlineInputBorder(borderSide: BorderSide(color: Colors.red)):null,
                  labelText: 'Phone Number',
                ),
              ),

              SizedBox(
                height: 15,
              ),

              TextField(
                controller: dobController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Date of Birth (Ex.2001/12/24)',
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
                ),
              ),

              SizedBox(
                height: 15,
              ),

              TextField(
                controller: programController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Program',
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
                      controller: semisterController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Semister',
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
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20,),

              Center(
                child: ElevatedButton(
                    onPressed: () async {

                      setState(() {
                        updating = true;
                      });

                      await createUser(
                          nameController.text,
                          emailController.text,
                          phoneController.text,
                          dobController.text,
                          prnController.text,
                          sapidController.text,
                          programController.text,
                          widget.batch.split('/')[0],
                          semisterController.text,
                          batchController.text,
                          widget.batch.split('/')[1]
                      )?
                      Navigator.push(context, MaterialPageRoute(builder:  (_) =>
                          Students(batch: widget.batch, user: widget.user))):null;
                    },
                    child: Text("Confirm", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
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
