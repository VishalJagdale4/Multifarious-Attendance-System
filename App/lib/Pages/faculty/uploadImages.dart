import 'dart:io';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:project/Pages/Class/Faculty.dart';
import 'package:project/Pages/faculty/Faculty.dart';
import 'package:project/Pages/faculty/captureImages.dart';

class PreviewImage extends StatefulWidget {
  const PreviewImage({Key? key, required this.images, required this.user, required this.faculty, required this.session}) : super(key: key);
  final User user;
  final List<File> images;
  final Faculty faculty;
  final String session;


  @override
  State<PreviewImage> createState() => _PreviewImageState();
}

class _PreviewImageState extends State<PreviewImage> {
  String base64Image = "";
  bool uploaded = false;
  bool processing = false;
  int count = 0;

  String formatDate(String dateString) {
    final date = DateTime.parse(dateString.replaceAll('/', '-'));
    final formattedDate = DateFormat('d MMMM yyyy').format(date);
    return formattedDate;
  }

  uploadImage(List<File> images) async {

    final _firebaseStorage = FirebaseStorage.instance;
    String date = formatDate(DateTime.now().toString().split(' ')[0]);

    for(File picture in images)
      if (picture != null){

        String path = picture.path;
        File file = File(path);

        var snapshot = await _firebaseStorage.ref(
            'Attendance Record/${widget.faculty.department}/${widget.session.split('/')[1]}/$date/${widget.session.split('/')[3]}/'
                + widget.session.split('/')[0] + '_' + widget.session.split('/')[2] + '_' + DateTime.now().toString()
        ).putFile(file);

        var uplaodStatus = snapshot.state;

        if(uplaodStatus.name == 'success')
          setState(() {
            count++;
          });
      } else {
        print('No Image Path Received');
      }

    var db = FirebaseDatabase.instance.ref('Jobs/Attendance/').child('${widget.faculty.department}_${widget.session.split('/')[1]}_${date}_${widget.session.split('/')[3]}');
    db.set({'remaining' : 'true'});

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
          title: const Text("Upload"),
          backgroundColor: Colors.redAccent,
          leading: IconButton(

              onPressed: (){
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => FacultyA(user: widget.user, faculty: widget.faculty)));},

              icon: Icon(Icons.arrow_back)

          )
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              widget.images.length == 0?

              Container(
                child: Text(
                  'No image present to upload... ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              )
                  :
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

              SizedBox(height: 10,),

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
              ):Container(),

              SizedBox(height: 10,),

              uploaded?ElevatedButton.icon(

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),

                onPressed: () {
                  // takeImage();
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => TakeAttendance(user: widget.user, faculty: widget.faculty, session: widget.session,)));
                },

                icon: Icon(
                    Icons.camera_alt_outlined
                ),

                label: Text(
                  'Capture More',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),

              ):Container(),

              Padding(

                padding: const EdgeInsets.only(top: 10.0),

                child: Container(

                  height: 40,
                  width: 250,

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
                ),
            ],
          ),
        ));
  }
}
