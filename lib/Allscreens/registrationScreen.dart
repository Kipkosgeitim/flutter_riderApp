import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riderapp/AllWidgets/progressDialog.dart';
import 'package:riderapp/Allscreens/mainscreen.dart';
import 'package:riderapp/main.dart';



import 'loginScreen.dart';


class RegistrationScreen extends StatelessWidget {

  static const String idScreen = "register";

  TextEditingController textEditingController = TextEditingController();
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController phoneEditingController = TextEditingController();
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
                'Register As a Rider',
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Brand Bold',fontSize: 24.0),
              ),

              Padding(
                padding: EdgeInsets.all(20.0),

                child: Column(
                  children: [
                    SizedBox(height: 1.0,),
                    TextField(
                      controller: textEditingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Name',
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
                      controller: phoneEditingController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Phone',
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
                          child: Text('Create Account',
                            style: TextStyle(fontFamily: "Brand Bold",fontSize: 18.0),
                          ),

                        ),
                      ),
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(24.0),
                      ),
                      onPressed: (){

                        if(textEditingController.text.length<3)
                          {
                          displayToastMessage("name must be at least 3 characters",context);

                          }else if(!emailEditingController.text.contains('@')){

                          displayToastMessage("email Adress not Valid", context);

                        }else if(phoneEditingController.text.isEmpty){

                          displayToastMessage("Phone number is mandatory", context);

                        }else if(passwordEditingController.text.length<6){

                          displayToastMessage("Password should have more tha 6 characters", context);

                        }else{
                          registerNewUser(context);
                        }


                      },


                    ),

                  ],

                ),

              ),
              FlatButton(
                onPressed: (){


                  Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);
                },

                child: Text(
                    'Have an account? login Here'
                ),



              )


            ],
          ),
        ),
      ),
    );
  }
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;


  void registerNewUser(BuildContext context) async{

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){

          return ProgressDialog( message:"Submitting details, Please! Wait");
        }

    );

    final User firebaseUser= (await _firebaseAuth.createUserWithEmailAndPassword(email:
    emailEditingController.text, password: passwordEditingController.text).catchError((errMsg){

      Navigator.pop(context);
      displayToastMessage  ( "Error"+ errMsg.toString(),context

    );})).user;


    if(firebaseUser !=null) {//save


      Map userDataMap= {
        "name": textEditingController.text.trim(),
        "email": emailEditingController.text.trim(),
        "phone": phoneEditingController.text.trim(),


      };
      userRef.child(firebaseUser.uid).set(userDataMap);
      displayToastMessage("Congratulations,Account created", context);

      Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
    }else{


      //error
      Navigator.pop(context);
      displayToastMessage("new Account not created", context);
    }
  }
}

displayToastMessage(String message,BuildContext context){
  Fluttertoast.showToast(msg: message);

}