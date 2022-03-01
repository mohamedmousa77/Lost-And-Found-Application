import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMassage extends StatefulWidget {
  const NewMassage({Key key}) : super(key: key);

  @override
  NewMassageState createState() => NewMassageState();
}

class NewMassageState extends State<NewMassage> {
  final _controller = TextEditingController();
  String _enterMassage = "";
  static String productId;

  _sendMassage() async {
    FocusScope.of(context).unfocus();

    final user = await FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('products/ZcZ5UQqaDgnwU4hWE4He/user')
        .doc(user.uid)
        .get();

    final refMassage =
        FirebaseFirestore.instance.collection('Chat/$productId/massages');
    await refMassage.add({
      'text': _enterMassage,
      'MassageData': Timestamp.now(),
      'UserId': user.uid,
      'UserName': userData['Firstname'],
      'DocumentId': productId
    });
    _controller.clear();
    setState(() {
      _enterMassage = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      color: Colors.black,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: TextStyle(color: Colors.white),
              textCapitalization: TextCapitalization.sentences,
              controller: _controller,
              decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.pink)),
                  hintText: "Send a massage...",
                  hintStyle: TextStyle(color: Colors.pink)),
              onChanged: (val) {
                setState(() {
                  _enterMassage = val;
                });
              },
            ),
          ),
          IconButton(
              color: Colors.pink,
              disabledColor: Colors.white,
              onPressed: _enterMassage.trim().isEmpty ? null : _sendMassage,
              icon: Icon(Icons.send))
        ],
      ),
    );
  }
}
