
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'AddOrRwmovePage.dart';

class AuthScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return AuthSreenState();
  }
}

class AuthSreenState extends State<AuthScreen> with SingleTickerProviderStateMixin{
  final GlobalKey<FormState> _formKey = GlobalKey();
  String username ;
  String LastName ;
  String email ;
  String password ;
  File image ;
  bool isLogin = true;
  UserCredential userResult ;
  final _auth = FirebaseAuth.instance;
  // Text ErrorMassage = Text(massage , style: TextStyle(color: Colors.white));\

  AnimationController _controller ;
  Animation<Offset> _slideAnimation ;
  Animation<double> _opacityAnimation ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(vsync: this , duration: Duration(milliseconds: 300) );

    _slideAnimation = Tween<Offset>(begin: Offset(0,-15) , end: Offset(0,0))
        .animate(
     CurvedAnimation(
       parent: _controller ,
       curve:Curves.fastOutSlowIn,
     ),
    );

    _opacityAnimation = Tween<double>
      (
        begin: 0.0 ,
        end: 1.0
    ).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  void _submitAuth()async{
    if(!_formKey.currentState.validate()){
      return ;
    }
    else
    {
      _formKey.currentState.save();
      try{
        if(isLogin == false)
        {
          userResult = await _auth.createUserWithEmailAndPassword(
            email: email,
            password: password
        );
          // Add to FireStore
          AddUserToFireStore( userResult);
          Navigator.push(context, PageTransition(child: AddOrRwmovePage(),
              type: PageTransitionType.topToBottom , duration: Duration(milliseconds: 500)
          ));
          setState(() {
            isLogin = true ;
          });
        }
        else
        {
          userResult=await _auth.signInWithEmailAndPassword(
            email: email,
            password: password
        );
        Navigator.push(context, PageTransition(child: AddOrRwmovePage(),
            type: PageTransitionType.topToBottom , duration: Duration(milliseconds: 500)
        ));
        }
      }on FirebaseAuthException catch(e){
        if(e.code == 'weak-password'){
          _showErrorDialog('password provided is too weak');
          return;
        }else if(e.code == 'email-already-in-use'){
          _showErrorDialog('the account is already exists for this email');
          return;
        }
      }catch(e){
        print(e);
      }
    }
  }

  void AddUserToFireStore(UserCredential userResult)async{
    if(image != null ){
      try{
        final ref = FirebaseStorage.instance.ref().child('images').child('userImage').child(userResult.user.uid);
        await ref.putFile(image);
        final userImageUrl = await ref.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('products/ZcZ5UQqaDgnwU4hWE4He/user').doc(userResult.user.uid).set(
            {
              'email': email,
              'password': password,
              'Firstname':username,
              'lastname' : LastName,
              'phoneNumber' : null ,
              'address' : null ,
              'imageUrl' : userImageUrl
            });

      }catch(e){
        print(e.toString());
      }
    }else{
      try{
        await FirebaseFirestore.instance
            .collection('products/ZcZ5UQqaDgnwU4hWE4He/user').doc(userResult.user.uid).set(
            {
              'email': email,
              'password': password,
              'Firstname':username,
              'lastname' : LastName,
              'phoneNumber' : null ,
              'address' : null ,
              'imageUrl' : null
            });
      }catch(e){
        print(e.toString());
      }
    }
  }

