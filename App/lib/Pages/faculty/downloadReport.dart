import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/Pages/Class/Faculty.dart';
import 'package:project/Pages/faculty/Faculty.dart';

class DownloadReport extends StatefulWidget {
  const DownloadReport({Key? key, required this.user, required this.faculty, required this.use}) : super(key: key);
  final User user;
  final Faculty faculty;
  final String? use;

  @override
  State<DownloadReport> createState() => _DownloadReportState();
}

class _DownloadReportState extends State<DownloadReport> {

  String dateFrom = DateTime.now().toString();
  String dateTo = DateTime.now().toString();
  bool forall = false;
  bool clicked = false;
  bool fetching = false;
  bool downloaded = false;

  Future<void> showAlert(bool success, String file) async {

    String head = 'Failed To Download';
    String data = 'Data not found';

    if (success){
      head = 'Download Successful';
      data = 'File downloaded in device at,\nLocation: $file';
    }

    showDialog(context: context,
        builder: (BuildContext context){
          return  AlertDialog(
            title: Text(head),
            content: Text(data),
            actions: [ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Ok")
            )],
          );
        }
    );
  }

  Future<void> downloadFile(String file) async {
    final Reference ref = FirebaseStorage.instance.ref(file);
    final String fileName = file.split('/').last;

    try {
      final String downloadURL = await ref.getDownloadURL();
      final String filePath = '/storage/emulated/0/Download/$fileName';
      final File downloadToFile = File(filePath);

      final http.Response response = await http.get(Uri.parse(downloadURL));
      await downloadToFile.writeAsBytes(response.bodyBytes);
      print('File downloaded successfully.');
      setState(() {
        downloaded = true;
      });
      showAlert(true, '/storage/emulated/0/Download/$fileName');
    } catch (e) {
      setState(() {
        downloaded = false;
      });
      print('Error downloading file: $e');
      showAlert(false, '');
    }

  }

  String formatDate(String dateString) {
    final date = DateTime.parse(dateString.replaceAll('/', '-'));
    final formattedDate = DateFormat('d MMMM yyyy').format(date);
    return formattedDate;
  }

  void fetch(){

    var db = FirebaseDatabase.instance.ref('Jobs/Reports/').child(
        '${widget.faculty.department}_${widget.use!.split('_')[1]}_${widget.use!.split('_')[0]}'
    );

    String sType;
    String sDate;
    if (forall) {
      sType = 'all';
      sDate = '${dateFrom}_$dateTo';
    } else {
      sType = 'single';
      sDate = dateFrom;
    }

    db.set({
      'remaining' : 'true',
      'type' : sType,
      'date' : sDate,
      'url' : '',
      'data' : ''
    });

    db.onValue.listen((event) {

      Map<dynamic, dynamic> attr = event.snapshot.value as Map<dynamic, dynamic>;

      if (attr['remaining'] == 'false') {

        String filePath;

        if (attr['type'] == 'single') {
          filePath = 'Attendance Reports/${widget.faculty.department}/${widget.use!.split('_')[1]}/${formatDate(sDate)}'
              '/${widget.use!.split('_')[0]}/${formatDate(sDate)}_${widget.use!.split('_')[0]}.csv';
        } else {
          filePath = 'Monthly Reports/${widget.faculty.department}/${widget.use!.split('_')[1]}'
              '/attendance_report (${formatDate(sDate.split('_')[0])} to ${formatDate(sDate.split('_')[1])}).xlsx';
        }

        if (attr['data'] == 'true') {
          downloadFile(filePath);
          if (!downloaded)
            print('Fail to download');
          setState(() {
            fetching = false;
            clicked = false;
          });
        } else {
          setState(() {
            if(clicked) showAlert(false, '');
            fetching = false;
            clicked = false;
          });
          print('Data not found!');
        }
      }else
        print('Working on...');
    });
  }

  Future<void> pickDateF(BuildContext context) async {
    DateTime selectedDate = DateTime.parse(dateFrom.replaceAll('/','-'));
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        dateFrom = picked.toString().split(' ')[0].replaceAll('-', '/');
      });
    }
  }

  Future<void> pickDateT(BuildContext context) async {
    DateTime selectedDate = DateTime.parse(dateTo.replaceAll('/','-'));
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        dateTo = picked.toString().split(' ')[0].replaceAll('-', '/');
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    forall = widget.use!.split('_')[0] == 'All';
    dateFrom = dateFrom.split(' ')[0].replaceAll('-', '/');
    dateTo = dateTo.split(' ')[0].replaceAll('-', '/');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Download'),
            backgroundColor: Colors.redAccent,
            centerTitle: true,
            leading: IconButton(
                onPressed: (){
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => FacultyA(user: widget.user, faculty: widget.faculty)));
                  },
                icon: Icon(Icons.arrow_back)
            )
        ),

        body: Center( child: Column(

          children: [

            SizedBox(height: 100,),
            Center(child:Icon(Icons.assignment,size: 200,color: Colors.red,)),

            SizedBox(height: 20,),

            Container(height: 40,
              child: Text('Attendace Report.xlsx', style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),

            ),

            SizedBox(height: 20,),

            forall?TextButton(
              onPressed: () {
                pickDateF(context);
              },
              child: Text('From: ' + dateFrom),

            ):TextButton(
              onPressed: () {
                pickDateF(context);
              },
              child: Text('Date: ' + dateFrom),
            ),

            SizedBox(height: 10,),

            forall?TextButton(
              onPressed: () {
                pickDateT(context);
              },
              child: Text('To: ' + dateTo),
            ):Container(),

            SizedBox(height: 30,),

            !clicked?ElevatedButton(
              onPressed: () {
                setState(() {
                  clicked = true;
                  fetching = true;
                });
                fetch();
              },
              child: const Text('Downlaod', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo,),
            ):Column(children: [CircularProgressIndicator(color: Colors.redAccent,),SizedBox(height: 20,),Text('Fetching...')],),
          ],
        ),
        )
    );
  }
}
