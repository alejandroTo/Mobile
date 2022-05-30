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



_uploadNew (BuildContext context,String numberUser) async {

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
        'Authorization': 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6ImpTMVhvMU9XRGpfNTJ2YndHTmd2UU8yVnpNYyIsImtpZCI6ImpTMVhvMU9XRGpfNTJ2YndHTmd2UU8yVnpNYyJ9.eyJhdWQiOiIwMDAwMDAwMy0wMDAwLTBmZjEtY2UwMC0wMDAwMDAwMDAwMDAvdGVjbm1zYWx0aWxsby5zaGFyZXBvaW50LmNvbUAxZTcxY2M3NC1jODJmLTRmMTItYTEyMy1kM2UzN2YzOGY5NmIiLCJpc3MiOiIwMDAwMDAwMS0wMDAwLTAwMDAtYzAwMC0wMDAwMDAwMDAwMDBAMWU3MWNjNzQtYzgyZi00ZjEyLWExMjMtZDNlMzdmMzhmOTZiIiwiaWF0IjoxNjUzOTQzNjIyLCJuYmYiOjE2NTM5NDM2MjIsImV4cCI6MTY1NDAzMDMyMiwiaWRlbnRpdHlwcm92aWRlciI6IjAwMDAwMDAxLTAwMDAtMDAwMC1jMDAwLTAwMDAwMDAwMDAwMEAxZTcxY2M3NC1jODJmLTRmMTItYTEyMy1kM2UzN2YzOGY5NmIiLCJuYW1laWQiOiIyZmNiZTU5NC1iM2RkLTQ1ZDMtYWI3MS03ZDVjNDE0ZDIwMGFAMWU3MWNjNzQtYzgyZi00ZjEyLWExMjMtZDNlMzdmMzhmOTZiIiwib2lkIjoiMjFkZmFkMjctYWRiYy00ZTQ3LTg2M2YtYmNmNmM2NTc2YzJjIiwic3ViIjoiMjFkZmFkMjctYWRiYy00ZTQ3LTg2M2YtYmNmNmM2NTc2YzJjIiwidHJ1c3RlZGZvcmRlbGVnYXRpb24iOiJmYWxzZSJ9.mdh4lgXJVKanHp5C9HEhDNqOMnLILIS7AFMP6hwAGIj0qzYhmRfP0ViJmmZvwH1dyp22EKlo0cBi9b7vmspsmQeZbL1HI7khRJ97uPqh3uPIOQNMVL4tscdzrhvIE5aj0m1XDQNtMPLLOgXqtRURi08UvQX_QPDz1GxxGyOQM1wIAVIucmc5f-RZszZFhGoA7oV7kc_w_wpgOprmuKqvuEzBSzLOT0by5o1gYvKxr1uj5jj5K4_GVcdsUkbx2pelgbTplPQ_ImYMv4a51FOHqfjpG9p2sFmMouZ2rb_jqJ_HC7JP_aYsWGgr0I5fhfqXW5Ha-x8nIEYgOXjdYQk3gg',
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
        numberUser =  ((fileName.substring(22,fileName.length-4)));
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

    //subscribeTokenToTopic(mtoken,"weather");
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
          //'Authorization': 'key=AAAAjzPs1gU:APA91bFITMYK7QK5rcn8Z77LPnM-r2tYLjSexOKRJEWIdjVp7jjLFoo1tnBtvgNtWJEOlOXNlyCkFz7Innn_q9mQaeacG2mooskdDmpYUH4JLJ7c2pjMH1A3-tqvIlTnjkj7dzauW7JW',
          'Authorization': 'key=AAAABax0ty8:APA91bGN6EXG7q_n9q6uGr6ElAfoe0jEyyi-ZkKPwpWMHQMW8sqcjn0MuBIT2LjVuVyJgush3bKhLBSqxFxCQF2rnHTB0BWjJBhsC5ZOAKzEBLk7kQ2qufmADL_q4ZJ3z5tcBHZssHpg',

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
      print("exito");
      print("$token");
    }

    catch (e) {
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
          //print(token);
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
          children: const [
        ]
        ),
      ),
    floatingActionButton: FloatingActionButton(
    onPressed:() async {
      _uploadNew(context,_numberUser);
      DocumentSnapshot snap =
      await FirebaseFirestore.instance.collection("UserTokens").doc("User1").get();
      //print("$_numberUser fdsfd");
      String token = snap['token'];
      print(token);

      sendPushMessage("cdXh-BvuQ4GBNcbkip-ADY:APA91bFurIlVi8R28tS5ktzcXeiweN1T5DekV7042RaCpPKmz5OfBCd9YEmO0Rro92-cuHUz3HfzjTGiyGugahpJXHAReHfleNBOluMauqibDQ34uPXN_XeWNRU5-FOx-NGYccWcHwEY", "Alerta", "Tienes un nuevo docuemnto");
      print(token);
    },

    tooltip: 'Increment',
    child: const Icon(Icons.add),
    )
    );
  }
}
