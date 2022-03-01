import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:toast/toast.dart';
import 'AddOrRwmovePage.dart';
import 'ProductDetails.dart';

class findedScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return findedScreenState();
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
  final List urlss;
  final String phoneNumber;
  product({
    @override this.colore,
    @override this.datee,
    @override this.locatione,
    @override this.descriptione,
    @override this.Country,
    @override this.user_id,
    @override this.urlIma,
    @override this.urlss,
    @override this.phoneNumber,
  });

}

class findedScreenState extends State<findedScreen> {
// Get User Id
  final FirebaseAuth auth = FirebaseAuth.instance;
  void fetchId() async {
    print('In fetch Id Function >>>>>....');
    await FirebaseFirestore.instance
        .collection('products/ZcZ5UQqaDgnwU4hWE4He/Find')
        .get()
        .then((QuerySnapshot snapshot) =>
        snapshot.docs.forEach((DocumentSnapshot docUser) async {
          fatchData(docUser.id);
        }));
  }
// Get data
  String color;
  String date;
  String location;
  String description;
  String country;
  String user_Id;
  String phoneNumber;
  List<product> prodList = [];
  List<dynamic> urls =[];
  String url ;
  List<String> user_ids=[] ;

  Future<void> fatchData(String userId) async {
    print('In fetch Data Function >>>>>....');
    final lostData = await FirebaseFirestore.instance
        .collection('products/ZcZ5UQqaDgnwU4hWE4He/Find')
        .doc(userId)
        .get();
    print('Geted ..........>>>>>....');
    setState(() {
      color = lostData['color'];
      date = lostData['data'];
      location = lostData['location'];
      description = lostData['description'];
      country = lostData['Country'];
      user_ids.add(lostData['user_id']);
      user_Id = lostData['user_id'];
      phoneNumber=lostData['phoneNumber'] == null ? null : lostData['phoneNumber'];
      url = lostData['urlImage'] == null ? null : lostData['urlImage'][0];
      lostData['urlImage']== null ? null : urls.add(lostData['urlImage']);
    });
    print(urls);
    print('Dataaaaaaaaaa>>>>>>>>>>>>..' + color);
    print('Dataaaaaaaaaa>>>>>>>>>>>>..' + date);
    print('Dataaaaaaaaaa>>>>>>>>>>>>..' + description);
    print('Dataaaaaaaaaa>>>>>>>>>>>>..' + location);
    print('Dataaaaaaaaaa>>>>>>>>>>>>..' + country);
    print('Dataaaaaaaaaa>>>>>>>>>>>>..' + user_Id);
    if(lostData['urlImage']!=null){
      setState(() {
        urls.removeLast();
      });
    }

    prodList.add(product(
        colore: lostData['color'],
        datee: lostData['data'],
        descriptione: lostData['description'],
        locatione: lostData['location'],
        Country: lostData['Country'],
        urlIma: lostData['urlImage'] == null ? null : lostData['urlImage'][0] ,
        phoneNumber:lostData['phoneNumber'] == null ? null : lostData['phoneNumber'],
        user_id: lostData['user_id']));
    setState(() {
      isLoading = false;
    });
  }

// Show the data
  bool isLoading = true;

  Widget detailCard(String description , String url , List urlss, String Country  , String location , String color ,
      String date , String phoneNum , String user_id) {
    return FlatButton(
        onPressed: () {
          Navigator.pushReplacement(
            context , PageTransition(
                  child: Details(
                    desc: description,
                    location: location,
                    city: Country,
                    color: color,
                    date: date,
                    url: url,
                    urls: urlss,
                    phoneNumber: phoneNum,
                    UserId : user_id,
                    ides: user_ids,
                  ),
                  type: PageTransitionType.scale, duration: Duration(milliseconds: 500) , alignment: Alignment.centerRight
              )
          );
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
                            child:url==null
                                ?Image.asset('images/No-image.jpg')
                                : Image.network(url, width: 100, height: 100, fit: BoxFit.cover)),
                          Text(description,
                              style: TextStyle(
                                  fontSize: 10,
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
        )
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchId();
    super.initState();
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        actions: [
          IconButton(onPressed: ()=>Navigator.pushReplacement(context, PageTransition(child: AddOrRwmovePage(),
              type: PageTransitionType.topToBottom , duration: Duration(milliseconds: 500)
          )),
              icon: Icon(Icons.home ,color: Colors.white, size: 30,))
        ],
        centerTitle: true,
        backgroundColor: Colors.pink,
        title: Text('Find Items',style: TextStyle(fontSize: 30,fontStyle: FontStyle.italic,color: Colors.black),),
      ),
        body:WillPopScope(
          onWillPop: onClicktoExit,
          child:  Container(
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
                  ? Center(child: CircularProgressIndicator(color:Colors.pinkAccent))
                  : prodList.isEmpty
                  ? Center(child: Text('Nothing to show'))
                  : RefreshIndicator(
                    child:GridView(
                   gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                    children: prodList.map((item) => Builder(builder: (ctx) =>
                            detailCard(item.descriptione,item.urlIma , item.urlss , item.Country
                                , item.locatione, item.colore , item.datee , item.phoneNumber,  item.user_id)),
                  )
                      .toList(),

                ),

                onRefresh: () async {
                  await fetchId();
                },
              )),
        )
    );
  }
}
