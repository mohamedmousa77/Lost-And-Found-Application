import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'AddOrRwmovePage.dart';
import 'package:toast/toast.dart';
class Help extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return HelpState();
  }
}
class HelpState extends State<Help>{
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
          IconButton(onPressed: ()=>Navigator.pushReplacement(context,
              PageTransition(child: AddOrRwmovePage(), type: PageTransitionType.topToBottom , duration: Duration(milliseconds: 500))
          ),
              icon: Icon(Icons.cancel , size: 30,))
        ],
        backgroundColor: Colors.pink,
        centerTitle: true,
        title: Text('Help!',style: TextStyle(color : Colors.black,fontStyle: FontStyle.italic,fontSize: 30),),
      ),
      body:WillPopScope(
        onWillPop: onClicktoExit,
        child:  Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.only(top: 50),
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
        child:  Padding(
          padding: const EdgeInsets.only(left: 70),
          child:  Text('This page is not implemented yet ' , style: TextStyle(color: Colors.white),)

        )
        ),
      )
    );
  }

}