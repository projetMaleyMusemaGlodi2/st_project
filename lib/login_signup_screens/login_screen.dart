import 'dart:convert';

import 'package:flights_app/Home/home_screen.dart';
import 'package:flights_app/MyClasses/clsAgence.dart';
//import 'package:flights_app/MyClasses/SharedPref/myPreferences.dart';
import 'package:flights_app/MyClasses/pub.dart';
import 'package:flights_app/MyDesigns/Administration/homeAdmin.dart';
import 'package:flights_app/login_signup_screens/otp_login.dart';
import 'package:flights_app/login_signup_screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  
//================SHARED PREFERENCES=====================================
//MyPreferences _myPreferences=MyPreferences();
bool auto;
String user1,password1;
  //======================================================================================
  FocusNode myFocusNode;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //String _email;
  String _password;
  TextEditingController user = new TextEditingController();
  TextEditingController pass = new TextEditingController();
Future<List> _getLevelUser() async {
    final response = await http.post(PubCon.cheminPhp + "GetNiveauUser.php",
        body: {"username": user.text, "passwordUser": pass.text});
    //print(response.body);
    var datauser = json.decode(response.body);
    if (datauser.length == 0) {
      setState(() {
        PubCon.userPrivilege =''; 
      });
      Fluttertoast.showToast(
          msg: 'Une Erreur est survenue',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.white,
          textColor: Colors.red);
    } else {
      Fluttertoast.showToast(
          msg: 'connexion...',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.white,
          textColor: Colors.black);
      setState(() {
        PubCon.userPrivilege =datauser[0]['niveauUser']; 
      });
          
    }
    return datauser;
  }


  Future<List> _login() async {
    final response = await http.post(PubCon.cheminPhp + "login.php",
        body: {"usernameClient": user.text, "passwordClient": pass.text});
    //print(response.body);
    var datauser = json.decode(response.body);
    if (datauser.length == 0) {
      Fluttertoast.showToast(
          msg: 'Echec de connexion',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.white,
          textColor: Colors.red);
    } else {
      Fluttertoast.showToast(
          msg: 'connexion réussie avec succès',
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.white,
          textColor: Colors.black);
      setState(() {
        PubCon.userId = datauser[0]['codeCompte'];
        PubCon.userNomComplet = datauser[0]['nomClient'];
        PubCon.userPass = datauser[0]['passwordClient'];
        PubCon.userName = datauser[0]['usernameClient'];
        //PubCon.userPrivilege = datauser[0]['privilegeClient'];
        PubCon.userPrivilege = '0';
        PubCon.userImage = datauser[0]['photoClient'];
      });
      // _myPreferences.automatic=auto;
      // _myPreferences.user=PubCon.userName;
      // _myPreferences.password=PubCon.userPass;
      // _myPreferences.nomcomplet=PubCon.userNomComplet;
      // _myPreferences.iduser=PubCon.userId;
      // _myPreferences.privilege=PubCon.userPrivilege;
      // _myPreferences.image=PubCon.userImage;
      // _myPreferences.commit();
      Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePageScreen()));
    }
    return datauser;
  }
  //testLogin()
  void testLogin(){
    _getLevelUser();
if(PubCon.userPrivilege=='0'){
  _login();
      
          }else if(PubCon.userPrivilege=='1'){
            _loginAgence();
          }
  }
//=====================log Agence=============
Future<List> _loginAgence() async {
    final response = await http.post(PubCon.cheminPhp + "loginAgence.php",
        body: {"usersessionAgence": user.text, "passwordAgence": pass.text});
    //print(response.body);
    var datauser = json.decode(response.body);
    if (datauser.length == 0) {
      Fluttertoast.showToast(
          msg: 'Echec de connexion',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.white,
          textColor: Colors.red);
    } else {
      Fluttertoast.showToast(
          msg: 'connexion réussie avec succès',
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.white,
          textColor: Colors.black);
      setState(() {
        PubCon.userIdAgence = datauser[0]['codeAgence'];
        PubCon.userNomComplet = datauser[0]['nomAgence'];
        PubCon.userPass = datauser[0]['passwordAgence'];
        PubCon.userName = datauser[0]['usersessionAgence'];
        PubCon.userPrivilege = '1';
        PubCon.userImage = datauser[0]['logoAgence'];
        AgenceCls.adresseMail=datauser[0]['email'];
        AgenceCls.numTel=datauser[0]['contactAgence'];
      });
          //appel accueil administration HomeAdmin
          Navigator.of(context).pushReplacement(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        HomeAdmin()));
       
    }
    return datauser;
  }
  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    //_myPreferences.init().then((value){
