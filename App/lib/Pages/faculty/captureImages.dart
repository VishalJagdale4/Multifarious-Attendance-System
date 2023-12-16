import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:project/Pages/Class/Faculty.dart';
import 'package:project/Pages/faculty/Faculty.dart';
import 'package:project/Pages/faculty/uploadImages.dart';
import 'package:image/image.dart' as img;
import 'dart:io';

class TakeAttendance extends StatefulWidget {
  const TakeAttendance({Key? key, required this.user, required this.faculty, required this.session}) : super(key: key);
  final User user;
  final Faculty faculty;
  final String session;

  @override
  State<TakeAttendance> createState() => _TakeAttendanceState();
}

class _TakeAttendanceState extends State<TakeAttendance> {

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
      controller = CameraController(cameras!.first, ResolutionPreset.max,);
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
                      PreviewImage(images: images, user: widget.user,faculty: widget.faculty,session: widget.session,)));
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
                    context, MaterialPageRoute(builder: (_) => FacultyA(user: widget.user,faculty: widget.faculty,)));
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

      floatingActionButton: Container(
        width: 100,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
          onPressed: () async{
            image = await controller?.takePicture();
            File imageFile = File(image!.path);
            List<int> imageBytes = await imageFile.readAsBytes();
            final originalImage = img.decodeImage(imageBytes);
            img.Image newImage;
            newImage = img.copyRotate(originalImage!, -90);
            final fixedFile = await imageFile.writeAsBytes(img.encodeJpg(newImage));
            print('Captured');

            setState(() {
              captured = true;
              controller!.pausePreview();
              images.add(fixedFile);
            });
          },
          child: RotatedBox(
              quarterTurns: 1,
              child: captured?Center(child: CircularProgressIndicator()):Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt,),
                  Container(
                    width: 100,
                    child: Text('Capture from this angle', textAlign: TextAlign.center,),
                  )
                ],
              )
          ),
        ),
      )
    );
  }
}

