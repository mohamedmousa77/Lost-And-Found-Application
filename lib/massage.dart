import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lost/MassageBubble.dart';

class Massages extends StatefulWidget {
  @override
  MassagesState createState() => MassagesState();
}

class MassagesState extends State<Massages> {
  static String onweruserId ;
   static String DocmtId ;
  static String DocTest;

final user = FirebaseAuth.instance.currentUser ;
  String onwerId ;
  bool isHe = false ;

  void FetchDId () async {
    print('In  FetchDId Function ');
    await FirebaseFirestore.instance.collection('products/ZcZ5UQqaDgnwU4hWE4He/Lost').get()
    .then((QuerySnapshot snapshot) {
    snapshot.docs.forEach((DocumentSnapshot dId) {
    print('Lost Doc ' + dId.id);
    if(dId.id == DocTest){
      checkLostDocumetId();
    }

    });
    });
    await FirebaseFirestore.instance.collection('products/ZcZ5UQqaDgnwU4hWE4He/Find').get()
       .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot dId) {
        print('Find Doc ' + dId.id);
        if(dId.id == DocTest){
          checkFindDocumetId();
        }
      });
    });
  }

  Future<void> checkFindDocumetId ()async{
    print('In checkFindDocumetId ');
    final findData = await FirebaseFirestore.instance
        .collection('products/ZcZ5UQqaDgnwU4hWE4He/Find')
        .doc(DocTest)
        .get();
    setState(() {
      onwerId = findData['user_id'];
      print('Yeesss');
    });
  }

  Future<void> checkLostDocumetId ()async{
    print('In checkFindDocumetId ');
    final lostData = await FirebaseFirestore.instance
        .collection('products/ZcZ5UQqaDgnwU4hWE4He/Lost')
        .doc(DocTest)
        .get();

    setState(() {
      onwerId = lostData['user_id'];
      print('Yeesss');
    });
  }

  // void isExists ()async{
  //   await FirebaseFirestore.instance.collection('Chat/$DocTest/massages').get().then((QuerySnapshot snapshot)
  //   {
  //     snapshot.docs.forEach((DocumentSnapshot documentSnapshot) async
  //     {
  //       final chat = await FirebaseFirestore.instance.collection('Chat/$DocTest/massages').doc(documentSnapshot.id).get();
  //       print('  ' + DocTest +'   Document Id From Chat '+  documentSnapshot.id + '   Massage Onwer Id From Chat  '+ chat['UserId']);
  //       if(chat['UserId'] == onwerId ){
  //         print('onwer id ' + onwerId );
  //         print(' YESSS YESSS YESSS ');
  //         setState(() {
  //          isHe = true ;
  //
  //         });
  //       }
  //     });
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    FetchDId();
    super.initState();
  }



  final getMassages =  FirebaseFirestore.instance.collection('Chat/$DocTest/massages')
      .orderBy('MassageData', descending: true)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: getMassages,
        builder: (ctx, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator( color: Colors.pink,);
          }
          final docs = snapShot.data.docs;
          final user = FirebaseAuth.instance.currentUser;
          // print('user ID In Massage Class   :   '+onweruserId);
          print('Document ID In Massage Class   :   '+DocTest);
          return ListView.builder(
              reverse: true,
              itemCount: docs.length,
              itemBuilder: (ctx, index) {
                print(docs[index]['UserId']);
                if(docs[index]['UserId']==user.uid ){
                  print('Is HE : ');
                  print (isHe);
                  print(docs[index]['UserId']==user.uid);
                  return MassageBubble(
                    docs[index]['UserName'],
                    docs[index]['text'],
                    docs[index]['UserId']==user.uid? true : false,

                  );
                }else if(docs[index]['UserId'] == onwerId ){
                  return MassageBubble(
                    docs[index]['UserName'],
                    docs[index]['text'],
                    docs[index]['UserId']==user.uid? true : false,
                  );
                }
                return null ;

              });
        });
  }
}

// StreamBuilder biuldStt() {
//   return StreamBuilder(
//       stream: FirebaseFirestore.instance
//           .collection('chat')
//           .orderBy('MassageData', descending: true)
//           .snapshots(),
//       builder: (ctx, snapShot) {
//         if (snapShot.connectionState == ConnectionState.waiting) {
//           return CircularProgressIndicator();
//         }
//         final docs = snapShot.data.docs;
//         final user = FirebaseAuth.instance.currentUser;
//         print(UserIdII);
//         return ListView.builder(
//             reverse: true,
//             itemCount: docs.length,
//             itemBuilder: (ctx, index) {
//               print(docs[index]['UserId']);
//               return MassageBubble(
//                   docs[index]['UserName'],docs[index]['text'],
//                   docs[index]['UserId']==user.uid ? true : false,
//                   // docs[index]['UserId']==userId ? true : false ,
//                   true
//               );
//
//             });
//       });
// }

// class _MassagesState extends State<Massages> {
//
//   String userName ;
//   String text ;
//   // bool isHe ;
//   // String userId ;
//   // _MassagesState(this.userId);
//   // List<String> userIdess = [];
//
//   final user = FirebaseAuth.instance.currentUser;
//
//   void fetchId() async {
//     print('in Fetch Data function !   ');
//     await FirebaseFirestore.instance
//         .collection('chat')
//         .get()
//         .then((QuerySnapshot snapshot) {
//       snapshot.docs.forEach((DocumentSnapshot docuser) async {
//         print(docuser.id);
//         checkUserId(docuser.id);
//       });
//     });
//   }
//
//   Future<void> checkUserId(String documentId) async {
//     print('documentId  ' + documentId);
//     final lostData = await FirebaseFirestore.instance
//         .collection('chat')
//         .doc(documentId)
//         .get();
//     if (lostData['UserId'] == user.uid) {
//       print(lostData['UserName']);
//       print(lostData['text']);
//       print(lostData['UserId']);
//       // setState(() {
//       //   userName = lostData['UserName'];
//       //   text = lostData['text'];
//       //   userId = lostData['UserId'];
//       // });
//
//     }else{
//       print('There is an Error!  ');
//     }
//
//   }
//   @override
//   void initState() {
//     // TODO: implement initState
//     printee();
//     super.initState();
//   }
//   void printee(){
//   //   print ('User Id   :  '+userId);
//   // setState(() {
//   //   userIdess.add(userId);
//   // });
//   //   print(userIdess);
//   }
//
//
//   StreamBuilder biuldStt() {
//     return StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('chat')
//             .orderBy('MassageData', descending: true)
//             .snapshots(),
//         builder: (ctx, snapShot) {
//           if (snapShot.connectionState == ConnectionState.waiting) {
//             return CircularProgressIndicator();
//           }
//           final docs = snapShot.data.docs;
//           final user = FirebaseAuth.instance.currentUser;
//
//           return ListView.builder(
//               reverse: true,
//               itemCount: docs.length,
//               itemBuilder: (ctx, index) {
//                 print(docs[index]['UserId']);
//                   return MassageBubble(
//                     docs[index]['UserName'],docs[index]['text'],
//                     docs[index]['UserId']==user.uid ? true : false,
//                     // docs[index]['UserId']==userId ? true : false ,
//                   true
//                   );
//
//               });
//        });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return biuldStt() ;
//   }
//   }



  // class Recivedata {
  // bool isHe ;
  // Recivedata(this.isHe);
  // }






