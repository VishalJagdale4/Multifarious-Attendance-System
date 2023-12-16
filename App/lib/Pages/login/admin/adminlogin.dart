import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/Pages/admin/Admin.dart';
import 'package:project/Pages/login/faculty/forgetpassword.dart';

class AdminLogin extends StatefulWidget {
  @override
  _AdminLoginState createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {

  final auth = FirebaseAuth.instance;
  User? user;
  bool logging = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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

    if(email != 'admin@email.com' && password != '123456')
      return null;

    User? usr;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      usr = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided.');
      }
    }

    return usr;

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
        title: Text("Admin Login"),
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
                    setState(() => logging = false);
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => Admin(user:  user!,)));
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