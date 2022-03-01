import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lost/AddOrRwmovePage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:toast/toast.dart';

import 'chat-screen.dart';
import 'massage.dart';
import 'new-massage.dart';
class Details extends StatefulWidget{
  String desc ;
  String location ;
  String city ;
  String date ;
  String color;
  String url ;
  List urls = [];
  List<String> ides ;
  String phoneNumber;
  String UserId ;
  Details({
   this.desc,
   this.location,
   this.city,
   this.date,
   this.color,
   this.url,
   this.urls,
    this.phoneNumber,
   this.UserId,
    this.ides,
});
  @override
  State<StatefulWidget> createState() {
   return DetailsState(
       desc: desc, location: location, city: city,date: date,color: color,url: url, urls:urls,phoneNumber:phoneNumber ,
       UserId:UserId,
      ideees: ides
   );
  }
}
class DetailsState extends State<Details>{
  String desc ;
  String location ;
  String city ;
  String date ;
  String color;
  String url ;
  List urls = [];
  String UserId = '';
  List<String> ideees ;
  String phoneNumber ;
  DetailsState({
    this.desc,
    this.location,
    this.city,
    this.date,
    this.color,
    this.url,
    this.urls,
    this.phoneNumber,
    this.UserId,
    this.ideees,
  });
  // void fetchId() async {
  //    await FirebaseFirestore.instance.collection('products/ZcZ5UQqaDgnwU4hWE4He/Lost').get()
  //    .then((QuerySnapshot snapshot) {
  //      snapshot.docs.forEach((DocumentSnapshot docuser) async{
  //          // checkUserId(docuser.id);
  //        });
  //    });
  //
  // }
  // Future<void> checkUserId(String documentId) async{
  //   print('documentId  ' + documentId);
  //   final lostData = await FirebaseFirestore.instance
  //       .collection('products/ZcZ5UQqaDgnwU4hWE4He/Lost')
  //       .doc(documentId)
  //       .get();
  //   for(int x=0 ;x < ideees.length ; x++){
  //     print(x);
  //     if(desc == lostData['description'] && location == lostData['location'] && city == lostData['Country']
  //     ){
  //       setState(() {
  //         // UserId = ideees[x];
  //       });
  //       print('dataaa ' +lostData['description']  );
  //       print('dataaa ' +lostData['location']);
  //       print('dataaa ' +lostData['Country'] );
  //     }
  //   }
  //   print('dataaa ' +lostData['description']  );
  //   print('dataaa ' +lostData['location']);
  //   print('dataaa ' +lostData['Country'] );
  // }




  String doId ;

  final user = FirebaseAuth.instance.currentUser;

