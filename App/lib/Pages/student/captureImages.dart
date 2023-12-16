import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:project/Pages/Class/Student.dart';
import 'package:project/Pages/student/registerFace.dart';
import 'package:project/Pages/student/uploadImages.dart';

class CameraPre extends StatefulWidget {
  const CameraPre({Key? key, required this.user, required this.student}) : super(key: key);

  final User user;
  final Student student;

  @override
  State<CameraPre> createState() => _CameraPreState();
}

class _CameraPreState extends State<CameraPre> {

  List<CameraDescription>? cameras;
  CameraController? controller;
  XFile? image;
  bool captured = false;
  File? picture;
  List<File> images = [];

  @override
  void initState() {
    loadCamera();
    super.initState();
    print('Camera Initiated');
  }

  loadCamera() async {
    print('Loading Camera...');
    cameras = await availableCameras();
    print(cameras);
    if(cameras != null){
      controller = CameraController(cameras!.last, ResolutionPreset.max,);
      controller!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {
          controller!.setFlashMode(FlashMode.off);
        });
      });
    }else{
      print("No any camera found");
    }
  }

  @override
  Widget build(BuildContext context) {

    return  captured?Scaffold(
      appBar: AppBar(
        title: Text('Confirm Image'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.redAccent,
        actions: <Widget>[

          IconButton(
              onPressed: (){
                setState(() {
                  captured = false;
                  controller!.resumePreview();
                });
              },
              icon: Icon(Icons.check)
          ),
          IconButton(
              onPressed: (){
                setState(() {
                  captured = false;
                  controller!.resumePreview();
                  images.remove(images.last);
                });
              },
              icon: Icon(Icons.close)
          )

        ],
      ),

      body: Container(
        child: PhotoView(
          maxScale:  PhotoViewComputedScale.contained * 10,
          minScale:  PhotoViewComputedScale.contained * 1,
          imageProvider: FileImage(images.last),
        ),
      ),
    ):Scaffold(
      appBar: AppBar(
          title: Text('Capture Image'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.push( context, MaterialPageRoute(builder: (_) =>
                      UploadImages(user: widget.user, student: widget.student, images: images)));
                  controller!.pausePreview();
                },
                child: Text('Done', style: TextStyle(color: Colors.white),))
          ],
          backgroundColor: Colors.redAccent,
          centerTitle: true,
          leading: IconButton(
              onPressed: (){
                setState(() {
                  controller!.pausePreview();
                });
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => RegisterFace(user: widget.user,student: widget.student,)));
              },
              icon: Icon(Icons.arrow_back)
          )
      ),
      body:Column(

        children: [

          Container(
              child: controller == null?
              Center(child: CircularProgressIndicator()):
              !controller!.value.isInitialized?
              Center(
                child: CircularProgressIndicator(),
              ):
              CameraPreview(controller!)
          ),
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      floatingActionButton: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
        ),
        onPressed: () async{
          image = await controller?.takePicture();
          File img = File(image!.path);
          print('Captured');
          setState(() {
            captured = true;
            controller!.pausePreview();
            images.add(img);
          });
        },
        child: Icon(Icons.camera_alt,),
      ),
    );
  }
}