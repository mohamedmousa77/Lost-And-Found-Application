import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';
import 'package:lost/AddOrRwmovePage.dart';
import 'package:lost/second_findpage_screen.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:lost/splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:toast/toast.dart';
import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;

class LostPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomePage();
  }
}

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint linepaint = Paint()
      ..color = lost ? Colors.pink : Colors.white
      ..strokeWidth = 3;
    Paint linepaintL = Paint()
      ..color = lost ? Colors.white : Colors.pink
      ..strokeWidth = 3;
    Paint cirle1 = Paint()
      ..color = lost ? Colors.pink : Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    Paint cirle2 = Paint()
      ..color = lost ? Colors.white : Colors.pinkAccent
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(92, 0), Offset(92, 50), linepaint);
    canvas.drawLine(Offset(270, 0), Offset(270, 50), linepaintL);
    canvas.drawCircle(Offset(92, 100), 50, cirle1);
    canvas.drawCircle(Offset(270, 100), 50, cirle2);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return true;
  }
}

bool lost = true;

class HomePageState extends State<HomePage> {
  // Double Click To Exit
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

  var _descriptionController = TextEditingController();
  var _phonenumberController = TextEditingController();
  var _locationController = TextEditingController();

  DateTime SelectData = DateTime.now();
  Color CurrentColore = Colors.black;
  String CountryChoses;
  List listItem = [
    'Alexandria Governorate',
    'Aswan Governorate',
    'Asyut Governorate',
    'Beheira Governorate',
    'Beni Suef Governorate',
    'Cairo Governorate',
    'Dakahlia Governorate',
    'Damietta Governorate',
    'Faiyum Governorate',
    'Gharbia Governorate',
    'Giza Governorate',
    'Ismailia Governorate',
    'Kafr El Sheikh Governorate',
    'Luxor Governorate',
    'Matruh Governorate',
    'Minya Governorate',
    'Monufia Governorate',
    'New Valley Governorate',
    'North Sinai Governorate',
    'Port Said Governorate',
    'Qalyubia Governorate',
    'Qena Governorate',
    'Red Sea Governorate',
    'Sharqia Governorate',
    'Sohag Governorate',
    'South Sinai Governorate',
    'Suez Governorate'
  ];

