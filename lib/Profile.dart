import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lost/splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toast/toast.dart';

import 'AddOrRwmovePage.dart';
import 'MyPost.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyHomePage();
  }
}

class MyHomePageState extends State<MyHomePage> {
  Builder _buildDialogItem(
      BuildContext context, String text, IconData icon, ImageSource src) {
    return Builder(
      builder: (innerContext) => Container(
        decoration: BoxDecoration(
          color: Colors.pink,
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          leading: Icon(icon, color: Colors.white),
          title: Text(text,
              style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic)),
          onTap: () {
            // getImageL(src);
            checkpermission_opencamera(src);
            Navigator.of(innerContext).pop();
          },
        ),
      ),
    );
  }

  // Permissione
  checkpermission_opencamera(ImageSource sourcee) async {
    var CameraStatue = await Permission.camera.status;
    if (!CameraStatue.isGranted) {
      await Permission.camera.request();
    }
    print(CameraStatue);
    if (await Permission.camera.isGranted) {
      getImageL(sourcee);
    }
  }

  DateTime lastPressed;

  Future<bool> onClicktoExit() async {
    DateTime now = DateTime.now();
    bool backButton = lastPressed == null ||
        now.difference(lastPressed) > Duration(seconds: 3);
    if (backButton) {
      lastPressed = DateTime.now();
      Toast.show(
        'Double click to exit application',
        context,
        textColor: Colors.white,
      );
      return false;
    }
    return true;
  }

  File userImage;

  void getImageL(ImageSource src) async {
    final pickedFile = await ImagePicker().getImage(source: src);
    if (pickedFile != null) {
      setState(() {
        userImage = File(pickedFile.path);
      });
      uploadToFireStorage(userImage);
    }
  }

  // Upoald To Fire Storage
  String url;

  void uploadToFireStorage(File image) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('images')
        .child('userImage')
        .child(userId);
    await ref.putFile(image);
    final userImageUrl = await ref.getDownloadURL();
    setState(() {
      url = userImageUrl;
    });
  }

  // Get User Id
  final FirebaseAuth auth = FirebaseAuth.instance;

  void inputData() {
    final User user = auth.currentUser;
    final uid = user.uid;
    fatchData(uid);
    setState(() {
      userId = uid;
    });
    print('User Id : '+ uid);
  }

  String userId;

  // Fetch User Data
  // Real Data
  String FirstName;
  String LastName;
  String UserImageUrl;
  String phoneNumber;
  String email;
  String address;
  // Chek
  String firstname;
  String lastname;
  String EMAIL;
  String PhoneNumber;
  String Address;

  Future<String> fatchData(String userId) async {
    print('In Fetch Data Function  :   ' );
    print('User Id : '+ userId);
    final userData = await FirebaseFirestore.instance
        .collection('products/ZcZ5UQqaDgnwU4hWE4He/user')
        .doc(userId)
        .get();
    setState(() {
      // Real Date
      FirstName = userData['Firstname'];
      LastName = userData['lastname'];
      email = userData['email'];
      PhoneNumber = userData['phoneNumber']== null ? null : userData['phoneNumber'];
      address = userData['address'] == null ? null : userData['address'];
      UserImageUrl = userData['imageUrl'] == null ? null : userData['imageUrl'];
      // For Check
      firstname = userData['Firstname'];
      lastname = userData['lastname'];
      EMAIL = userData['email'];
      Address = userData['address']== null ? null : userData['address'];
      phoneNumber = userData['phoneNumber'] == null ? null : userData['phoneNumber'];
      url = userData['imageUrl'] == null ? null : userData['imageUrl'];
    });


  }

  @override
  void initState() {
    // TODO: implement initState
    inputData();
    super.initState();
  }

  void showDialiog() {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              backgroundColor: Colors.black,
              title: Text(
                'Are you changed your data?',
                style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Colors.white),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: RaisedButton(
                        child: Text('CONFIRM', style: TextStyle(fontSize: 20)),
                        onPressed: () {
                          Navigator.pop(ctx);
                          updateData();
                        }),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: RaisedButton(
                        color: Colors.pinkAccent,
                        child: Text(
                          'IGNORE',
                          style: TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          Navigator.pop(ctx);
                          Navigator.pushReplacement(
                              context,
                              PageTransition(child: AddOrRwmovePage(),
                                  type: PageTransitionType.topToBottom , duration: Duration(milliseconds: 500)
                              ));
                        }),
                  )
                ],
              ),
            ));
  }

  void _submit() async {
    if (FirstName != firstname) {
      showDialiog();
    } else if (LastName != lastname) {
      showDialiog();
    } else if (email != EMAIL) {
      showDialiog();
    } else if (url != UserImageUrl) {
      showDialiog();
    } else if (phoneNumber != PhoneNumber) {
      showDialiog();
    } else if (address != Address) {
      showDialiog();
    } else {
      Navigator.pushReplacement(
          context, PageTransition(child: AddOrRwmovePage(),
          type: PageTransitionType.topToBottom , duration: Duration(milliseconds: 500)
      ));
    }
  }

  void updateData() async {
    final userData = await FirebaseFirestore.instance
        .collection('products/ZcZ5UQqaDgnwU4hWE4He/user')
        .doc(userId)
        .update({
      'Firstname': firstname,
      'lastname': lastname,
      'email': EMAIL,
      'imageUrl': url == null ? null : url,
      'phoneNumber': PhoneNumber == null ? null : PhoneNumber,
      'address': Address == null ? null : Address
    }).whenComplete(() => Navigator.pushReplacement(
            context, PageTransition(child:thankSplashScreen() ,
        type: PageTransitionType.topToBottom , duration: Duration(milliseconds: 500)
    )
    //
    ));
  }
  double _startingPos;
  double _pos;
  int _length;
  int _endingIndex = 0;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  _submit();
                },
                icon: FirstName != firstname
                    || LastName != lastname
                    || email != EMAIL
                    || phoneNumber != PhoneNumber
                    || address != Address
                ?Icon(Icons.update, size: 30,color: Colors.white,)
                :Icon(Icons.home, size: 30,color: Colors.white,)



            )
          ],
          backgroundColor: Colors.pink,
          centerTitle: true,
          title: Text('Profile',
              style: TextStyle( color: Colors.black, fontStyle: FontStyle.italic, fontSize: 30)),
        ),
        body: WillPopScope(
          onWillPop: onClicktoExit,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black,
                      Colors.black,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
              SingleChildScrollView(
                  child: Column(
                children: [
                  SizedBox(height: 20),
                  InkWell(
                      onTap: () {
                        var ad = AlertDialog(
                          backgroundColor: Colors.black,
                          title: Text('Select Image Form ? ',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 20)),
                          content: Container(
                            height: 150,
                            child: Column(
                              children: [
                                Divider(color: Colors.white),
                                _buildDialogItem(
                                    context,
                                    "Camera",
                                    Icons.add_a_photo_outlined,
                                    ImageSource.camera),
                                SizedBox(height: 10),
                                _buildDialogItem(context, "Gallery",
                                    Icons.add_outlined, ImageSource.gallery),
                              ],
                            ),
                          ),
                        );
                        showDialog(context: context, builder: (context) => ad);
                      },
                      child: url == null
                          ? CircleAvatar(
                              backgroundImage:
                                  AssetImage('images/person_1.png'),
                              backgroundColor: Colors.blueGrey,
                              maxRadius: 50,
                            )
                          : Container(
                              color: Colors.black,
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.blueGrey,
                              ),
                              child: CircleAvatar(
                                  backgroundColor: Colors.black,
                                  radius: 50,
                                  child: Image.network(url)))
                  ),
                  Column(
                    children: [
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.only(left: 15, right: 20),
                        child: FirstName == null ?null :TextField(
                            decoration: InputDecoration(
                              icon: Icon(Icons.person, color: Colors.pink),
                              hintText: FirstName,
                              hintStyle:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            onChanged: (val) {
                              setState(() {
                                firstname = val;
                              });
                            }),
                      ),
                      SizedBox(height: 15.0),
                      Container(
                        padding: EdgeInsets.only(left: 15, right: 20),
                        child: LastName == null ? null : TextField(
                                decoration: InputDecoration(
                                  icon: Icon(Icons.person, color: Colors.pink),
                                  hintText: LastName,
                                  hintStyle: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                onChanged: (val) {
                                  setState(() {
                                    lastname = val;
                                  });
                                }),
                      ),
                      SizedBox(height: 15.0),
                      Container(
                          padding: EdgeInsets.only(left: 15, right: 20),
                          child: email == null
                              ? null
                              :TextField(
                                  decoration: InputDecoration(
                                      icon: Icon(Icons.email_outlined,
                                          color: Colors.pink),
                                      hintText: email,
                                      hintStyle: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                  onChanged: (val) {
                                    setState(() {
                                      EMAIL = val;
                                    });
                                  },
                                )),
                      SizedBox(height: 15.0),
                      Container(
                          padding: EdgeInsets.only(left: 15, right: 20),
                          child: TextField(
                            decoration: InputDecoration(
                                icon: Icon(Icons.phone, color: Colors.pink),
                                hintText: phoneNumber == null
                                    ? 'Phone Number'
                                    : phoneNumber,
                                hintStyle: TextStyle(
                                    color: Colors.white, fontSize: 20)),
                            keyboardType: TextInputType.phone,
                            onChanged: (val) {
                              setState(() {
                                PhoneNumber = val;
                              });
                            },
                          )),
                      SizedBox(height: 15.0),
                      Container(
                          padding: EdgeInsets.only(right: 20, left: 15),
                          child: TextField(
                            decoration: InputDecoration(
                                icon: Icon(
                                  Icons.home,
                                  color: Colors.pink,
                                ),
                                hintText: address == null
                                    ? 'personal address'
                                    : address,
                                hintStyle: TextStyle(
                                    color: Colors.white, fontSize: 20)),
                            onChanged: (val) {
                              setState(() {
                                Address = val;
                              });
                            },
                          )),

                    ],
                  )
                ],
              ))
            ],
          ),
        ),
      bottomNavigationBar: CurvedNavigationBar(
        index: 1 ,
        items: [
          Icon(Icons.home , size: 30, color: Colors.white),
          Icon(Icons.person , size: 30, color: Colors.white),
          Icon(Icons.person_search_rounded , size: 30, color: Colors.white),
        ],
        onTap: (index){
          if(index == 0 ){
            return Navigator.pushReplacement(
                context,
                PageTransition(child: AddOrRwmovePage(),
                    type: PageTransitionType.scale , alignment: Alignment.bottomLeft , duration: Duration(milliseconds: 700)
                ));
          }
          
          if(index == 2 ){
            Navigator.pushReplacement(
                context, PageTransition(child: MyPost(),
                type: PageTransitionType.scale, alignment: Alignment.bottomLeft , duration: Duration(milliseconds: 500)
            )
              //
            );
          }

        },

        animationCurve: Curves.easeIn,
        animationDuration:  Duration(milliseconds: 300),
        color: Colors.pink,
        backgroundColor: Colors.black,
        height: 60,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyHomePageState();
  }
}
