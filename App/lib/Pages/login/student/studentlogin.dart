import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:project/Pages/Class/Student.dart';
import 'package:project/Pages/login/student/forgetpassword.dart';
import 'package:project/Pages/student/Student.dart';

class StudentLogin extends StatefulWidget {
  @override
  _StudentLoginState createState() => _StudentLoginState();
}

class _StudentLoginState extends State<StudentLogin> {

  final auth = FirebaseAuth.instance;
  User? user;
  bool logging = false;

  String uid = '';
  String name = '';
  String email = '';
  String phone = '';
  String prn = '';
  String program = '';
  String branch = '';
  String semister = '';
  String batch = '';
  String year = '';
  bool status = false;
  String sap_id = '';
  String dob = '';
  String profile_url = '';

  List<String> dept = [
    'Computer Engineering',
    'Civil Engineering',
    'Electrical Engineering',
    'Information Technology',
    'Mechanical Engineering',
  ];

  List<String> cls = [
    'First Year',
    'Second Year',
    'Third Year',
    'Final Year',
  ];

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  fetchUserData() async {
    Student? student;


    dept.forEach((department) async {

      cls.forEach((cl) async {

        var db = FirebaseDatabase.instance.ref('Users/$department/$cl');
        var list = await db.get();
        var studentList = list.value;

        final students = studentList as Map<dynamic, dynamic>;

        students.forEach((key, value) {
          if (key == user!.uid) {
            var data = value as Map<dynamic, dynamic>;
            setState(() {
              student = Student.fromMap(data);

              uid = student!.uid;
              name = student!.name;
              email = student!.email;
              phone = student!.phone;
              prn = student!.prn;
              program = student!.program;
              branch = student!.branch;
              semister = student!.semister;
              batch = student!.batch;
              year = student!.year;
              status = student!.status;
              sap_id = student!.sap_id;
              dob = student!.dob;
              profile_url = student!.profile_url;

              Navigator.push(context, MaterialPageRoute(builder: (_) =>
              StudentA(user: user!, student:
              Student(uid: uid, name: name,
                  email: email, phone: phone,
                  prn: prn, program: program,
                  branch: branch, semister: semister,
                  batch: batch, year: year,
                  status: status, dob: dob,
                  sap_id: sap_id, profile_url: profile_url),)
              ));
              logging = false;
            });
          }
        });

      });

    });
  }

  Future<void> showAlert() async {

    showDialog(context: context,
        builder: (BuildContext context){
          return  AlertDialog(
            title: const Text("Invalid Email/Password"),
            content: const Text("Credentials which you enterd does not match with our records"),
            actions: [ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Ok")
            )],
          );
        }
    );
  }

  Future<User?> login({required String email, required String password}) async {
    User? usr;
    try {

      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      usr = userCredential.user;

      if(usr!.displayName == 'student')
        return usr;
      else {
        FirebaseAuth.instance.signOut();
        return null;
      }

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided.');
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon:Icon(Icons.arrow_back_ios),
        ),
        title: Text("Student Login"),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: SingleChildScrollView(

        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                    width: 300,
                    height: 200,
                    child: Image.asset('assets/logo/wide_logo.png')
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',),
              ),
            ),

            SizedBox(
              height: 20,
            ),

            TextButton(
              onPressed: (){
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => ForgetPassword()));
              },
              child: Text(
                'Forgot Password',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
            ),

            SizedBox(
              height: 20,
            ),

            logging?
            CircularProgressIndicator():
            Container(
              height: 40,
              width: 200,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
                onPressed: () async{
                  setState(() => logging = true);
                  user = await login(email:emailController.text, password:passwordController.text);
                  if(user == null){
                    setState(() => logging = false);
                    showAlert();
                  }else{
                    await fetchUserData();
                  }
                },
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }
}