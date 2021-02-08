import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class utility{

   showUpdateAlertAndroid(context){
    return showDialog(
      //barrierDismissible for cannot close on outside touch
        barrierDismissible: false,
        context: context,
    builder: (BuildContext context){
      //willPopScope is use for not allowing close on back button
      return WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Text("HeyCloudy Update Available!"),
          content: Text("There is newer version of this app available"),
          actions: [
            FlatButton(onPressed: () async{
              exit(0);
            }, child: Text("Exit")),
            FlatButton(onPressed: () async{
              String url = "https://apps.apple.com/is/app/heycloudy-story-learning-app/id1536910417";
              String url1 = "https://play.google.com/store/apps/details?id=listen.to.heycloudy&hl=en_IN&gl=US";
            if(await canLaunch(url)){
              await launch(url);
            }
            else{
              print("cannot launch");
            }
            }, child: Text("Update"))
          ],


        ),
      );
    }
    );
  }

}
