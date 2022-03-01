import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:toast/toast.dart';

import 'AddOrRwmovePage.dart';
import 'ProductDetails.dart';
import 'Profile.dart';

class MyPost extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyPostState();
  }
}

class product {
  final String colore;
  final String datee;
  final String locatione;
  final String descriptione;
  final String Country;
  final String user_id;

  final String urlIma;
  final String phoneNumber;
  final List urlss;

  product({
    @override this.colore,
    @override this.datee,
    @override this.locatione,
    @override this.descriptione,
    @override this.Country,
    @override this.user_id,
    @override this.urlIma,
    @override this.phoneNumber,
    @override this.urlss,
  });
}

class MyPostState extends State<MyPost> {
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

  // Fetch Data
  String color;
  String date;
  String location;
  String description;
  String Country;
  String phoneNumber;
  List<product> prodList = [];

  List urls = [];
  List<String> user_ids = [];

  String url;

  bool isLoading = true;

  // Get Current user id
  final FirebaseAuth auth = FirebaseAuth.instance;
  String user_id;

  String Usser;

  void getuserID() async {
    final User user = auth.currentUser;
    setState(() {
      Usser = user.uid;
    });
    print(user_id);
  }

  // Fetch Lost Lost Data
  void fetchId() async {
    await FirebaseFirestore.instance
        .collection('products/ZcZ5UQqaDgnwU4hWE4He/Lost')
        .get()
        .then((QuerySnapshot snapshot) =>
            snapshot.docs.forEach((DocumentSnapshot docuser) async {
              fetchLostData(docuser.id);
            }));
  }

  Future<void> fetchLostData(String userId) async {
    final lostData = await FirebaseFirestore.instance
        .collection('products/ZcZ5UQqaDgnwU4hWE4He/Lost')
        .doc(userId)
        .get();
    setState(() {
      color = lostData['color'];
      date = lostData['data'];
      location = lostData['location'];
      description = lostData['description'];
      Country = lostData['Country'];
      user_id = lostData['user_id'];
      user_ids.add(lostData['user_id']);
      url = lostData['urlImage'] == null ? null : lostData['urlImage'][0];
      phoneNumber =
          lostData['phoneNumber'] == null ? null : lostData['phoneNumber'];
      urls = lostData['urlImage'] == null ? null : lostData['urlImage'];
    });
    print(urls);
    print('Dataaaaaaaaaa>>>>>>>>>>>>..' + color);
    print('Dataaaaaaaaaa>>>>>>>>>>>>..' + date);
    print('Dataaaaaaaaaa>>>>>>>>>>>>..' + description);
    print('Dataaaaaaaaaa>>>>>>>>>>>>..' + location);
    print('Dataaaaaaaaaa>>>>>>>>>>>>..' + Country);
    print('Dataaaaaaaaaa>>>>>>>>>>>>..' + user_id);
    if (lostData['urlImage'] != null) {
      setState(() {
        urls.removeLast();
      });
    }
    if (Usser == lostData['user_id']) {
      print('.............................??????????>>>>>>>.' + Usser);
      prodList.add(product(
          colore: lostData['color'],
          datee: lostData['data'],
          descriptione: lostData['description'],
          locatione: lostData['location'],
          Country: lostData['Country'],
          user_id: lostData['user_id'],
          urlIma: lostData['urlImage'] == null ? null : lostData['urlImage'][0],
          phoneNumber: lostData['phoneNumber'] == null ? null : lostData['phoneNumber'],
          urlss : lostData['urlImage']== null ? null : lostData['urlImage']
      ));

      print('Addedddd');
    }
  }

  // Fetch Find Date
  void fetchuserId() async {
    await FirebaseFirestore.instance
        .collection('products/ZcZ5UQqaDgnwU4hWE4He/Find')
        .get()
        .then((QuerySnapshot snapshot) =>
            snapshot.docs.forEach((DocumentSnapshot docuser) async {
              fetchFindData(docuser.id);
              print("User id  :   " + docuser.id);
            }));
  }

