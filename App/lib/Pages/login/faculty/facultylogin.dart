import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:project/Pages/Class/Faculty.dart';
import 'package:project/Pages/faculty/Faculty.dart';
import 'package:project/Pages/login/faculty/forgetpassword.dart';

class FacultyLogin extends StatefulWidget {
  @override
  _FacultyLoginState createState() => _FacultyLoginState();
}

class _FacultyLoginState extends State<FacultyLogin> {

  final auth = FirebaseAuth.instance;
  User? user;
  bool logging = false;

  String uid = '';
  String name = '';
  String email = '';
  String phone = '';
  String department = '';
  String fid = '';
  bool status = false;
  String dob = '';
  String profile_url = '';

  List<String> dept = [
    'Computer Engineering',
    'Civil Engineering',
    'Electrical Engineering',
    'Information Technology',
    'Mechanical Engineering',
  ];

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  fetchUserData() async {
    Faculty? faculty;
    

    dept.forEach((element) async {
      
      var db = FirebaseDatabase.instance.ref('Users/' + element + '/Faculty');
      var list = await db.get();
      var facultyList = list.value;

      final faculties = facultyList as Map<dynamic, dynamic>;

      faculties.forEach((key, value) {
        if (key == user!.uid) {
          var data = value as Map<dynamic, dynamic>;
           setState(() {
             faculty = Faculty.fromMap(data);
             uid = faculty!.uid;
             name = faculty!.name;
             email = faculty!.email;
             phone = faculty!.phone;
             department = faculty!.department;
             fid = faculty!.fid;
             status = faculty!.status;
             dob = faculty!.dob;
             profile_url = faculty!.profile_url;

             Navigator.push(context, MaterialPageRoute(builder: (_) => FacultyA(user: user!, faculty:
             Faculty(uid: uid, name: name, email: email, phone: phone, department: department, fid: fid, status: status, dob: dob, profile_url: profile_url),)));
             logging = false;
           });
        }
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

      if(usr!.displayName == 'faculty')
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
        title: Text("Faculty Login"),
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