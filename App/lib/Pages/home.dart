import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project/Pages/login/admin/adminlogin.dart';
import 'package:project/Pages/login/faculty/facultylogin.dart';
import 'package:project/Pages/login/student/studentlogin.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double image_height = 300;
    double button_height = 40;
    double text_height = 50;
    double content = (image_height+button_height+text_height+300);
    double top_margin = (height-content)/2;

    // print(height);

    Future<void> showAlert() async {

      showDialog(context: context,
          builder: (BuildContext context){
            return  AlertDialog(
              title: Text("Exit?"),
              content: Text("Are you sure you want to exit?"),
              actions: [
                //
                ElevatedButton(
                    onPressed: () => SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
                    child: Text("Yes")
                ),

                ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("No")
                )
              ],
            );
          }
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          SizedBox(height: top_margin,),
          Padding(
            padding: EdgeInsets.only(top: 60.0),
            child: Center(
              child: Container(
                  width: 400,
                  height: image_height,
                  /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                  child: Image.asset('assets/logo/wide_logo.png')
              ),
            ),
          ),
          Center(
            child: Container(
                width: 350,
                // decoration: BoxDecoration(color: Colors.black),
                child: Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shadowColor: Colors.greenAccent,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                        minimumSize: Size(100, button_height), //////// HERE
                      ),
                      onPressed: () {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (_) => FacultyLogin()));
                      },
                      child: Text(
                        'Faculty',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),

                    SizedBox(
                      width: 20,
                    ),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        shadowColor: Colors.greenAccent,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                        minimumSize: Size(100, button_height), //////// HERE
                      ),
                      onPressed: () {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (_) => AdminLogin()));
                      },
                      child: Text(
                        'Admin',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),

                    SizedBox(
                      width: 20,
                    ),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shadowColor: Colors.greenAccent,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                        minimumSize: Size(100, button_height), //////// HERE
                      ),
                      onPressed: () {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (_) => StudentLogin()));
                      },
                      child: Text(
                        'Student',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ],
                )
            ),
          ),
          SizedBox(
            height:100,
          ),
          Center(
            child: Container(
              height: text_height,
              child:Text('Smart Attendace System and Attendance Management',
                style: TextStyle(fontWeight:FontWeight.bold, fontSize: 18),
                textAlign: TextAlign.center,),
            ),
          ),

          SizedBox(
            height: 20,
          ),

          TextButton(
              onPressed: () => showAlert(),
              child: Text('Exit App', style: TextStyle(fontSize: 20, color: Colors.redAccent),)
            ),

        ],
      ),

    );

  }
}