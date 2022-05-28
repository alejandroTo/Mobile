import 'dart:convert';

import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}



_uploadNew (BuildContext context,String _numberUser) async {

  FilePickerResult? result;

  try{
    result = await FilePicker.platform.pickFiles(type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
  } catch(e)
  {
    print(e);
  }
  if(result != null) {
    try {
      Uint8List ?fileBytes = result.files.first.bytes;
      var fileName = result.files.first.name;
      var path = result.files.single.bytes;
      List<int> iterable = fileBytes ?? [];
      //print(iterable.length);
      var headers = {
        'Authorization': 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6ImpTMVhvMU9XRGpfNTJ2YndHTmd2UU8yVnpNYyIsImtpZCI6ImpTMVhvMU9XRGpfNTJ2YndHTmd2UU8yVnpNYyJ9.eyJhdWQiOiIwMDAwMDAwMy0wMDAwLTBmZjEtY2UwMC0wMDAwMDAwMDAwMDAvdGVjbm1zYWx0aWxsby5zaGFyZXBvaW50LmNvbUAxZTcxY2M3NC1jODJmLTRmMTItYTEyMy1kM2UzN2YzOGY5NmIiLCJpc3MiOiIwMDAwMDAwMS0wMDAwLTAwMDAtYzAwMC0wMDAwMDAwMDAwMDBAMWU3MWNjNzQtYzgyZi00ZjEyLWExMjMtZDNlMzdmMzhmOTZiIiwiaWF0IjoxNjUzNzQ0MDYzLCJuYmYiOjE2NTM3NDQwNjMsImV4cCI6MTY1MzgzMDc2MywiaWRlbnRpdHlwcm92aWRlciI6IjAwMDAwMDAxLTAwMDAtMDAwMC1jMDAwLTAwMDAwMDAwMDAwMEAxZTcxY2M3NC1jODJmLTRmMTItYTEyMy1kM2UzN2YzOGY5NmIiLCJuYW1laWQiOiIyZmNiZTU5NC1iM2RkLTQ1ZDMtYWI3MS03ZDVjNDE0ZDIwMGFAMWU3MWNjNzQtYzgyZi00ZjEyLWExMjMtZDNlMzdmMzhmOTZiIiwib2lkIjoiMjFkZmFkMjctYWRiYy00ZTQ3LTg2M2YtYmNmNmM2NTc2YzJjIiwic3ViIjoiMjFkZmFkMjctYWRiYy00ZTQ3LTg2M2YtYmNmNmM2NTc2YzJjIiwidHJ1c3RlZGZvcmRlbGVnYXRpb24iOiJmYWxzZSJ9.lXnZDegY92SCE6TJP1TyidBTp1fLkgQKWSk9HcUxtdoAZdk2yl7DUGXdKq8ZAYkRbT0eRUTpMXnxQcKLgdNOygB6r6d-ORIiXAd197swkGzPcWn86E61etCOiSwdMEF_eNfYb8kwka_kJjxP7phNskFUKOwB-XrQFvRqYp48ZFm4kOOiaR7d9pDpSeDXid_Mo72JcL8ZrmiHMEaWs-5y2VaFIg1UQO-LVVRs1FRu-5BzSzdvrP5cXj43Uz1aubuJGemWS1NRiXRIpwY9PEteKArfmQqRSK462ezP3SeWXymkdyxpj1g83OCpdwuifqbWwI8ipMTyzYMaH3QFhfA1KQ',
        'Accept': 'application/json; odata=verbose',
        'Content-Type': 'text/plain'
      };
      var request = http.MultipartRequest('POST', Uri.parse(
          "https://tecnmsaltillo.sharepoint.com/sites/PruebaTsm/_api/web/GetFolderByServerRelativeUrl('/sites/PruebaTsm/Documentos compartidos/Datos')/Files/add(url='$fileName',overwrite=true)"));
      //request.body = 'test';
      var fileToUpload = await http.MultipartFile.fromBytes(fileName, iterable);
      request.headers.addAll(headers);
      request.files.add(fileToUpload);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        //await response.stream.bytesToString();
        _numberUser =  ((fileName.substring(22,fileName.length-4)));
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Mensaje'),
                content: Text('Archivo enviado con exito'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            });
      }
      else {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Alerta'),
                content: Text('Archivo no enviado'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            });
      }
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Alerta'),
              content: Text('$e'),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
    }

  }
}
class _MainScreenState extends State<MainScreen> {
  TextEditingController username = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController body = TextEditingController();
  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  String _numberUser="";
  String? mtoken = " ";

  @override
  void initState() {
    super.initState();

    requestPermission();

    loadFCM();

    listenFCM();

    getToken();

    subscribeTokenToTopic(mtoken,"");
    //FirebaseMessaging.instance.subscribeToTopic("Animal");
  }
  subscribeTokenToTopic(token, topic) async {
    try {
      await http.post(
        Uri.parse('https://iid.googleapis.com/iid/v1/'+token+'/rel/topics/'+topic),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=AAAAjzPs1gU:APA91bFITMYK7QK5rcn8Z77LPnM-r2tYLjSexOKRJEWIdjVp7jjLFoo1tnBtvgNtWJEOlOXNlyCkFz7Innn_q9mQaeacG2mooskdDmpYUH4JLJ7c2pjMH1A3-tqvIlTnjkj7dzauW7JW',
        },
      );
    } catch (e) {
      print("error push notification");
    }
  }
  void getTokenFromFirestore() async {

  }

  void saveToken(String token) async {
    await FirebaseFirestore.instance.collection("UserTokens").doc("User2").set({
      'token' : token,
    });
  }

  void sendPushMessage(String token, String body, String title) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=AAAAjzPs1gU:APA91bFITMYK7QK5rcn8Z77LPnM-r2tYLjSexOKRJEWIdjVp7jjLFoo1tnBtvgNtWJEOlOXNlyCkFz7Innn_q9mQaeacG2mooskdDmpYUH4JLJ7c2pjMH1A3-tqvIlTnjkj7dzauW7JW',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': body,
              'title': title
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": token,
          },
        ),
      );
    } catch (e) {
      print("error push notification");
    }
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then(
            (token) {
          setState(() {
            mtoken = token;
          });

          saveToken(token!);
        }
    );
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void listenFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: 'launch_background',
            ),
          ),
        );
      }
    });
  }

  void loadFCM() async {
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        importance: Importance.high,
        enableVibration: true,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: username,
            ),/*
            TextFormField(
              controller: username,
            ),
            TextFormField(
              controller: title,
            ),
            TextFormField(
              controller: body,
            ),


            GestureDetector(
              onTap: () async {
                String name = username.text.trim();
                String titleText = title.text;
                String bodyText = body.text;

                if(name != "") {
                  DocumentSnapshot snap =
                  await FirebaseFirestore.instance.collection("UserTokens").doc(name).get();
                  String token = snap['token'];
                  print(token);

                  sendPushMessage(token, titleText, bodyText);
                }
              },
              child: Container(
                height: 40,
                width: 200,
                color: Colors.red,
              ),
            ),
          ],*/
        ]
        ),
      ),
    floatingActionButton: FloatingActionButton(
    onPressed:() async {
      _uploadNew(context,_numberUser);
      DocumentSnapshot snap =
      await FirebaseFirestore.instance.collection("UserTokens").doc("User$_numberUser").get();
    String token = snap['token'];
    print(token);

    sendPushMessage(token, "Alerta", "Tienes un nuevo c");

    },

    tooltip: 'Increment',
    child: const Icon(Icons.add),
    )
    );
  }
}