// if(mounted)
// setState(() {
//   _myPreferences=value;
// });
//     });
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      body: ListView(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.35,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: <Widget>[
                ClipPath(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.35,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.blue[300],
                  ),
                  clipper: RoundedClipper(60),
                ),
                ClipPath(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.33,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.purpleAccent.withOpacity(0.3),
                  ),
                  clipper: RoundedClipper(50),
                ),
                Positioned(
                    top: -110,
                    left: -110,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.30,
                      width: MediaQuery.of(context).size.height * 0.30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              (MediaQuery.of(context).size.height * 0.30) / 2),
                          color: Colors.purple[300].withOpacity(0.5)),
                      child: Center(
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.blueAccent),
                        ),
                      ),
                    )),
                Positioned(
                    top: -100,
                    left: 100,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.36,
                      width: MediaQuery.of(context).size.height * 0.36,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              (MediaQuery.of(context).size.height * 0.36) / 2),
                          color: Colors.blueAccent.withOpacity(0.3)),
                      child: Center(
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.blueAccent),
                        ),
                      ),
                    )),
                Positioned(
                    top: -50,
                    left: 60,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.15,
                      width: MediaQuery.of(context).size.height * 0.15,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              (MediaQuery.of(context).size.height * 0.15) / 2),
                          color: Colors.blueAccent.withOpacity(0.3)),
                    )),
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.15 - 50),
                  height: MediaQuery.of(context).size.height * 0.33,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        "assets/login.png",
                        height: MediaQuery.of(context).size.height * 0.15,
                        width: MediaQuery.of(context).size.height * 0.15,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Welcome",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.65,
            width: MediaQuery.of(context).size.width,
            child: Container(
              margin: EdgeInsets.fromLTRB(20, 12, 20, 10),
              child: Form(
                key: _formKey,
                autovalidate: _autoValidate,
                child: ListView(
                  children: <Widget>[
                    // TextFormField(
                    //   validator: validateEmail,
                    //   onSaved: (String val) {
                    //     _email = val;
                    //   },
                    //   keyboardType: TextInputType.emailAddress,
                    //   style: TextStyle(fontSize: 16, color: Colors.black),
                    //   textInputAction: TextInputAction.next,
                    //   decoration: InputDecoration(
                    //     labelText: "Email",
                    //     contentPadding: new EdgeInsets.symmetric(
                    //         vertical:
                    //             MediaQuery.of(context).size.height * 0.022,
                    //         horizontal: 15.0),
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.all(Radius.circular(25)),
                    //     ),
                    //   ),
                    //   onFieldSubmitted: (String value) {
                    //     FocusScope.of(context).requestFocus(myFocusNode);
                    //   },
                    // ),
                   
                    Divider(),
                    TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Entrez votre username ';
                        }
                      },
                      onSaved: (String val){
                        user1=val;
                      },
                      obscureText: false,
                      controller: user,
                      focusNode: FocusNode(),
                      keyboardType: TextInputType.text,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: "Username *",
                        contentPadding: new EdgeInsets.symmetric(
                            vertical:
                                MediaQuery.of(context).size.height * 0.022,
                            horizontal: 15.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      validator: validatePassword,
                      onSaved: (String val) {
                        _password = val;
                        
                      },
                      focusNode: myFocusNode,
                      obscureText: true,
                      controller: pass,
                      
                      keyboardType: TextInputType.text,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        labelText: "Password *",
                        contentPadding: new EdgeInsets.symmetric(
                            vertical:
                                MediaQuery.of(context).size.height * 0.022,
                            horizontal: 15.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Row(
                        children: <Widget>[
                          Checkbox(
                            activeColor: Colors.deepPurpleAccent,
                            value: _value1,
                            onChanged: _value1Changed,
                          ),
                          // Switch(
                          //   //value: _myPreferences.automatic,
                          //   onChanged: (value){
                          //     auto=value;
                          //   },
                          // ),
                          Text(
                            "Se souvenir",
                            style: TextStyle(
                                color: Colors.deepPurpleAccent,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Container(
                      child: GestureDetector(
                          onTap: () {
                            print("pressed");
                            //on test le niveau et on connect dans la meme fx
                            testLogin();
                           // _validateInputs();
                            if (_autoValidate) {
                              
                              //======================================================
                            }
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.065,
                            decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25))),
                            child: Center(
                              child: Text(
                                "CONNEXION",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                          )),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    // Container(
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: <Widget>[
                    //       Text(
                    //         "Connect with",
                    //         style: TextStyle(
                    //             fontSize: 14, fontWeight: FontWeight.bold),
                    //       ),
                    //       Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //         crossAxisAlignment: CrossAxisAlignment.center,
                    //         children: <Widget>[
                    //           Container(
                    //             margin: EdgeInsets.only(left: 7),
                    //             height:
                    //                 MediaQuery.of(context).size.height * 0.065,
                    //             width:
                    //                 MediaQuery.of(context).size.height * 0.065,
                    //             decoration: BoxDecoration(
                    //                 color: Colors.blue[900],
                    //                 shape: BoxShape.circle),
                    //             child: Center(
                    //               child: Image.asset(
                    //                 "assets/facebook.png",
                    //                 color: Colors.white,
                    //               ),
                    //             ),
                    //           ),
                    //           Container(
                    //             margin: EdgeInsets.only(left: 7),
                    //             height:
                    //                 MediaQuery.of(context).size.height * 0.065,
                    //             width:
                    //                 MediaQuery.of(context).size.height * 0.065,
                    //             decoration: BoxDecoration(
                    //                 color: Colors.red, shape: BoxShape.circle),
                    //             child: Image.asset(
                    //               "assets/google.png",
                    //               color: Colors.white,
                    //             ),
                    //           ),
                    //           Container(
                    //             margin: EdgeInsets.only(left: 7),
                    //             height:
                    //                 MediaQuery.of(context).size.height * 0.065,
                    //             width:
                    //                 MediaQuery.of(context).size.height * 0.065,
                    //             decoration: BoxDecoration(
                    //                 color: Colors.lightBlue[400],
                    //                 shape: BoxShape.circle),
                    //             child: Image.asset(
                    //               "assets/twitter.png",
                    //               color: Colors.white,
                    //             ),
                    //           ),
                    //           Container(
                    //             margin: EdgeInsets.only(left: 7),
                    //             height:
                    //                 MediaQuery.of(context).size.height * 0.065,
                    //             width:
                    //                 MediaQuery.of(context).size.height * 0.065,
                    //             decoration: BoxDecoration(
                    //                 color: Colors.lightBlue[800],
                    //                 shape: BoxShape.circle),
                    //             child: Image.asset(
                    //               "assets/linkedin.png",
                    //               color: Colors.white,
                    //             ),
                    //           )
                    //         ],
                    //       )
                    //     ],
                    //   ),
                    // ),
                    Container(
                        margin: EdgeInsets.only(top: 10, bottom: 15),
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: GestureDetector(
                          onTap: () {
                            print("signup");
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignupScreen()));
                          },
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Nouveau Compte?",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Signup",
                                  style: TextStyle(
                                      color: Colors.deepPurpleAccent,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        )),
                    Container(
                        margin: EdgeInsets.only(top: 10, bottom: 10),
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: GestureDetector(
                          onTap: () {
                            print("Reset");
                            Navigator.of(context).pushReplacement(
                              new MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return new OtpLoginPage();
                                },
                              ),
                            );
                          },
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Mot de passe oublie?",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Restore compte",
                                  style: TextStyle(
                                      color: Colors.deepPurpleAccent,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  bool _value1 = false;
  bool _autoValidate = false;

  void _value1Changed(bool value) => setState(() => _value1 = value);

//   void _validateInputs() {
//     if (_formKey.currentState.validate()) {
// //    If all data are correct then save data to out variables
//       _formKey.currentState.save();
//     } else {
// //    If all data are not valid then start auto validation.
//       setState(() {
//         _autoValidate = true;
//       });
//     }
//   }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  String validatePassword(String value) {
    if (value.length < 1)
      return 'Password must be atleast 1 digits';
    else
      return null;
  }
}

class RoundedClipper extends CustomClipper<Path> {
  var differenceInHeights = 0;

  RoundedClipper(int differenceInHeights) {
    this.differenceInHeights = differenceInHeights;
  }

  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - differenceInHeights);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
