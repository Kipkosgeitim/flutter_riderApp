import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:riderapp/AllWidgets/progressDialog.dart';
import 'package:riderapp/Allscreens/registrationScreen.dart';

import '../main.dart';
import 'mainscreen.dart';


class LoginScreen extends StatelessWidget {

  static const String idScreen = "login";
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

          backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(

            children: [
              SizedBox(height: 45.0,),
              Image(
                image: AssetImage("images/logo.png"),
                width: 390.0,
                height: 250,
                alignment: Alignment.center,

              ),
              SizedBox(height:1.0),
              Text(
                'Login As a Rider',
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Brand Bold',fontSize: 24.0),
              ),

              Padding(
                padding: EdgeInsets.all(20.0),

                child: Column(
                  children: [
                    SizedBox(height: 1.0,),
                    TextField(
                      controller: emailEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(height: 1.0,),
                    TextField(
                      controller: passwordEditingController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(height: 20.0,),
                    RaisedButton(
                      color: Colors.yellow,
                      textColor: Colors.white,
                      child: Container(
                        height: 50.0,
                        child: Center(
                          child: Text('Login',
                          style: TextStyle(fontFamily: "Brand Bold",fontSize: 18.0),
                          ),

                        ),
                      ),
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(24.0),
                      ),
                      onPressed: (){
                        if(!emailEditingController.text.contains('@')){

                          displayToastMessage("email Adress not Valid", context);

                        }
                        else if(passwordEditingController.text.isEmpty){

                          displayToastMessage("Password Required", context);

                        }else{

                          loginAndAuthenticateUser(context);

                        }

                      },


                    ),

                  ],

                ),

              ),
              FlatButton(
                onPressed: (){

                 Navigator.pushNamedAndRemoveUntil(context, RegistrationScreen.idScreen, (route) => false);
                },

                  child: Text(
                  'Do not have an Account? Register Here'
              ),



              )


            ],
          ),
        ),
      ),
    );
  }
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;


  void loginAndAuthenticateUser(BuildContext context) async{

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){

          return ProgressDialog( message:"Authenticating, Please! Wait");
        }

    );

    final User firebaseUser= (await _firebaseAuth.signInWithEmailAndPassword(email:
    emailEditingController.text, password: passwordEditingController.text).catchError((errMsg){
      Navigator.pop(context);
      displayToastMessage  ( "Error"+ errMsg.toString(),context

      );})).user;

    if(firebaseUser !=null) {


      userRef.child(firebaseUser.uid).once().then((DataSnapshot snap){

        if(snap.value!=null){
          displayToastMessage("You Have login Successfully", context);

          Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);

        }else{

          Navigator.pop(context);

          _firebaseAuth.signOut();
          displayToastMessage("No record for this number,Create account", context);

        }
      });

    }else{

      //error
      Navigator.pop(context);
      displayToastMessage("Failed", context);
    }
  }
}



