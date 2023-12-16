import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:project/Pages/Class/Student.dart';
import 'package:project/Pages/student/Student.dart';

class UploadImages extends StatefulWidget {
  const UploadImages({Key? key, required this.user, required this.student, required this.images}) : super(key: key);

  final User user;
  final Student student;
  final List<File> images;

  @override
  State<UploadImages> createState() => _UploadImagesState();
}

class _UploadImagesState extends State<UploadImages> {

  bool uploaded = false;
  bool processing = false;
  int count = 0;

  uploadImage(List<File> images) async {

    final _firebaseStorage = FirebaseStorage.instance;

    for(File picture in images)
      if (picture != null){

        String path = picture.path;

        File file = File(path);

        var snapshot = await _firebaseStorage.ref(
          'Student Faces/${widget.student.branch}/${widget.student.year}/${widget.student.uid}/${DateTime.now()}.jpg'
        ).putFile(file);

        var uplaodStatus = snapshot.state;

        var db = FirebaseDatabase.instance.ref('Jobs/Update Database/${widget.student.branch}_${widget.student.year}').child(widget.student.uid);
        db.set({
          'remaining' : 'true',
          'of' : '${widget.student.branch}_${widget.student.year}'
        });


        if(uplaodStatus.name == 'success')
          setState(() {
            count++;
          });
      } else {
        print('No Image Path Received');
      }
    setState(() {
      uploaded = true;
      processing = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Upload Faces'),
        backgroundColor: Colors.redAccent,
        leading: IconButton(
            onPressed: (){
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => StudentA(user: widget.user, student: widget.student,)));},
            icon: Icon(Icons.arrow_back)
        )
      ),

      body: Column(

        mainAxisAlignment: MainAxisAlignment.center,

        children: [

          widget.images.length == 0?

          Container(
            child: Text(
              'No image present... ',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ):

          Expanded(
            child: GridView.builder(
              itemCount: widget.images.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              itemBuilder: (BuildContext context, int index) {
                return Image.file(widget.images[index]);
              },
            ),
          ),

          processing & !uploaded?Center(

            child: Column(
              children: [
                Text(
                  'Uploading ' + '$count/' + (widget.images.length).toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.green),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10,),
                LinearProgressIndicator()

              ],
            ),
          ):

          uploaded?TextButton.icon(
              onPressed: (){},
              icon: Icon(Icons.check, color: Colors.green,),
              label: Text(
                'Uploaded',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.green),
                textAlign: TextAlign.center,
              ),
          ):Container(),

          widget.images.length == 0 || uploaded?

          Container():

          Padding(

            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),

            child: Container(

              height: 40,
              width: 200,

              decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20)
              ),

              child:  ElevatedButton.icon(

                style: ElevatedButton.styleFrom(
                  backgroundColor:uploaded?
                  Colors.green:
                  processing?
                  Colors.orange:
                  Colors.blue,
                ),

                onPressed: () {
                  uploaded?print('Uploaded'):processing?print('Uploading'):{print('Upload'), uploadImage(widget.images)};
                  setState(() {
                    processing = true;
                  });

                },

                icon: uploaded?Icon(Icons.check):processing?Icon(Icons.rotate_left):Icon(Icons.upload),

                label: Text(
                  uploaded?'Uploaded':processing?'Uploading...':'Upload',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),

              ),

            ),
          )

        ]
      ),
    );
  }
}

