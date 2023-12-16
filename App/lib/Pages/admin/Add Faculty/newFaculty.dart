import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:project/Pages/admin/Add Faculty/faculties.dart';

class AddNewFaculty extends StatefulWidget {
  const AddNewFaculty({Key? key, required this.department, required this.user}) : super(key: key);
  final String department;
  final User user;


  @override
  State<AddNewFaculty> createState() => _AddNewFacultyState();
}

class _AddNewFacultyState extends State<AddNewFaculty> {

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController fidController = TextEditingController();
  TextEditingController departmentController = TextEditingController();

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
      fid,
      department,
      )  async {

    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final db = FirebaseDatabase.instance.ref('Users/' + widget.department).child('Faculty');

    try{
      await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      User? user = firebaseAuth.currentUser;
      user!.updateDisplayName('faculty');

      db.child(user.uid).set({
        'uid':user.uid,
        'email':'$email',
        'name':'$name',
        'phone':'$password',
        'dob':'$dob',
        'fid':'$fid',
        'department':'$department',
        'status':'true',
        'profile_url':'https://firebasestorage.googleapis.com/v0/b/multifarious-attendance-system.appspot.com/o/Users%2Fuser.png?alt=media&token=860e666d-c53b-4899-9403-412dfa749701'
      });
      setState(() {
        updating = false;
        alreadyExist = false;
      });
      return true;
    }catch(signUpError) {
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
          title: Text('Create Faculty'),
          backgroundColor: Colors.redAccent,
          centerTitle: true,
          leading: IconButton(
              onPressed: (){
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => Faculties(department: widget.department, user: widget.user,)));},
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
            Text('Creating Faculty...')
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
                controller: fidController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Faculty ID',
                ),
              ),

              SizedBox(
                height: 15,
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
                          fidController.text,
                          widget.department
                      )?
                      Navigator.push(context, MaterialPageRoute(builder:  (_) => Faculties(department: widget.department, user: widget.user,))):null;
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
