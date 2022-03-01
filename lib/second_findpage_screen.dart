import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'AddOrRwmovePage.dart';
import 'splash_screen.dart';
import 'package:toast/toast.dart';
class lostPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SecondlostPage();
  }
}


class SecondlostPage extends StatefulWidget {

  String descriptione;
  String locatione;
  String datee;
  String colore;
  String country;
  String user_id;
  bool type;
  String phoneNumber ;

  SecondlostPage({
    this.descriptione,

    this.locatione,this.datee,this.colore,this.country,this.user_id , this.type,this.phoneNumber});

  @override
  State<StatefulWidget> createState() {
    return SecondlostPageState(
        descriptione: descriptione,
        locatione: locatione,
        datee: datee,
        colore: colore,
        phone: phoneNumber,
        citye: country,userId: user_id,typee: type);
  }
}

class SecondlostPageState extends State<SecondlostPage> {
  DateTime lastPressed ;
  Future<bool> onClicktoExit() async{
    DateTime now = DateTime.now();
    bool backButton = lastPressed == null || now.difference(lastPressed) > Duration(seconds: 3);
    if(backButton){
      lastPressed = DateTime.now();
      Toast.show(
        'Double click to exit application',
        context,
        textColor: Colors.white,
      );
      return false ;
    }
    return true ;
  }

  List<File> _images = [];
  String descriptione;
  String locatione;
  String datee;
  String colore;
  String citye;
  String userId;
  String phone ;
  bool typee;
  SecondlostPageState({this.descriptione,this.locatione,this.datee,this.colore,this.citye,this.userId,this.typee,this.phone});

  // Choose Images
  void ChoosImage() async {
    final pickedFile =
    await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      _images.add(File(pickedFile.path));
    });
    if (pickedFile.path == null) retrivedata();
  }

  Future<void> retrivedata() async {
    final LostData response = await ImagePicker().getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _images.add(File(response.file.path));
      });
    } else {
      print(response.file);
    }
  }

  // GetUserId
  final FirebaseAuth auth = FirebaseAuth.instance;
  void inputData() {
    if(_images == null){
      return ;
    }else{
      print('In inputData Function ...........');
      final User user = auth.currentUser;
      UploadToFireStorage(user.uid);
    }
  }
  List<String> urls = [];
  // Upload To FireStorage
  void UploadToFireStorage(String id) async {
    print('In Upload To FireStorage Function ............');
    int i =1 ;
    for (var imag in _images) {
      setState(() {
        val = i / _images.length;
      });
      final ref = FirebaseStorage.instance
          .ref().child('images').child('lostImage').child(id).child(imag.path);
      await ref.putFile(imag);
      final urlImage = await ref.getDownloadURL();
      print('Get Url Image..........');
      print('gooo To Add List..........');
      AddToUrlList(urlImage);
      i++;
    }
    print('Goooo In FireStore.>>>>>>>>>>..........');
    AddNewLost(id);
  }

  void AddNewLost(String id) async {
    if (typee) {
      try {
        await FirebaseFirestore.instance
            .collection('products/ZcZ5UQqaDgnwU4hWE4He/Lost')
            .add({
          'description': descriptione,
          'location': locatione,
          'data': datee,
          'color': colore,
          'Country': citye,
          'user_id': id,
          'phoneNumber' : phone,
          'urlImage': urls
        }).whenComplete(() => Navigator.pushReplacement(context,
            PageTransition(child:thankSplashScreen() ,
                type: PageTransitionType.topToBottom , duration: Duration(milliseconds: 500)
            )
        ));
      } catch (e) {
        print('Error >>>>.........' + e.toString());
      }
    } else {
      try {
        await FirebaseFirestore.instance
            .collection('products/ZcZ5UQqaDgnwU4hWE4He/Find')
            .add({
          'description': descriptione,
          'location': locatione,
          'data': datee,
          'phoneNumber' : phone,
          'color': colore,
          'Country': citye,
          'user_id': id,
          'urlImage': urls
        }).whenComplete(() => Navigator.pushReplacement(context,
            PageTransition(child:thankSplashScreen() ,
                type: PageTransitionType.topToBottom , duration: Duration(milliseconds: 500)
            )
        ));
      } catch (e) {
        print('Error >>>>.........' + e.toString());
      }
    }
  }

  void AddToUrlList (String url ){
    print('In  AddToUrlList Function  ..........');
    if(url != null){
      print('url is not null>>>>  ..........');
      setState(() {
        urls.add(url);
      });
    }
    print('Added in urls List..........');
  }

  // Uploading Progress
  bool uploading = false ;
  double val = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        centerTitle: true,
        title: Text('Pick Images' , style: TextStyle(color: Colors.black , fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            fontSize: 25),),
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
            // Container(
            //   margin: EdgeInsets.only(top: 15),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       CircleAvatar(
            //         radius: 7,
            //         backgroundColor: Colors.white,
            //       ),
            //       SizedBox(width: 10),
            //       CircleAvatar(
            //         radius: 7,
            //         backgroundColor: Colors.pink,
            //       ),
            //     ],
            //   ),
            // ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 130, horizontal: 100),
              child: SizedBox(
                width: 500,
                child: RaisedButton(
                    color: Colors.black87,
                    elevation: 20,
                    disabledColor: Colors.white,
                    onPressed: () {
                      if(_images != null ){
                        setState(() {
                          uploading = true;
                        });
                        inputData();
                      }
                      else{
                        null;
                      }
                    },
                    splashColor: Colors.white,
                    child: Row(
                      children: [
                        Text('Upload',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 25,
                                color:_images.isEmpty? Colors.white:Colors.pinkAccent

                            ),
                            textAlign: TextAlign.center),
                        SizedBox(width: 20),
                        Icon(Icons.upload_rounded, color: Colors.pink),
                      ],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
              ),
            ),
            Container(
              width: 400,
              // padding: EdgeInsetsGeometry.infinity,
              margin: EdgeInsets.only(top: 200),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                color: Colors.white10,
              ),
              child: Stack(
                children: [
                  uploading
                      ?Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Uploading...',style: TextStyle(fontSize: 20,fontStyle: FontStyle.italic,color: Colors.pink)),
                        SizedBox(height: 20),
                        CircularProgressIndicator(
                          value: val,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
                        )
                      ],
                    ),
                  )
                      :Container(),
                  GridView.builder(
                    itemCount: _images.length + 1,
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                    itemBuilder: (context, index) {
                      return index == 0
                          ? Center(
                        child: IconButton(
                          onPressed: ChoosImage,
                          icon: Icon(
                            Icons.add,
                            size: 50,
                            color: Colors.pink,
                          ),
                        ),
                      )
                          : Container(
                        margin: EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: FileImage(_images[index - 1]),
                              fit: BoxFit.cover),
                        ),
                      );
                    },
                  ),

                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}
