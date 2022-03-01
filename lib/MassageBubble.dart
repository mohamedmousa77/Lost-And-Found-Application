import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MassageBubble extends StatelessWidget {
  MassageBubble(this.userName, this.massage, this.isMe);

  // final key ;
  final String massage;

  final String userName;

  final bool isMe;

// For User Image
  String UserImageUrl ;
  Future<String> fatchData(String userId) async {
    final userData = await FirebaseFirestore.instance
        .collection('products/ZcZ5UQqaDgnwU4hWE4He/user')
        .doc(userId)
        .get();
    UserImageUrl = userData['imageUrl']==null ? null :userData['imageUrl'] ;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            isMe == true
                ? Container(
                    decoration: BoxDecoration(
                        color:
                            isMe ? Colors.white : Theme.of(context).accentColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(14),
                          topRight: Radius.circular(14),
                          bottomLeft:
                              !isMe ? Radius.circular(0) : Radius.circular(14),
                          bottomRight:
                              isMe ? Radius.circular(0) : Radius.circular(14),
                        )),
                    width: 140,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    margin: EdgeInsets.symmetric(vertical: 16, horizontal: 45),
                    child: Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isMe
                                  ? Colors.black
                                  : Theme.of(context)
                                      .accentTextTheme
                                      .headline6
                                      .color),
                          textAlign: isMe ? TextAlign.end : TextAlign.start,
                        ),
                        Text(
                          massage,
                          style: TextStyle(
                              color: isMe
                                  ? Colors.black
                                  : Theme.of(context)
                                      .accentTextTheme
                                      .headline6
                                      .color),
                          textAlign: isMe ? TextAlign.end : TextAlign.start,
                        ),
                      ],
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                        color: isMe ? Colors.deepPurple : Colors.grey[300],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(14),
                          topRight: Radius.circular(14),
                          bottomLeft:
                              !isMe ? Radius.circular(0) : Radius.circular(14),
                          bottomRight:
                              isMe ? Radius.circular(0) : Radius.circular(14),
                        )),
                    width: 140,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    margin: EdgeInsets.symmetric(vertical: 16, horizontal: 45),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isMe
                                  ? Theme.of(context)
                                      .accentTextTheme
                                      .headline6
                                      .color
                                  : Colors.black),
                          textAlign: isMe ? TextAlign.start : TextAlign.end,
                        ),
                        Text(
                          massage,
                          style: TextStyle(
                              color: isMe
                                  ? Theme.of(context)
                                      .accentTextTheme
                                      .headline6
                                      .color
                                  : Colors.black),
                          textAlign: isMe ? TextAlign.start : TextAlign.end,
                        ),
                      ],
                    ),
                  )
          ],
        ),
        Positioned(
          top: isMe ? 20 : 20,
          left: isMe ? 320 : 0,
          child: CircleAvatar(
            backgroundImage:  UserImageUrl== null
                ? AssetImage('images/person_1.png')
                : NetworkImage(UserImageUrl),
            backgroundColor: Colors.pink,
          ),
        ),
      ],
      overflow: Overflow.visible,
    );
  }
/*Container(
              decoration: BoxDecoration(
              color:
              isMe ? Colors.white : Theme.of(context).accentColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
                bottomLeft:
                !isMe ? Radius.circular(0) : Radius.circular(14),
                bottomRight:
                isMe ? Radius.circular(0) : Radius.circular(14),
              )),
          width: 140,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          margin: EdgeInsets.symmetric(vertical: 16, horizontal: 45),
          child: Column(
            crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isMe
                        ? Colors.black
                        : Theme.of(context).accentTextTheme.headline6.color),
                textAlign: isMe ? TextAlign.end : TextAlign.start,
              ),
              Text(
                massage,
                style: TextStyle(
                    color: isMe
                        ? Colors.black
                        : Theme.of(context).accentTextTheme.headline6.color

                ),
                textAlign: isMe ? TextAlign.end : TextAlign.start,
              ),
            ],
          ),
        )
            : Container(
          decoration: BoxDecoration(
              color:isMe ?   Colors.deepPurple : Colors.grey[300],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
                bottomLeft:
                !isMe ?  Radius.circular(0):Radius.circular(14) ,
                bottomRight:
                isMe ?  Radius.circular(0) : Radius.circular(14) ,
              )),
          width: 140,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          margin: EdgeInsets.symmetric(vertical: 16, horizontal: 45),
          child: Column(
            crossAxisAlignment:
              CrossAxisAlignment.start ,
            children: [
              Text(
                userName,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isMe
                        ?  Theme.of(context).accentTextTheme.headline6.color  : Colors.black),
                textAlign: isMe ? TextAlign.start : TextAlign.end ,
              ),
              Text(
                massage,
                style: TextStyle(
                    color: isMe ?  Theme.of(context).accentTextTheme.headline6.color : Colors.black

                ),
                textAlign: isMe ?  TextAlign.start : TextAlign.end ,
              ),
            ],
          ),
        ),*/
}
// Container(
// decoration: BoxDecoration(
// color:  isMe ? Colors.grey[300] : Theme.of(context).accentColor,
// borderRadius: BorderRadius.only(
// topLeft:Radius.circular(14),
// topRight:Radius.circular(14),
// bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(14),
// bottomRight: isMe ? Radius.circular(0) : Radius.circular(14),
// )
// ),
// width: 140,
// padding: EdgeInsets.symmetric(vertical: 10 , horizontal: 16),
// margin: EdgeInsets.symmetric(vertical:4 , horizontal: 8 ),
// child:  Column(
// crossAxisAlignment: isMe ? CrossAxisAlignment.end  : CrossAxisAlignment.start,
// children: [
// Text(
// userName ,
// style: TextStyle(
// fontWeight: FontWeight.bold,
// color: isMe ? Colors.black : Theme.of(context).accentTextTheme.headline6.color
// ),
// textAlign: isMe ? TextAlign.end : TextAlign.start,
// ),
// Text(
// massage ,
// style: TextStyle(
// color: isMe ? Colors.black : Theme.of(context).accentTextTheme.headline6.color
// ),
// textAlign: isMe ? TextAlign.end : TextAlign.start,
// ),
// ],
// ),
// ),
