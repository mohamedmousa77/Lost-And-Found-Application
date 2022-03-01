import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lost/Help.dart';
import 'package:lost/Info.dart';
import 'package:lost/MyPost.dart';
import 'dart:math';
import 'package:lost/Profile.dart';
import 'package:lost/chat-screen.dart';
import 'package:share/share.dart';
import 'Finded_screen.dart';
import 'LostPage.dart';
import 'Losteed_screen.dart';
import 'package:toast/toast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'mychat.dart';
import 'package:url_launcher/url_launcher.dart';

class AddOrRwmovePage extends StatelessWidget {
  @override 
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyPainterF extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    Paint linepaint = Paint()
      ..color =Colors.white
      ..strokeWidth = 3;
    canvas.drawLine(Offset(100,225), Offset(100,400), linepaint);
    canvas.drawLine(Offset(270,203), Offset(290,360), linepaint);
    canvas.drawLine(Offset(190,250), Offset(190,575), linepaint);
  }

  @override
  bool shouldRepaint( CustomPainter old) {
    return true;
  }

}

class MyHomePageState extends State<MyHomePage> {
  double value = 0;
  final FirebaseAuth auth = FirebaseAuth.instance;
  String UserId;
  String FirstName = '' ;
  String UserImageUrl;
  String LastName ;

  AnimationController _controller ;

  void inputData() {
    final User user = auth.currentUser;
    final uid = user.uid;
    setState(() {
      UserId = uid;
    });
    fatchData(uid);
  }

  Future<String> fatchData(String userId) async {
    final userData = await FirebaseFirestore.instance
        .collection('products/ZcZ5UQqaDgnwU4hWE4He/user')
        .doc(userId)
        .get();
    FirstName = userData['Firstname'];
    LastName = userData['lastname'];
    UserImageUrl = userData['imageUrl']==null ? null :userData['imageUrl'] ;
  }


// Double Click To Exit
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

  @override
  void initState() {
    // TODO: implement initState
    inputData();
    super.initState();
  }

  String url = "https://play.google.com/store/apps/details?id=com.mohamed.findme";

