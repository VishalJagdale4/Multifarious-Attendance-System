import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/Pages/Class/Student.dart';
import 'package:project/Pages/home.dart';
import 'package:project/Pages/student/captureImages.dart';

class RegisterFace extends StatefulWidget {
  const RegisterFace({Key? key, required this.user, required this.student}) : super(key: key);

  final User user;
  final Student student;

  @override
  State<RegisterFace> createState() => _RegisterFaceState();
}

class _RegisterFaceState extends State<RegisterFace> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text('Upload Faces'),
          backgroundColor: Colors.redAccent,
          leading: IconButton(
              onPressed: (){
                setState(() {FirebaseAuth.instance.signOut();});
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => Home()));},
              icon: Icon(Icons.logout)
          )
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                color: Colors.black12
              ),
              child: Container(
                margin: EdgeInsets.all(10),
                child: Image.asset('assets/logo/photo.jpg'),
              ),
            ),
            SizedBox(height: 10,),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent
              ),
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) =>
                        CameraPre(user: widget.user, student: widget.student))
                );
              },
              icon: Icon(Icons.tag_faces),
              label: Text('Register Face'),
            ),
          ],
        ),
      )
    );
  }
}