  void SendUserVerifecation () async{
    print('User Id in Details  :    '+UserId);
    MassagesState.onweruserId = UserId; //UserId = user id of owner
    await FirebaseFirestore.instance.collection('products/ZcZ5UQqaDgnwU4hWE4He/Find').get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot dsnap) {
        checkFindDocumetId(dsnap.id);

        // print('Document Idd :    '+dsnap.id);
      });
    });
    await FirebaseFirestore.instance.collection('products/ZcZ5UQqaDgnwU4hWE4He/Lost').get()
        .then((QuerySnapshot snapshot) {
          snapshot.docs.forEach((DocumentSnapshot dsnap) {
            checkLostDocumetId(dsnap.id);
            // print('Document Idd :    '+dsnap.id);
          });
        });

  }

  Future<void> checkFindDocumetId (String docId)async{
    final findData = await FirebaseFirestore.instance
        .collection('products/ZcZ5UQqaDgnwU4hWE4He/Find')
        .doc(docId)
        .get();
    if(findData['user_id'] == UserId){
      setState(() {
        doId = docId;
      });
      print('Document Idd :    '+ doId+' ' + UserId);
      NewMassageState.productId = doId;
      MassagesState.DocTest = docId;
    }



  }

  Future<void> checkLostDocumetId (String docId)async{
    final lostData = await FirebaseFirestore.instance
        .collection('products/ZcZ5UQqaDgnwU4hWE4He/Lost')
        .doc(docId)
        .get();
    if(lostData['user_id'] == UserId ){
      setState(() {
        doId = docId;
      });
      print('Document Idd :    '+ doId+' ' + UserId);
      NewMassageState.productId = doId;
       MassagesState.DocTest = docId;
    }
  }

  void printoo(){
    print('Dataaaaaaaaa>>>>>>>>>>>>.... '+ desc);
    print('Dataaaaaaaaa>>>>>>>>>>>>.... '+ location);
    print('Dataaaaaaaaa>>>>>>>>>>>>.... '+ city);
    print('Dataaaaaaaaa>>>>>>>>>>>>.... '+ date);
    print('Dataaaaaaaaa>>>>>>>>>>>>.... '+ color);
    print('Dataaaaaaaaa>>>>>>>>>>>>.... '+ UserId);
    print(ideees);
  }

  Container buildContainer(){
    return Container(
      // width: double.infinity,
      child:  url != null
            ? CarouselSlider.builder(
              options: CarouselOptions(
                  reverse: false,
                  pauseAutoPlayOnTouch: true,
                  enableInfiniteScroll: false,
                  // autoPlayInterval: Duration(seconds: 80),
                  enlargeCenterPage: true,
                  autoPlay: false,
                  initialPage: 0
        ),
              itemCount: urls.length,
              itemBuilder : (_ ,int index){
             return Container(
              child: urls == null
                  ? Image.asset('images/No-image.jpg')
                  : Image.network(urls[index],fit: BoxFit.contain),
                );
      }
      )
        : Image.asset('images/No-image.jpg', width:200 ,height: 200,),
    );
  }

  Card buildCard (){
    return Card(
      elevation: 10,
      color: Colors.pink,
      margin: EdgeInsets.all(5),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: SizedBox(
          height: 500,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('description : ',
                  style: TextStyle(fontSize: 16,color: Colors.white,fontStyle: FontStyle.italic)
              ),
              Text(desc,style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
              Divider(color: Colors.white),
              Text('City : ', style: TextStyle(fontSize: 16,color: Colors.white,fontStyle: FontStyle.italic)),
              Text(city, style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold), textAlign: TextAlign.justify),
              Divider(color: Colors.white),
              Text('specific location : ', style: TextStyle(fontSize: 16,color: Colors.white,fontStyle: FontStyle.italic)),
              Text(location, style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              Divider(color: Colors.white),
              Text('Date : ',style: TextStyle(fontSize: 16,color: Colors.white,fontStyle: FontStyle.italic)),
              Text(date.replaceRange(10, 23, ''), style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              Divider(color: Colors.white),
              Text('color : ',style: TextStyle(fontSize: 16,color: Colors.white,fontStyle: FontStyle.italic)),
              Text(color.toString(), style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
              Divider(color: Colors.white),
              Text('phone number : ',style: TextStyle(fontSize: 16,color: Colors.white,fontStyle: FontStyle.italic)),
              Text(phoneNumber==null? 'is not selected yet ': phoneNumber
                  , style: TextStyle(fontSize: 20)),
              Divider(color: Colors.white),
              Text('User Id : ',style: TextStyle(fontSize: 16,color: Colors.white,fontStyle: FontStyle.italic)),
              Text(UserId==null? 'User Id  ': UserId
                  , style: TextStyle(fontSize: 15)),

            ],
          ),
        ),
      ),
    );
  }

  // Double click To Exit
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


  void printee (){
    var dee = date.split(' ');
    String e ;
    int c ;
   e = date.replaceRange(10, 23, '');
    print (e);
    c = date.length;
    print (c);
   dee.forEach((element) {
     print(element +" " + '${element.length}');
   });
  }


  @override
  void initState() {
    // TODO: implement initState
    // fetchId();
    printee();
    printoo();

    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        actions: [
          IconButton(onPressed: ()=> Navigator.pushReplacement(context,
              PageTransition(child: AddOrRwmovePage(),
                  type: PageTransitionType.topToBottom , duration: Duration(milliseconds: 500)
              )),
              icon: Icon(Icons.home , size: 30, color: Colors.white,))
        ],
        backgroundColor: Colors.pink,
        centerTitle: true,
        title: Text('Details',style: TextStyle(fontStyle: FontStyle.italic , color: Colors.black,fontSize: 25)),
      ),
      body:WillPopScope(
        onWillPop: onClicktoExit,
        child:  Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.only(top: 10),
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
          child:  ListView(
            children: [
              SizedBox(height: 10),
              buildContainer(),
              SizedBox(height: 5),
              buildCard(),

            ],
          ),
        ),
      ),

        floatingActionButton : FloatingActionButton(
          backgroundColor: Colors.black,
          child: Icon(UserId == user.uid ? Icons.edit : Icons.chat , color: Colors.pinkAccent),
          onPressed: (){
            if(UserId == user.uid ){
              null ;
            }else{
              SendUserVerifecation();
              return Navigator.push(context, PageTransition(child: ChatScreen(),
                  type: PageTransitionType.scale, duration: Duration(milliseconds: 500) ,
                  alignment: Alignment.centerRight ));
            }
          },
        ),


    );
  }



}