  // double ratingg =0 ;
  // Widget buildRating()=>RatingBar.builder(
  //   minRating: 1,
  //     itemSize: 36,
  //     itemPadding: EdgeInsets.symmetric(horizontal: 4),
  //     itemBuilder: (context , _) => Icon(Icons.star , color: Colors.amberAccent),
  //     onRatingUpdate: (rating) {
  //     setState(() {
  //       ratingg = rating ;
  //     });
  //     }
  // );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.pink,
                  Colors.pinkAccent,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          SafeArea(
              child: Container(
            width: 200.0,
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                DrawerHeader(
                    child: Column(
                  children: [
                   InkWell(
                     child:  UserImageUrl == null
                         ? CircleAvatar(
                          radius: 50,
                         backgroundColor: Colors.pinkAccent,
                       backgroundImage:AssetImage('images/person_1.png'),
                     )
                         : Container(
                           child: CircleAvatar(
                             radius: 50,
                             child: Image.network(UserImageUrl),
                            backgroundColor: Colors.pinkAccent
                       ),
                     ),
                   ),
                        SizedBox(height: 20),
                        FirstName.isEmpty ? Center(child: Text('Sir ?')) : Text(FirstName + ' ' + LastName),
                  ],
                )
                ),
                SizedBox(height: 10),
                Divider(color: Colors.white,),
                Expanded(
                    child: ListView(
                     children: [
                    ListTile(
                         onTap: () => Navigator.push(context,
                             PageTransition(child: MyChat(),
                                 type: PageTransitionType.topToBottom , duration: Duration(milliseconds: 500)
                             )),
                         leading: Icon(Icons.chat, color: Colors.white),
                         title:
                         Text("My Chat", style: TextStyle(color: Colors.white)),
                       ),
                    ListTile(
                      onTap: () => Navigator.pushReplacement(
                          context, PageTransition(child:Help() ,
                          type: PageTransitionType.topToBottom , duration: Duration(milliseconds: 500)
                      )

    //
                      ),
                      leading: Icon(Icons.help, color: Colors.white),
                      title:
                          Text("help!", style: TextStyle(color: Colors.white)),
                    ),
                    Divider(color: Colors.white,),
                    // ListTile(
                    //   onTap: () => Navigator.push(context,
                    //       PageTransition(child: AddOrRwmovePage(),
                    //           type: PageTransitionType.topToBottom , duration: Duration(milliseconds: 500)
                    //       )),
                    //   leading: Icon(Icons.info, color: Colors.white),
                    //   title:
                    //       Text("info!", style: TextStyle(color: Colors.white)),
                    // ),
                    ListTile(
                      leading: Icon(Icons.share, color: Colors.white),
                      title:
                      Text("Share", style: TextStyle(color: Colors.white)),
                         onTap: (){
                           Share.share(url);
                         },
                       ),
                    ListTile(
                         onTap: () =>launch(url),
                         leading: Icon(Icons.star_rate, color: Colors.white),
                         title:
                         Text("Rate", style: TextStyle(color: Colors.white)),
                       ),
                    SizedBox(height: 120),
                    ListTile(
                         onTap: () {
                           showDialog(
                               barrierColor: Colors.black.withOpacity(0.9),
                               context: context,
                               builder: (BuildContext ctx) {
                                 return AlertDialog(
                                   shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(20),
                                   ),
                                   backgroundColor: Colors.pink,
                                   title: Text(
                                       'Are you sure you want to sign out ?',
                                       style: TextStyle(
                                           color: Colors.white,
                                           fontStyle: FontStyle.italic,
                                           fontSize: 20)),
                                   content: Column(
                                     mainAxisSize: MainAxisSize.min,
                                     children: [
                                       SizedBox(
                                         child: RaisedButton(
                                             onPressed: () {
                                               FirebaseAuth.instance.signOut();
                                               Navigator.pop(ctx);
                                             },
                                             child: Text('YES, SIGN OUT' , style: TextStyle(color: Colors.black),),
                                             shape: RoundedRectangleBorder(
                                                 borderRadius: BorderRadius.circular(20)
                                             ),
                                             color : Colors.pinkAccent
                                         ),
                                         height: 50,
                                         width: double.infinity,
                                       ),
                                       SizedBox(height: 10),
                                       SizedBox(
                                         child: RaisedButton(
                                           shape: RoundedRectangleBorder(
                                               borderRadius: BorderRadius.circular(20)
                                           ),
                                           onPressed: () => Navigator.pop(ctx),
                                           child: Text('NO' , style: TextStyle(color: Colors.white),),
                                           color: Colors.black,
                                         ),
                                         height: 50,
                                         width: double.infinity,
                                       ),
                                     ],
                                   ),
                                 );
                               });
                         },
                         leading: Icon(Icons.logout, color: Colors.white),
                         title:
                         Text("Logout", style: TextStyle(color: Colors.white)),
                       ),
                  ],
                )
                )
              ],
            ),
          )
          ),
          TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: value),
              duration: Duration(milliseconds: 500),
              builder: (_, double val, __) {
                return (
                    Transform(
                  transform: Matrix4.identity()
                    ..setEntry(0, 2, 0.001)
                    ..setEntry(0, 3, 200 * val)
                    ..rotateY((pi / 6) * val),
                  child: Scaffold(
                    body: WillPopScope(
                      onWillPop:onClicktoExit,
                      child:  Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: double.infinity,
                            padding: EdgeInsets.only(top: 175, left: 20),
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
                              padding: EdgeInsets.all(20),
                              margin: EdgeInsets.only(top: 20),
                              child:SizedBox(
                                  height: 200,
                                  width: 800,
                                  child: Image.asset('images/find-Me.jpg',fit: BoxFit.fill,))
                          ),
                          // Container(
                          //   color: Colors.white,
                          //   child: CustomPaint(
                          //     painter: MyPainterF(),
                          //   ),
                          // ),
                          Container(
                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(24),
                                                color:Color.fromRGBO(61, 51, 60,0.5),
                                              ),
                              margin: EdgeInsets.only(left: 185 , top: 250),
                              child: InkWell(
                                onTap: () => Navigator.pushReplacement(
                                    context, PageTransition(child: lostedScreen(),
                                    type: PageTransitionType.scale ,
                                    alignment: Alignment.centerLeft,
                                    duration: Duration(milliseconds: 500))),
                                child: CircleAvatar(
                                  backgroundColor: Colors.black,
                                  radius: 80,
                                  child:
                                  Image.asset('images/Lost.jpg',fit: BoxFit.contain , width: 100),
                                ),
                              ),
                            ),
                          Container(
                            decoration: BoxDecoration(
                                               borderRadius: BorderRadius.circular(24),
                                               color: Color.fromRGBO(61, 51, 60,0.5),
                                             ),
                            margin: EdgeInsets.only(left: 185 , top: 450),
                            child:  InkWell(
                              onTap: () => Navigator.pushReplacement(
                                  context, PageTransition(child: findedScreen(),
                                  type: PageTransitionType.scale,
                                  duration: Duration(milliseconds:500),alignment: Alignment.centerRight)),
                              child: CircleAvatar(
                                backgroundColor: Colors.black,
                                radius: 80,
                                child :
                                Image.asset('images/Find.jpg',fit: BoxFit.contain , width: 100),
                              ),
                            ),
                          ),
                          Container(
                            decoration : BoxDecoration(
                              borderRadius : BorderRadius.circular(24),
                              color : Color.fromRGBO(61, 51, 60,0.5)
                            ),
                            margin: EdgeInsets.only(left: 20 , top: 275),
                            padding: EdgeInsets.only(),
                            height: 300 ,
                            width: 150,
                            child : InkWell(
                              onTap: () => Navigator.pushReplacement(
                              context,PageTransition(child: LostPage(),
                                   type: PageTransitionType.bottomToTop,duration: Duration(milliseconds: 500))),
                              child: CircleAvatar(
                                backgroundColor: Colors.black,
                                radius: 80,
                               child:
                                Image.asset('images/Post.jpg',fit : BoxFit.contain , width: 100),
                              ),



                                  ),
                                ),
                        ],
                      ),
                    ),
                    bottomNavigationBar: CurvedNavigationBar(
                      items: [
                        Icon(Icons.home , size: 30, color: Colors.white),
                        Icon(Icons.person , size: 30, color: Colors.white),
                        Icon(Icons.person_search_rounded , size: 30, color: Colors.white),
                      ],
                      onTap: (index){
                        if(index == 1){
                          Navigator.pushReplacement(
                              context, PageTransition(child:LoginPage (),
                              type: PageTransitionType.scale ,alignment: Alignment.bottomCenter, duration: Duration(milliseconds: 500)
                          )
                            //
                          );
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
                      animationCurve: Curves.bounceIn,
                      animationDuration:  Duration(milliseconds: 300),
                      color: Colors.pink,
                      backgroundColor: Colors.black,
                      height: 60,
                    ),
                  ),
                ));
              }
              ),
          GestureDetector(
            onHorizontalDragUpdate: (e) async {
              if (e.delta.dx > 0) {
                setState(() {
                  value = 1;
                });
              } else {
                setState(() {
                  value = 0;
                });
              }
            },
          )
        ],
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
