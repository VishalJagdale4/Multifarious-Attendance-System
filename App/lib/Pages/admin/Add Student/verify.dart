import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:project/Pages/Class/Student.dart';
import 'package:project/Pages/admin/Add%20Student/students.dart';

class VerifyPicture extends StatefulWidget {
  const VerifyPicture({Key? key, required this.student, required this.batch, required this.user}) : super(key: key);
  final Student student;
  final String batch;
  final User user;

  @override
  State<VerifyPicture> createState() => _VerifyPictureState();
}

class _VerifyPictureState extends State<VerifyPicture> {
  List<String> imageUrls = [];
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    getImages();
  }

  void getImages() async {
    final ref = FirebaseStorage.instance.ref().child('Student Faces/${widget.student.branch}/${widget.student.year}/${widget.student.uid}');
    var imageList = await ref.listAll();
    for (var image in imageList.items) {
      String url = await image.getDownloadURL();
      setState(() {
        imageUrls.add(url);
      });
    }
    setState(() {
      loaded = true;
    });
    print('Images collected');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Verify Face'),
          backgroundColor: Colors.redAccent,
          centerTitle: true,
          leading: IconButton(
              onPressed: (){
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => Students(user: widget.user, batch: widget.batch,)));},
              icon: Icon(Icons.arrow_back)
          )
      ),
      body: Stack(
        children: [
          GridView.builder(
            itemCount: imageUrls.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ImageScreen(imageUrls[index], widget.student.name),
                    ),
                  );
                },
                child: Image.network(imageUrls[index], fit: BoxFit.cover),
              );
            },
          ),
          !loaded
              ? Center(child: CircularProgressIndicator(color: Colors.redAccent,))
              : SizedBox.shrink(),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green
              ),
              onPressed: (){},
              icon: Icon(Icons.check),
              label: Text('Confirm', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),)
          ),

          ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red
              ),
              onPressed: (){},
              icon: Icon(Icons.cancel_outlined),
              label: Text('Decline', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),)
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class ImageScreen extends StatelessWidget {
  final String imageUrl;
  final String name;

  ImageScreen(this.imageUrl, this.name);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      ),
      body: Container(
        child: PhotoView(
          maxScale:  PhotoViewComputedScale.contained * 10,
          minScale:  PhotoViewComputedScale.contained * 1,
          imageProvider: NetworkImage(imageUrl),
        ),
      ),
    );
  }
}

