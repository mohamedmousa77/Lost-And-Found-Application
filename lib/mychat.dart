import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:toast/toast.dart';

import 'MassageBubble.dart';
import 'ProductDetails.dart';
import 'chat-screen.dart';
import 'massage.dart';
import 'new-massage.dart';

class MyChat extends StatefulWidget {
  const MyChat({Key key}) : super(key: key);

  @override
  _MyChatState createState() => _MyChatState();
}

class _MyChatState extends State<MyChat> {
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

  // For User Image
  String UserImageUrl;
  Future<String> fatchData(String userId) async {
    final userData = await FirebaseFirestore.instance
        .collection('products/ZcZ5UQqaDgnwU4hWE4He/user')
        .doc(userId)
        .get();
    UserImageUrl = userData['imageUrl'] == null ? null : userData['imageUrl'];
  }

  Widget detailCard(String id) {
    return FlatButton(
      onPressed: () {
        SendChatDataToMassage(id);
        Navigator.push(
            context,
            PageTransition(
                child: ChatScreen(),
                type: PageTransitionType.scale,
                duration: Duration(milliseconds: 500),
                alignment: Alignment.centerRight));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white10,
        ),
        margin: EdgeInsets.all(5),
        child: SizedBox(
          height: 70,
          width: double.infinity,
          child: Row(
            children: [
              Container(
                  padding: EdgeInsets.all(5),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 25,
                    backgroundImage: UserImageUrl == null
                        ? AssetImage('images/person_1.png')
                        : NetworkImage(UserImageUrl),
                  )),
              Card(
                elevation: 10,
                color: Colors.white12,
                child: Text(id,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    )),
                // Column(
                //   children: [
                //     Row(
                //       children: [
                //
                //         // Expanded(
                //         //   flex: 3,
                //         //   child: Container(
                //         //       child: Column(
                //         //         children: [
                //         //           Container(
                //         //               padding: EdgeInsets.all(5),
                //         //               child:
                //         //                    Image.asset('images/No-image.jpg', width: 150, height: 100, fit: BoxFit.cover)
                //         //           ),
                //         //           Text('Mohammed',
                //         //               style: TextStyle(
                //         //                 fontSize: 14,
                //         //                 color: Colors.white,
                //         //               )
                //         //           ),
                //         //
                //         //         ],
                //         //       )
                //         //   ),
                //         // ),
                //       ],
                //     ),
                //   ],
                // ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final user = FirebaseAuth.instance.currentUser;
  String dTest;
  List<String> onwerdocument = [];
  bool isLoading = true;
  String OnwerDocumnetId;
  List<String> onwerdocnoDuplicate = [];

  void SendUserVerifecation() async {
    await FirebaseFirestore.instance
        .collection('products/ZcZ5UQqaDgnwU4hWE4He/Find')
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot dsnap) {
        checkFindDocumetId(dsnap.id);
        isExists(dsnap.id);
        setState(() {
          OnwerDocumnetId = dsnap.id;
        });
      });
    });
    await FirebaseFirestore.instance
        .collection('products/ZcZ5UQqaDgnwU4hWE4He/Lost')
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot dsnap) {
        checkLostDocumetId(dsnap.id);
        isExists(dsnap.id);
        setState(() {
          OnwerDocumnetId = dsnap.id;
        });
      });
    });
  }

  Future<void> checkFindDocumetId(String docId) async {
    final findData = await FirebaseFirestore.instance
        .collection('products/ZcZ5UQqaDgnwU4hWE4He/Find')
        .doc(docId)
        .get();
    if (findData['user_id'] == user.uid) {
      setState(() {
        dTest = docId;
      });
    }
  }

  Future<void> checkLostDocumetId(String docId) async {
    final lostData = await FirebaseFirestore.instance
        .collection('products/ZcZ5UQqaDgnwU4hWE4He/Lost')
        .doc(docId)
        .get();
    if (lostData['user_id'] == user.uid) {
      setState(() {
        dTest = docId;
      });
    }
  }

  void SendChatDataToMassage(String onwerdocc) {
    MassagesState.DocTest = onwerdocc;
    NewMassageState.productId = onwerdocc;
  }

  void isExists(String doc) async {
    await FirebaseFirestore.instance
        .collection('Chat/$doc/massages')
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot documentSnapshot) async {
        final chat = await FirebaseFirestore.instance
            .collection('Chat/$doc/massages')
            .doc(documentSnapshot.id)
            .get();
        print('  ' +
            doc +
            '   Document Id From Chat ' +
            documentSnapshot.id +
            '   Massage Onwer Id From Chat  ' +
            chat['UserId']);
        if (chat['UserId'] == user.uid) {
          print(' YESSS YESSS YESSS ');
          setState(() {
            onwerdocument.add(doc);

            print('Adddadddd! ');
            if (!onwerdocnoDuplicate.contains(doc)) {
              onwerdocnoDuplicate.add(doc);
              print('Addedddddeddd ! ');
            }
          });
        }
      });
    });
  }

  //
  // void checkInList (){
  //   print('In Check Function ');
  // for(final i in onwerdocument){
  //   if(!onwerdocnoDuplicate.contains(i)){
  //      onwerdocnoDuplicate.add(i);
  //      print('Addedddddeddd ! ');
  //   }
  // }
  //
  //
  // }

  // void fetchdocumentIdfromFind() async {
  //   print('In fetchdocumentIdfromFind  Function >>>>>....');
  //   await FirebaseFirestore.instance
  //       .collection('products/ZcZ5UQqaDgnwU4hWE4He/Find')
  //       .get()
  //       .then((QuerySnapshot snapshot) =>
  //       snapshot.docs.forEach((DocumentSnapshot docUser) async {
  //         fetchuserDatafinded(docUser.id);
  //       }));
  // }
  //
  // void fetchuserDatafinded(String dId) async{
  //   final user = FirebaseAuth.instance.currentUser;
  //   final findData = await FirebaseFirestore.instance
  //       .collection('products/ZcZ5UQqaDgnwU4hWE4He/Find')
  //       .doc(dId)
  //       .get();
  //
  //   if(user.uid == findData['user_id'] ){
  //     print(dId + '  ' + user.uid + '   '+ findData['user_id']);
  //   }
  //
  //   print(findData['user_id']+'  From fetchuserDatafinded ');
  // }
  //
  // void fetchdocumentIdfromLost() async {
  //   await FirebaseFirestore.instance
  //       .collection('products/ZcZ5UQqaDgnwU4hWE4He/Lost')
  //       .get()
  //       .then((QuerySnapshot snapshot) =>
  //       snapshot.docs.forEach((DocumentSnapshot docUser) async {
  //         fetchuserDatalosted(docUser.id);
  //       }));
  // }
  //
  // void fetchuserDatalosted(String dId) async{
  //   final user = FirebaseAuth.instance.currentUser;
  //   final lostData = await FirebaseFirestore.instance
  //       .collection('products/ZcZ5UQqaDgnwU4hWE4He/Lost')
  //       .doc(dId)
  //       .get();
  //
  //   if(user.uid == lostData['user_id'] ){
  //     print(dId + '  ' + user.uid + '   '+ lostData['user_id']);
  //   }
  //
  //   print(lostData['user_id'] + ' From fetchuserDatalosted ');
  // }

  // StreamBuilder buildStream() {
  //   return StreamBuilder(
  //       stream: getMassages,
  //       builder: (ctx, snapShot) {
  //         if (snapShot.connectionState == ConnectionState.waiting) {
  //           return CircularProgressIndicator( color: Colors.pink,);
  //         }
  //         final docs = snapShot.data.docs;
  //         final user = FirebaseAuth.instance.currentUser;
  //         // print('user ID In Massage Class   :   '+UserIdII);
  //         // print('Document ID In Massage Class   :   '+DocmtId);
  //
  //         return ListView.builder(
  //             reverse: true,
  //             itemCount: docs.length,
  //             itemBuilder: (ctx, index) {
  //               print('User Id Fetched From Stream Builder' + docs[index]['UserId']);
  //               print('Text Fetched From Stream Builder' + docs[index]['text']);
  //               print('Document Id Fetched From Stream Builder' + docs[index]['DocumentId']);
  //               return null ;
  //               // return MassageBubble(
  //               //   docs[index]['UserName'],
  //               //   docs[index]['text'],
  //               //   docs[index]['UserId']==user.uid ? true : false,
  //               //   docs[index]['UserId']==UserIdII ? true : false ,
  //               //
  //               // );
  //             });
  //       });
  // }

  // void prtintee (){
  //   print('User Id Fetched From Stream Builder' + USERID);
  //   print('text Fetched From Stream Builder' + TEXT);
  //   print('document ID  Fetched From Stream Builder' + DOCID);
  // }

  @override
  void initState() {
    // TODO: implement initState
    SendUserVerifecation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Chat', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.pink,
      ),
      body: WillPopScope(
        // onWillPop: onClicktoExit,
        onWillPop: null,
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
          child: ListView(
            children: onwerdocnoDuplicate.map(
              (item) {
                return Builder(builder: (ctx) => detailCard(item));
              },
            ).toList(),
          ),
        ),
      ),
    );
  }
}
