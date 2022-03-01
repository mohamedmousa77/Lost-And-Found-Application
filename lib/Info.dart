import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lost/AddOrRwmovePage.dart';
import 'package:toast/toast.dart';
class Information extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return InformationState();
  }
}
class InformationState extends State<Information>{
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
     appBar: AppBar(
       actions: [
         IconButton(onPressed: ()=>Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>AddOrRwmovePage())),
             icon: Icon(Icons.cancel , size: 30,))
       ],
       backgroundColor: Colors.black87,
       centerTitle: true,
       title: Text('Information',style: TextStyle(fontStyle: FontStyle.italic,fontSize: 25),),
     ),
     body: WillPopScope(
       onWillPop: onClicktoExit,
       child: Container(
         width: double.infinity,
         height: double.infinity,
         padding: EdgeInsets.only(top: 50),
         decoration: BoxDecoration(
           gradient: LinearGradient(
             colors: [
               Colors.black54,
               Colors.black,
             ],
             begin: Alignment.bottomCenter,
             end: Alignment.topCenter,
           ),
         ),
       ),
     )
   );
  }

}