  void _dataPicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value != null) {
        setState(() {
          SelectData = value;
        });
      }
    });
  }

  void ChooseColore(Color colore) {
    setState(() {
      CurrentColore = colore;
    });
  }

  dropDown() {
    return DropdownButton(
      icon: Icon(Icons.location_city_rounded, color: Colors.white),
      dropdownColor: Colors.pinkAccent,
      hint: new Text('Select Country',
          style: TextStyle(
              color: Colors.pinkAccent,
              fontSize: 20,
              fontStyle: FontStyle.italic)),
      value: CountryChoses,
      items: listItem.map((ValueItem) {
        return DropdownMenuItem(
            value: ValueItem,
            child: Text(ValueItem,
                style: TextStyle(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    fontSize: 20)));
      }).toList(),
      onChanged: (newvalue) {
        setState(() {
          CountryChoses = newvalue;
        });
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
        barrierColor: Colors.black.withOpacity(0.9),
        context: context,
        builder: (ctx) =>
            AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.pink,
                title: Text("OOPS", style: TextStyle(color: Colors.black)),
                content: Text(message, style: TextStyle(fontSize: 20 , color: Colors.white)),
                actions: [
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)
                      ),
                      color: Colors.black,
                      child: Text('Okay',textAlign: TextAlign.center, style: TextStyle( fontSize: 20,color: Colors.white)),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  )
                ],
              ),
        );
  }

  void _submit() {
    if (_descriptionController.text.isEmpty ||_locationController.text.isEmpty || CountryChoses == null )
    {
      _showErrorDialog("Invalid Data ! ");
      return null ;
    }
    // else if (_locationController.text.isEmpty) {
    //   _showErrorDialog("Invalid location");
    //   return null;
    // }
    // else if (CountryChoses == null) {
    //   _showErrorDialog("Choose Country");
    //   return null;
    // }
    else if( _phonenumberController.text.isEmpty){
      showDialog(
          barrierColor: Colors.black.withOpacity(0.9),
          context: context,
          builder: (BuildContext ctxx) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: Colors.pink,
              title: Text('Submit',
                  style: TextStyle(
                      color: Colors.black,
                      fontStyle: FontStyle.italic,
                      fontSize: 30)),
              content: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                        'Add a phone number to facilitate communication with you ',
                        style: TextStyle(
                            color: Colors.white,
                            fontStyle:
                            FontStyle.italic,
                            fontSize: 18)),
                    Text(
                        'Do you want to add? ',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.white,
                            fontStyle:
                            FontStyle.italic,
                            fontWeight: FontWeight.w500,
                            fontSize: 20
                        )),
                    SizedBox(height: 20),
                    Column(
                      children: [
                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            onPressed: () =>
                                Navigator.pop(ctxx),
                            color: Colors.black,
                            child: Text('YES , Back' , style: TextStyle(color: Colors.white),),
                          ),

                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            color: Colors.pinkAccent,
                            child: Text('SKIP , Next' , style: TextStyle(color: Colors.black),),
                            onPressed: () {
                              Navigator.pop(ctxx);
                              showDialog(
                                  barrierColor: Colors.black.withOpacity(0.9),
                                  context: context,
                                  builder: (BuildContext ctx) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      backgroundColor: Colors.pink,
                                      title: Text( 'Submit',
                                          style: TextStyle(
                                              color: Colors .black,
                                              fontStyle:FontStyle .italic,
                                              fontSize:30)
                                      ),
                                      content:Container(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                                'Do you want Select image? ',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: 18)),
                                            SizedBox(height: 20),
                                            Column(
                                              children: [
                                                SizedBox(
                                                  height: 50,
                                                  width:double.infinity,
                                                  child: RaisedButton(
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                                    color: Colors.black,
                                                    child: Text('YES,I WANT' , style: TextStyle(color: Colors.white),),
                                                    onPressed: () {
                                                      Navigator.pop(ctx);
                                                      _submitWithImages();
                                                    },
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                SizedBox(
                                                  height: 50,
                                                  width:double.infinity,
                                                  child: RaisedButton(
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                                    child: Text('NO,I DONOT' , style: TextStyle(color: Colors.black),),
                                                    color: Colors.pinkAccent,
                                                    onPressed: () {
                                                      Navigator.pop(ctx);
                                                      // _submit();
                                                      inputData();
                                                      Navigator.push(context, PageTransition(child: thankSplashScreen(),
                                                          type: PageTransitionType.topToBottom, duration: Duration(milliseconds: 500))
                                                        //
                                                      );
                                                    },

                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            },

                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          });
    }
  }

  // Get User Id
  final FirebaseAuth auth = FirebaseAuth.instance;
  String userId;

  void inputData() {
    print('In inputData Function ...........');
    final User user = auth.currentUser;
    AddNewLost(user.uid);
    setState(() {
      userId = user.uid;
    });
  }

  void AddNewLost(String Id_user) async {
    if (lost) {
      try {
        await FirebaseFirestore.instance
            .collection('products/ZcZ5UQqaDgnwU4hWE4He/Lost')
            .add({
          'description': _descriptionController.text,
          'location': _locationController.text,
          'data': SelectData.toString(),
          'color': CurrentColore.toString(),
          'Country': CountryChoses,
          'user_id': Id_user,
          'urlImage': null,
          'phoneNumber': _phonenumberController.text.isEmpty
              ? null
              : _phonenumberController.text
        });
      } catch (e) {
        print('Error >>>>.........' + e.toString());
      }
    } else {
      try {
        await FirebaseFirestore.instance
            .collection('products/ZcZ5UQqaDgnwU4hWE4He/Find')
            .add({
          'description': _descriptionController.text,
          'location': _locationController.text,
          'data': SelectData.toString(),
          'color': CurrentColore.toString(),
          'Country': CountryChoses,
          'user_id': Id_user,
          'urlImage': null,
          'phoneNumber': _phonenumberController.text.isEmpty
              ? null
              : _phonenumberController.text
        });
      } catch (e) {
        print('Error >>>>.........' + e.toString());
      }
    }
  }

  // Pass Data
  void _submitWithImages() {
    if (_descriptionController.text.isEmpty) {
      _showErrorDialog("Invalid Description");
    } else if (_locationController.text.isEmpty) {
      _showErrorDialog("Invalid location");
    } else if (CountryChoses == null) {
      _showErrorDialog("Choose Country");
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => SecondlostPage(
                    locatione: _locationController.text,
                    descriptione: _descriptionController.text,
                    datee: SelectData.toString(),
                    colore: CurrentColore.toString(),
                    country: CountryChoses,
                    user_id: userId,
                    type: lost,
                  )));
    }
  }

  void showdialog() {
    slideDialog.showSlideDialog(
        pillColor: Colors.pink,
        backgroundColor: Colors.black,
        barrierColor: Colors.black.withOpacity(0.9),
        barrierDismissible: false,
        context: context,
        child: Column(
          children: [
            Text(
              'Are you sure do you want cancel?',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            SizedBox(height: 20),
            Container(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                  width: 200,
                  child: RaisedButton(
                    child: Text('NO I DO NOT WANT'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: Colors.pinkAccent,
                  ),
                ),
                SizedBox(height: 25),
                SizedBox(
                  child: RaisedButton(
                    child: Text('YES, I WANT'),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                          context,
                          PageTransition(
                              child: AddOrRwmovePage(),
                              type: PageTransitionType.topToBottom,
                              duration: Duration(milliseconds: 500)));
                    },
                    color: Colors.white60,
                  ),
                  height: 50,
                  width: 200,
                ),
              ],
            )),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                      barrierColor: Colors.black.withOpacity(0.9),
                      context: context,
                      builder: (ctx) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            backgroundColor: Colors.pink,
                            title: Container(
                              decoration: BoxDecoration(
                                // color: Colors.white,
                                shape: BoxShape.rectangle,
                              ),
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Are you sure do you want cancel?',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                            content: Container(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Column(
                                    children: [
                                      SizedBox(
                                        height: 50,
                                        width: double.infinity,
                                        child: RaisedButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(14)
                                          ),
                                          onPressed: () {
                                            Navigator.pop(ctx);
                                          },
                                          color: Colors.black,
                                          child: Text('NO I DO NOT WANT',style: TextStyle(color: Colors.white),),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      SizedBox(
                                        child: RaisedButton(
                                          child: Text('YES, I WANT'),
                                          color: Colors.pinkAccent,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(14)
                                          ),
                                          onPressed: () {

                                            Navigator.pop(ctx);
                                            Navigator.pushReplacement(
                                                context,
                                                PageTransition(
                                                    child: AddOrRwmovePage(),
                                                    type: PageTransitionType
                                                        .topToBottom,
                                                    duration: Duration(
                                                        milliseconds: 500)));
                                          },

                                        ),
                                        height: 50,
                                        width: double.infinity,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ));
                },
                icon: Icon(
                  Icons.home,
                  color: Colors.white,
                  size: 30,
                ))
          ],
          centerTitle: true,
          backgroundColor: Colors.pink,
          title: Text("POST",
              style: TextStyle(
                  color: Colors.black,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  fontSize: 25)),
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
            Container(
              color: Colors.pinkAccent,
              child: CustomPaint(
                painter: MyPainter(),
              ),
            ),
            SingleChildScrollView(
              child: Column(
              children: [
                Container(
                  constraints: BoxConstraints(maxHeight: 530),
                  margin: EdgeInsets.only(top: 165),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: TextFormField(
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.pink)),
                              contentPadding: EdgeInsets.all(10),
                              icon:Icon(Icons.description, color: Colors.white),
                              labelText: 'Description',
                              labelStyle: TextStyle(color: Colors.pinkAccent)),
                          controller: _descriptionController,
                          style: TextStyle(color: Colors.white),
                          keyboardType: TextInputType.text,
                          // validator: (val) {
                          //   if (val.isEmpty) {
                          //     _showErrorDialog('please write a description');
                          //     return;
                          //   }
                          //   return null;
                          // },
                        ),
                      ),
                      SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: TextFormField(
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.pink)),
                              icon:
                                  Icon(Icons.location_on, color: Colors.white),
                              contentPadding: EdgeInsets.all(10),
                              labelText: 'Location',
                              labelStyle: TextStyle(color: Colors.pinkAccent)),
                          controller: _locationController,
                          style: TextStyle(color: Colors.white),
                          keyboardType: TextInputType.text,
                          // validator: (val) {
                          //   if (val.isEmpty) {
                          //     _showErrorDialog('Invalid location');
                          //     return;
                          //   }
                          //   return null;
                          // },
                        ),
                      ),
                      SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: TextFormField(
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.pink)),
                              icon: Icon(Icons.phone, color: Colors.white),
                              contentPadding: EdgeInsets.all(10),
                              // hintText: 'to facilitate communication with you',
                              // hintStyle: TextStyle(color: Colors.white , fontSize: 10),
                              labelText: 'Phone Number',
                              labelStyle: TextStyle(color: Colors.pinkAccent)
                          ),
                          controller: _phonenumberController,
                          style: TextStyle(color: Colors.white),
                          keyboardType: TextInputType.phone,
                          // validator: (val) {
                          //   if (val.isEmpty) {
                          //     _showErrorDialog('Invalid location');
                          //     return;
                          //   }
                          //   return null;
                          // },
                        ),
                      ),
                      SizedBox(height: 10),
                      dropDown(),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 50,
                            child: RaisedButton(
                              color: Colors.black,
                              child: Text(
                                "${DateFormat.yMMMMd().format(SelectData == null ? DateTime.now() : SelectData)}",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.pinkAccent),
                              ),
                              onPressed: _dataPicker,
                            ),
                          ),
                          SizedBox(width: 20),
                          SizedBox(
                            height: 50,
                            child: RaisedButton(
                                child: Text("Choose color",
                                    style: TextStyle(
                                        color: CurrentColore == Colors.black
                                            ? Colors.pinkAccent
                                            : Colors.white,
                                        fontSize: 14)),
                                color: CurrentColore,
                                textColor: Theme.of(context)
                                    .primaryTextTheme
                                    .button
                                    .color,
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext ctx) {
                                        return AlertDialog(
                                          title: Text("Select color",
                                              style: TextStyle(fontSize: 22)),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SingleChildScrollView(
                                                child: Column(
                                                  children: [
                                                    BlockPicker(
                                                      pickerColor:
                                                          CurrentColore,
                                                      onColorChanged:
                                                          ChooseColore,
                                                    ),
                                                    RaisedButton(
                                                        child: Text('Done'),
                                                        onPressed: () =>
                                                            Navigator.pop(ctx))
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      });
                                }),
                          ),
                        ],
                      ),
                      SizedBox(height: 70),
                      SizedBox(
                        width: 150,
                        height: 50,
                        child: RaisedButton(
                          color: Colors.pinkAccent,
                          child: Text('Submit',style: TextStyle(fontStyle: FontStyle.italic, fontSize: 30)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20))),
                          onPressed: () => _submit()
                          // {
                          //   _phonenumberController.text.isEmpty
                          //       ? showDialog(
                          //           context: context,
                          //           builder: (BuildContext ctxx) {
                          //             return AlertDialog(
                          //               backgroundColor: Colors.black,
                          //               title: Text('Submit',
                          //                   style: TextStyle(
                          //                       color: Colors.white,
                          //                       fontStyle: FontStyle.italic,
                          //                       fontSize: 30)),
                          //               content: Container(
                          //                 child: Column(
                          //                   mainAxisSize: MainAxisSize.min,
                          //                   children: [
                          //                     Text(
                          //                         'Add a phone number to facilitate communication with you \n Do you want to add? ',
                          //                         style: TextStyle(
                          //                             color: Colors.white,
                          //                             fontStyle:
                          //                                 FontStyle.italic,
                          //                             fontSize: 18)),
                          //                     SizedBox(height: 20),
                          //                     Column(
                          //                       children: [
                          //                         SizedBox(
                          //                           child: RaisedButton(
                          //                             onPressed: () =>
                          //                                 Navigator.pop(ctxx),
                          //                             color: Colors.pinkAccent,
                          //                             child: Text('YES'),
                          //                           ),
                          //                           height: 50,
                          //                           width: double.infinity,
                          //                         ),
                          //                         SizedBox(height: 10),
                          //                         SizedBox(
                          //                           height: 50,
                          //                           width: double.infinity,
                          //                           child: RaisedButton(
                          //                             child: Text('SKIP'),
                          //                             onPressed: () {
                          //                               Navigator.pop(ctxx);
                          //                               showDialog(
                          //                                   context: context,
                          //                                   builder:
                          //                                       (BuildContext
                          //                                           ctx) {
                          //                                     return AlertDialog(
                          //                                       backgroundColor: Colors.black,
                          //                                       title: Text( 'Submit',
                          //                                           style: TextStyle(
                          //                                               color: Colors .white,
                          //                                               fontStyle:FontStyle .italic,
                          //                                               fontSize:30)
                          //                                       ),
                          //                                       content:
                          //                                           Container(
                          //                                         child: Column(
                          //                                           mainAxisSize: MainAxisSize.min,
                          //                                           children: [
                          //                                             Text(
                          //                                                 'Do you want Select image? ',
                          //                                                 style: TextStyle(
                          //                                                     color: Colors.white,
                          //                                                     fontStyle: FontStyle.italic,
                          //                                                     fontSize: 18)),
                          //                                             SizedBox(height: 20),
                          //                                             Column(
                          //                                               children: [
                          //                                                 SizedBox(
                          //                                                   child:
                          //                                                       RaisedButton(
                          //                                                     onPressed: () {
                          //                                                       Navigator.pop(ctx);
                          //                                                       _submitWithImages();
                          //                                                     },
                          //                                                     color: Colors.pinkAccent,
                          //                                                     child: Text('YES'),
                          //                                                   ),
                          //                                                   height:
                          //                                                       50,
                          //                                                   width:
                          //                                                       double.infinity,
                          //                                                 ),
                          //                                                 SizedBox(height: 10),
                          //                                                 SizedBox(
                          //                                                   height:
                          //                                                       50,
                          //                                                   width:
                          //                                                       double.infinity,
                          //                                                   child:
                          //                                                       RaisedButton(
                          //                                                     onPressed: () {
                          //                                                       Navigator.pop(ctx);
                          //                                                       _submit();
                          //                                                       Navigator.push(context, PageTransition(child: thankSplashScreen(), type: PageTransitionType.topToBottom, duration: Duration(milliseconds: 500))
                          //                                                           //
                          //                                                           );
                          //                                                     },
                          //                                                     child: Text('SKIP'),
                          //                                                   ),
                          //                                                 )
                          //                                               ],
                          //                                             )
                          //                                           ],
                          //                                         ),
                          //                                       ),
                          //                                     );
                          //                                   });
                          //                             },
                          //
                          //                           ),
                          //                         )
                          //                       ],
                          //                     )
                          //                   ],
                          //                 ),
                          //               ),
                          //             );
                          //           })
                          //       : showDialog(
                          //           context: context,
                          //           builder: (BuildContext ctx) {
                          //             return AlertDialog(
                          //               backgroundColor: Colors.black,
                          //               title: Text('Submit',
                          //                   style: TextStyle(
                          //                       color: Colors.white,
                          //                       fontStyle: FontStyle.italic,
                          //                       fontSize: 30)),
                          //               content: Container(
                          //                 child: Column(
                          //                   mainAxisSize: MainAxisSize.min,
                          //                   children: [
                          //                     Text('Do you want Select image? ',
                          //                         style: TextStyle(
                          //                             color: Colors.white,
                          //                             fontStyle:
                          //                                 FontStyle.italic,
                          //                             fontSize: 18)),
                          //                     SizedBox(height: 20),
                          //                     Column(
                          //                       children: [
                          //                         SizedBox(
                          //                           child: RaisedButton(
                          //                             onPressed: () {
                          //                               Navigator.pop(ctx);
                          //                               _submitWithImages();
                          //                             },
                          //                             color: Colors.pinkAccent,
                          //                             child: Text('YES'),
                          //                           ),
                          //                           height: 50,
                          //                           width: double.infinity,
                          //                         ),
                          //                         SizedBox(height: 10),
                          //                         SizedBox(
                          //                           height: 50,
                          //                           width: double.infinity,
                          //                           child: RaisedButton(
                          //                             onPressed: () {
                          //                               Navigator.pop(ctx);
                          //                               _submit();
                          //                               Navigator.push(context,
                          //                                   PageTransition(
                          //                                       child: thankSplashScreen(),
                          //                                       type: PageTransitionType.topToBottom, duration: Duration(milliseconds: 500)));
                          //                             },
                          //                             child: Text('SKIP'),
                          //                           ),
                          //                         )
                          //                       ],
                          //                     )
                          //                   ],
                          //                 ),
                          //               ),
                          //             );
                          //           });
                          // },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )),
            Container(
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      print ('is Clicked  ');
                      setState(() {
                        lost = true;
                      });
                    },
                    child: Container(
                        margin: EdgeInsets.only(top: 80, left: 65),
                        child: Text('Lost',
                            style: TextStyle(
                                color: lost ? Colors.pink : Colors.white,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.italic,
                                fontSize: 30))
                    ),
                  ),
                  SizedBox(width: 50),
                  GestureDetector(
                    child: Container(
                      margin: EdgeInsets.only(top: 80, left: 70),
                      child: Text('Find',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.italic,
                              color: lost ? Colors.white : Colors.pink,
                              fontSize: 30)),
                    ),
                    onTap: () {
                      print ('is Clicked  ');
                      setState(() {
                        lost = false;

                      });
                    },
                  ),

                ],
              ),
              //       SizedBox(height: 15),
              // //       Container(
              // //   child: Row(
              // //     mainAxisAlignment: MainAxisAlignment.center,
              // //     children: [
              // //       CircleAvatar(
              // //         child: Icon(Icons.star_purple500_outlined,
              // //             color: Colors.pink, size: 25),
              // //         radius: 15,
              // //         backgroundColor: Colors.black26,
              // //       ),
              // //       CircleAvatar(
              // //         child:
              // //             Icon(Icons.circle, color: Colors.white38, size: 25),
              // //         radius: 15,
              // //         backgroundColor: Colors.black26,
              // //       ),
              // //     ],
              // //   ),
              // // ),
              //       SizedBox(height: 30),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //   children: [
              //     InkWell(
              //       onTap: () {
              //         setState(() {
              //           lost = false;
              //         });
              //       },
              //       child: CircleAvatar(
              //         radius: 45,
              //         backgroundColor:
              //             lost ? Colors.white38 : Colors.pinkAccent,
              //         child: Text('Find',
              //             style: TextStyle(
              //                 fontStyle: FontStyle.italic,
              //                 fontSize: 30,
              //                 color: Colors.black87,
              //                 fontWeight: FontWeight.bold)),
              //       ),
              //     ),
              //     InkWell(
              //       onTap: () {
              //         setState(() {
              //           lost = true;
              //         });
              //       },
              //       child: CircleAvatar(
              //         radius: 45,
              //         backgroundColor:
              //             lost ? Colors.pinkAccent : Colors.white38,
              //         child: Text('Lost',
              //             style: TextStyle(
              //                 fontStyle: FontStyle.italic,
              //                 fontSize: 30,
              //                 color: Colors.black87,
              //                 fontWeight: FontWeight.bold)),
              //       ),
              //     ),
              //   ],
              // ),
              //       SizedBox(height: 20),
            ),
          ]),
        ));
  }
}

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}