  Future<void> fetchFindData(String userId) async {
    final lostData = await FirebaseFirestore.instance
        .collection('products/ZcZ5UQqaDgnwU4hWE4He/Find')
        .doc(userId)
        .get();
    setState(() {
      color = lostData['color'];
      date = lostData['data'];
      location = lostData['location'];
      description = lostData['description'];
      Country = lostData['Country'];
      user_id = lostData['user_id'];
      user_ids.add(lostData['user_id']);
      url = lostData['urlImage'] == null ? null : lostData['urlImage'][0];
      phoneNumber =lostData['phoneNumber'] == null ? null : lostData['phoneNumber'];
      urls =  lostData['urlImage'] == null ? null : lostData['urlImage'];
    });
    print(urls);
    print('Dataaaaaaaaaa>>>>>>>>>>>>..' + color);
    print('Dataaaaaaaaaa>>>>>>>>>>>>..' + date);
    print('Dataaaaaaaaaa>>>>>>>>>>>>..' + description);
    print('Dataaaaaaaaaa>>>>>>>>>>>>..' + location);
    print('Dataaaaaaaaaa>>>>>>>>>>>>..' + Country);
    print('Dataaaaaaaaaa>>>>>>>>>>>>..' + user_id);
    if (lostData['urlImage'] != null) {
      setState(() {
        urls.removeLast();
      });
    }
    if (Usser == lostData['user_id']) {
      print('.............................??????????>>>>>>>.' + userId);
      prodList.add(product(
          colore: lostData['color'],
          datee: lostData['data'],
          descriptione: lostData['description'],
          locatione: lostData['location'],
          Country: lostData['Country'],
          user_id: lostData['user_id'],
          phoneNumber: lostData['phoneNumber'] == null ? null : lostData['phoneNumber'],
          urlIma: lostData['urlImage'] == null ? null : lostData['urlImage'][0],
          urlss :  lostData['urlImage'] == null ? null :lostData['urlImage']
      ));

      print('adddedd');
    }
    setState(() {
      isLoading = false;
    });
  }

  Widget detailCard(
      String description,
      String url,
      List urlss,
      String Country,
      String location,
      String color,
      String date,
      String phoneNum,
      String user_id,) {
    return FlatButton(
        onPressed: () {
          Navigator.pushReplacement(
              context,
              PageTransition(
                  child: Details(
                    desc: description,
                    location: location,
                    city: Country,
                    color: color,
                    date: date,
                    url: url,
                    urls: urlss,
                    phoneNumber: phoneNum,
                    UserId: user_id,
                    ides: user_ids,
                  ),
                  type: PageTransitionType.scale,
                  duration: Duration(milliseconds: 500),
                  alignment: Alignment.centerRight));
        },
        child: Column(
          children: [
            SizedBox(
              height: 175,
              width: 220,
              child: Card(
                elevation: 10,
                color: Colors.pinkAccent,
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                          child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            child: url == null
                                ? Image.asset('images/No-image.jpg')
                                : Image.network(url,
                                    width: 100, height: 100, fit: BoxFit.cover),
                          ),
                          Text(
                              description.length >= 16
                                  ? description.replaceRange(
                                      16, description.length, ".....")
                                  : description,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ],
                      )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  @override
  void initState() {
    // TODO: implement initState
    getuserID();
    fetchId();
    fetchuserId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () => Navigator.pushReplacement(
                    context,
                    PageTransition(
                        child: AddOrRwmovePage(),
                        type: PageTransitionType.topToBottom,
                        duration: Duration(milliseconds: 500))),
                icon: Icon(
                  Icons.home,
                  color: Colors.white,
                  size: 30,
                ))
          ],
          backgroundColor: Colors.pink,
          centerTitle: true,
          title: Text(
            'My Posts',
            style: TextStyle(fontStyle: FontStyle.italic,color: Colors.black, fontSize: 25),
          ),
        ),
        body: WillPopScope(
          onWillPop: onClicktoExit,
          child: Container(
              width: double.infinity,
              height: double.infinity,
              padding: EdgeInsets.only(top: 20),
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
              child: isLoading
                  ? Center(
                      child:
                          CircularProgressIndicator(color: Colors.pinkAccent))
                  : prodList.isEmpty
                      ? Padding(
                            padding: const EdgeInsets.only(left: 70 , top: 20),
                            child: Text('Nothing to Show ',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontStyle: FontStyle.italic)),
                          )
                      : Container(
                          child: GridView(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                            children: prodList
                                .map(
                                  (item) => Builder(
                                      builder: (ctx) => detailCard(
                                          item.descriptione,
                                          item.urlIma,
                                          item.urlss,
                                          item.Country,
                                          item.locatione,
                                          item.colore,
                                          item.datee,
                                          item.phoneNumber,
                                          item.user_id)),
                                )
                                .toList(),
                          ),
                        )),
        ),
      bottomNavigationBar: CurvedNavigationBar(
        index: 2,
        items: [
          Icon(Icons.home , size: 30, color: Colors.white),
          Icon(Icons.person , size: 30, color: Colors.white),
          Icon(Icons.person_search_rounded , size: 30, color: Colors.white),
        ],
        onTap: (index){
          if(index ==0 ){
            Navigator.pushReplacement(
                context,
                PageTransition(child: AddOrRwmovePage(),
                    type: PageTransitionType.scale , alignment: Alignment.bottomLeft, duration: Duration(milliseconds: 700)
                ));

          }
          if(index == 1){
            Navigator.pushReplacement(
                context, PageTransition(child:LoginPage (),
                type: PageTransitionType.scale ,alignment: Alignment.bottomCenter, duration: Duration(milliseconds: 500)
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
