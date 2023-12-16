import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/Pages/Class/Student.dart';
import 'package:project/Pages/home.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key, required this.user, required this.student}) : super(key: key);
  final User user;
  final Student student;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool edit = false;
  bool loaded = false;

  String default_profile = 'assets/logo/user.png';

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

  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  Future<void> pickDate(BuildContext context) async {
    DateTime selectedDate = DateTime.parse(dob.replaceAll('/','-'));
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        dob = picked.toString().split(' ')[0].replaceAll('-', '/');
      });
    }
  }

  uploadImage(XFile image) async {

    final _firebaseStorage = FirebaseStorage.instance;
    var db = FirebaseDatabase.instance.ref('Users/${widget.student.branch}/${widget.student.year}').child(widget.student.uid);

    if (image != null){

      File file = File(image.path);
      var storage = await _firebaseStorage.ref('Users/Student/' + widget.student.uid + '/profile');
      storage.putFile(file);

      var url = await storage.getDownloadURL();

      setState(() {
        profile_url = url;
        db.update({'profile_url': profile_url});
        loaded = true;
      });

    }
  }

  pickImageFile() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        uploadImage(pickedFile);
      });
    }
  }

  updateInfo() async{

    var db = FirebaseDatabase.instance.ref('Users/${widget.student.branch}/${widget.student.year}').child(widget.student.uid);

    if(emailController.text.isNotEmpty) {
      db.update({'email': emailController.text});
      widget.student.email = emailController.text;
    }

    if(phoneController.text.isNotEmpty) {
      db.update({'phone':phoneController.text});
      widget.student.phone = phoneController.text;
    }

    db.update({'dob':dob});
    widget.student.dob = dob;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {

      uid = widget.student.uid;
      name = widget.student.name;
      email = widget.student.email;
      phone = widget.student.phone;
      prn = widget.student.prn;
      program = widget.student.program;
      branch = widget.student.branch;
      semister = widget.student.semister;
      batch = widget.student.batch;
      year = widget.student.year;
      status = widget.student.status;
      sap_id = widget.student.sap_id;
      dob = widget.student.dob;
      profile_url = widget.student.profile_url;

      loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(

      appBar: AppBar(
          title: Text(edit?'Edit Profile':'Profile'),
          backgroundColor: Colors.redAccent,
          centerTitle: true,
          leading: IconButton(
              onPressed: (){
                setState(() {FirebaseAuth.instance.signOut();});
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => Home()));},
              icon: Icon(Icons.logout)
          )
      ),

      body: SingleChildScrollView(

        child: Container(

          child: Column(

            crossAxisAlignment: CrossAxisAlignment.center,

            children: [

              SizedBox(height: 20,),

              CircleAvatar(
                  backgroundColor: Colors.black12,
                  radius: 80,
                  child: CircleAvatar(
                    backgroundImage: AssetImage(default_profile),
                    radius: 75,
                    child:loaded?
                    CircleAvatar(
                      radius: 75,
                      backgroundImage: NetworkImage(profile_url),
                      child: edit?
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: Align(
                            alignment: Alignment.bottomRight,
                            child: TextButton(
                              onPressed: () {
                                setState(() => loaded = false);
                                pickImageFile();
                              },
                              child: Icon(Icons.edit, color: Colors.black),
                              style: TextButton.styleFrom(
                                shape: CircleBorder(),
                                padding: EdgeInsets.all(2),
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.red,
                              ),
                            )
                        ),
                      ):
                      null,
                    ):null,
                  )
              ),

              SizedBox(height: 15,),

              Text(
                '$name',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
              ),

              SizedBox(height: 20,),

              Divider(color: Colors.black12, thickness: 5,),

              SizedBox(height: 25,),

              Container(
                margin: EdgeInsets.only(left: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 130,
                          child: Text(
                            'Email - ',
                            style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                          ),
                        ),
                        edit?
                        SizedBox(
                          width: 200,
                          child: TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                              hintText: '$email',
                            ),
                          ),
                        ):
                        SizedBox(
                          width: width-150,
                          child: Text(
                            '$email',
                            style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                          ),
                        ),

                      ],
                    ),

                    SizedBox(height: 20,),

                    Row(
                      children: [
                        Container(
                          width: 130,
                          child: Text(
                            'Phone No - ',
                            style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                          ),
                        ),
                        edit?
                        SizedBox(
                          width: 200,
                          child: TextField(
                            controller: phoneController,
                            decoration: InputDecoration(
                              hintText: '$phone',
                            ),
                          ),
                        ):
                        Text(
                          '$phone',
                          style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),

                    SizedBox(height: 20,),

                    Row(
                      children: [
                        Container(
                          width: 130,
                          child: Text(
                            'DOB - ',
                            style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                          ),
                        ),
                        edit?
                        ElevatedButton.icon(
                            onPressed: () => pickDate(context),
                            icon: Icon(Icons.calendar_today_sharp),
                            label:Text(dob)
                        ):
                        Text(
                          '$dob',
                          style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),

                    SizedBox(height: 20,),

                    Row(
                      children: [
                        Container(
                          width: 130,
                          child: Text(
                            'PRN - ',
                            style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          '$prn',
                          style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),

                    SizedBox(height: 20,),

                    Row(
                      children: [
                        Container(
                          width: 130,
                          child: Text(
                            'SAP ID - ',
                            style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          '$sap_id',
                          style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),

                    SizedBox(height: 20,),

                    Row(
                      children: [
                        Container(
                          width: 130,
                          child: Text(
                            'Program - ',
                            style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          '$program',
                          style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),

                    SizedBox(height: 20,),

                    Row(
                      children: [
                        Container(
                          width: 130,
                          child: Text(
                            'Branch - ',
                            style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          '$branch',
                          style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),

                    SizedBox(height: 20,),

                    Row(
                      children: [
                        Container(
                          width: 130,
                          child: Text(
                            'Year - ',
                            style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          '$year',
                          style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),

                    SizedBox(height: 20,),

                    Row(
                      children: [
                        Container(
                          width: 130,
                          child: Text(
                            'Semister - ',
                            style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          '$semister',
                          style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),

                    SizedBox(height: 20,),

                    Row(
                      children: [
                        Container(
                          width: 130,
                          child: Text(
                            'Status - ',
                            style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          status?'Active':'Deactive',
                          style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20,),

              edit?
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: (){
                    setState(() {
                      edit = false;
                      loaded = true;
                      updateInfo();
                    } );
                  },
                  child: Text('Update', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),)
              ):
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                  ),
                  onPressed: (){
                    setState(() => edit = true);
                  },
                  icon: Icon(Icons.edit),
                  label:Text('Edit', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),)
              )

            ],
          ),
        ),
      ),
    );
  }
}