  void _showErrorDialog(String message){
    showDialog(
        barrierColor: Colors.black.withOpacity(0.9),
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.pink,
          title: Text("OOPS", style: TextStyle(color: Colors.black)),
          content: Text(message , style: TextStyle(color: Colors.white)),
          actions: [
            SizedBox(
              width: double.infinity,
              height: 50,
              child: RaisedButton(
                color: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: Text('Okay', style: TextStyle(fontSize: 20 , color: Colors.white)),
                onPressed: () => Navigator.of(ctx).pop(),
              ),
            )

          ],
        )
    );
  }

  Builder _buildDialogItem (BuildContext context , String text , IconData icon , ImageSource src){
    return Builder(
      builder: (innerContext) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Colors.pink,
                Colors.pinkAccent,
              ]
          ),
          // color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          leading: Icon(icon , color: Colors.white),
          title: Text(text),
          onTap: (){
            // getImageM(src);
            checkpermission_opencamera(src);
            Navigator.of(innerContext).pop();
          },
        ),
      ),
    );
  }

  // Checkk Permission
  checkpermission_opencamera(ImageSource sourcee)async{
    var CameraStatue = await Permission.camera.status;
    if(!CameraStatue.isGranted){
      await Permission.camera.request();
    }
    if(await Permission.camera.isGranted){
      getImageM(sourcee);
    }
  }

  // get Image
  void getImageM(ImageSource src) async{
    final pickedFile  = await ImagePicker().getImage(source: src );
    if(pickedFile != null){
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  void _Check(){

    if(isLogin){
      if(email== null  || password== null){
        _showErrorDialog("Invalid Data !") ;
        return ;
      }
    }else{
      if(username == null  || LastName== null  || email== null  || password== null){
        _showErrorDialog("Invalid Data !") ;
        return ;
      }
    }



  }

  @override
  Widget build(BuildContext context) {
    final isKeyBaord = MediaQuery.of(context).viewInsets.bottom != 0;
     return Scaffold(
      backgroundColor: Colors.black45,
      body: Center(
        // color: Colors.black45,
        child: ListView(
          shrinkWrap: true,
                    reverse: true,
                    children: [
                      // SizedBox(height: 50),/
                    if(!isKeyBaord)Flexible(
                           child: Container(
                             padding: EdgeInsets.symmetric(horizontal: 40),
                             margin: EdgeInsets.symmetric(horizontal: 50),
                            transform: Matrix4.rotationZ(-8 * pi/180)..translate(-10.0),
                             child: Text("Find Me " ,
                               style: TextStyle(color: Colors.black , fontSize: 50 , fontWeight: FontWeight.w500
                                   , fontStyle: FontStyle.italic)),
                             decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(20),
                               color : Color.fromRGBO(255, 88, 144, 1)
                             ),
                           )
                       ),
                      Card(
                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                         margin: isLogin ?  EdgeInsets.symmetric(vertical: 50 , horizontal: 15)
                         : EdgeInsets.symmetric(vertical: 30 , horizontal: 15),
                         elevation: 15,
                         child: AnimatedContainer(
                           duration: Duration(milliseconds: 300),
                           curve: Curves.easeIn,
                           decoration: BoxDecoration(
                               borderRadius:BorderRadius.circular(10) ,
                               gradient: LinearGradient(
                                   colors: [
                                     Colors.pink,
                                     Colors.pinkAccent,
                                   ]
                               )
                           ),
                           margin: EdgeInsets.all(5),
                           padding: EdgeInsets.all(10),
                           // height:isLogin == true ? 240 : 430,
                           // width: 400,
                           child: Form(
                             key: _formKey,
                             child: SingleChildScrollView(
                               reverse: true,
                               child: Column(
                                 children: [
                                   SizedBox(height: 10),
                                   if(isLogin == false)
                                     InkWell(
                                         onTap: ()
                                         {
                                           var ad = AlertDialog(
                                             backgroundColor: Colors.black,
                                             title: Text('Select Image Form ? ',style: TextStyle(
                                                 color: Colors.white,fontStyle: FontStyle.italic,fontSize: 20)),
                                             content: Container(
                                               height:150 ,
                                               child: Column(
                                                 children: [
                                                   Divider(color: Colors.white),
                                                   _buildDialogItem(context, "Camera", Icons.add_a_photo_outlined, ImageSource.camera),
                                                   SizedBox(height: 10),
                                                   _buildDialogItem(context, "Gallery", Icons.add_outlined, ImageSource.gallery),
                                                 ],
                                               ),
                                             ),
                                           );
                                           showDialog(context: context,builder: (context) => ad );
                                         },
                                         child: image == null
                                             ? CircleAvatar(
                                           backgroundImage: AssetImage('images/person_1.png'),
                                           backgroundColor: Colors.blueGrey,
                                           maxRadius: 50,
                                         )
                                             :  Container(
                                             margin: EdgeInsets.all(10),
                                             decoration: BoxDecoration(
                                               color: Colors.blueGrey,
                                             ),
                                             child: CircleAvatar(
                                                 radius: 50,
                                                 child:Image.file(image)
                                             )
                                         )
                                     ),
                                   if(isLogin ==false)
                                     Container(
                                       padding: EdgeInsets.only(right: 100),
                                       child: TextFormField(
                                         decoration: InputDecoration(
                                             icon: Icon(Icons.person , color: Colors.black,),
                                             contentPadding: EdgeInsets.only(left: 10),
                                             labelText: 'First Name',labelStyle: TextStyle(color: Colors.white)),
                                         keyboardType: TextInputType.text,
                                         validator: (val){
                                           if(val.isEmpty){
                                             _showErrorDialog('Invalid First Name');
                                             return 'Invalid First Name';
                                             // return ;
                                           }
                                           return null;
                                         },
                                         onSaved: (value){
                                           username = value;
                                         },
                                       ),
                                     ),
                                   if(isLogin ==false)
                                     Container(
                                       padding: EdgeInsets.only(right: 100),
                                       child: TextFormField(
                                         decoration: InputDecoration(
                                             icon: Icon(Icons.person , color: Colors.black,),
                                             contentPadding: EdgeInsets.only(left: 10),
                                             labelText: 'Last Name',labelStyle: TextStyle(color: Colors.white)),
                                         keyboardType: TextInputType.text,
                                         validator: (val){
                                           if(val.isEmpty){
                                             _showErrorDialog('Invalid Last Name');
                                             return 'Invalid Last Name';
                                             // return ;
                                           }
                                           return null;
                                         },
                                         onSaved: (value){
                                           LastName = value;
                                         },
                                       ),
                                     ),
                                   if(isLogin == true ||isLogin == false )
                                     TextFormField(
                                       decoration: InputDecoration(
                                           icon: Icon(Icons.alternate_email, color: Colors.black ),
                                           contentPadding: EdgeInsets.only(left: 10),
                                           labelText: 'E-mail', labelStyle: TextStyle(color: Colors.white)),
                                       keyboardType: TextInputType.emailAddress,
                                       onSaved: (value){
                                         email = value;
                                       },
                                       validator: (val) {
                                         if(val.isEmpty || val.length <5){
                                           // _showErrorDialog('Password is too short!');
                                           return 'Invalid E-mail!';
                                           // return ;
                                         }
                                         return null;
                                       },
                                     ),
                                   if(isLogin == true ||isLogin == false )
                                     TextFormField(
                                       decoration: InputDecoration(
                                           icon: Icon(Icons.password_sharp , color: Colors.black),
                                           contentPadding: EdgeInsets.only(left: 10),
                                           labelText: 'Password' , labelStyle: TextStyle(color: Colors.white)),
                                       obscureText: true,
                                       onSaved: (value){
                                         password = value ;
                                       },
                                       validator: (val) {
                                         if(val.isEmpty || val.length <5){
                                           // _showErrorDialog('Password is too short!');
                                           return 'Password is too short!';
                                           // return ;
                                         }
                                         return null;
                                       },

                                     ),
                                   SizedBox(height: 20),
                                   Column(
                                     mainAxisAlignment: MainAxisAlignment.center,
                                     children: [
                                       RaisedButton(
                                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                         // child: Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SignUp'),
                                         child: Text(!isLogin ? 'Sign Up' : 'Login' ),
                                         onPressed: (){
                                           _Check();
                                           _submitAuth();
                                         },
                                         padding:  EdgeInsets.all(10),
                                         color: Colors.black,
                                         textColor: Theme.of(context).primaryTextTheme.button.color,
                                       ),
                                       FlatButton(
                                         onPressed: (){
                                           setState(() {
                                             isLogin = !isLogin ;
                                           });
                                         },
                                         child: Text(isLogin ?'Create new account':'Have an account already! ' , style: TextStyle(color: Colors.white)),
                                         padding:
                                         EdgeInsets.all(10),
                                         materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                         textColor: Theme.of(context).primaryColor,
                                       ),
                                     ],
                                   ),
                                 ],
                               ),
                             ),
                           ),
                         ),
                       ),
                     ].reversed.toList(),
                ),
        ),


      
    );
  }

}