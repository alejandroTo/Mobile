import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:file_picker/file_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Carga de Archivos'),
    );
  }
}

_uploadNew (BuildContext context) async {

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
        'Authorization': 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6ImpTMVhvMU9XRGpfNTJ2YndHTmd2UU8yVnpNYyIsImtpZCI6ImpTMVhvMU9XRGpfNTJ2YndHTmd2UU8yVnpNYyJ9.eyJhdWQiOiIwMDAwMDAwMy0wMDAwLTBmZjEtY2UwMC0wMDAwMDAwMDAwMDAvdGVjbm1zYWx0aWxsby5zaGFyZXBvaW50LmNvbUAxZTcxY2M3NC1jODJmLTRmMTItYTEyMy1kM2UzN2YzOGY5NmIiLCJpc3MiOiIwMDAwMDAwMS0wMDAwLTAwMDAtYzAwMC0wMDAwMDAwMDAwMDBAMWU3MWNjNzQtYzgyZi00ZjEyLWExMjMtZDNlMzdmMzhmOTZiIiwiaWF0IjoxNjUzNTc5OTcxLCJuYmYiOjE2NTM1Nzk5NzEsImV4cCI6MTY1MzY2NjY3MSwiaWRlbnRpdHlwcm92aWRlciI6IjAwMDAwMDAxLTAwMDAtMDAwMC1jMDAwLTAwMDAwMDAwMDAwMEAxZTcxY2M3NC1jODJmLTRmMTItYTEyMy1kM2UzN2YzOGY5NmIiLCJuYW1laWQiOiIyZmNiZTU5NC1iM2RkLTQ1ZDMtYWI3MS03ZDVjNDE0ZDIwMGFAMWU3MWNjNzQtYzgyZi00ZjEyLWExMjMtZDNlMzdmMzhmOTZiIiwib2lkIjoiMjFkZmFkMjctYWRiYy00ZTQ3LTg2M2YtYmNmNmM2NTc2YzJjIiwic3ViIjoiMjFkZmFkMjctYWRiYy00ZTQ3LTg2M2YtYmNmNmM2NTc2YzJjIiwidHJ1c3RlZGZvcmRlbGVnYXRpb24iOiJmYWxzZSJ9.Jb8HxYYprVtncjzC_kVqVdz-dQjCzn2EOO2JZvcEdswpWcrIZpz_KPdAZszzAElnp_-J1qNOugC6NRRPkuNNhEpVap_h1nC2IkQjSVOm2fpp6spIr6MLFQ5B0o9PcFylp4rgIqdn3pCzCw68sHwXiJGq5B4lyhjfI25A4sHy_ziRQ54c-I-ftJMbNysqirGhZN5R1_Kx-HUoxzZm9frqOgZEY2RRB6vi8Y9dCQHO4Oddt5-myxibleJAhMfEsFcz2oLzSIdoXp5s7CN3DJVXB7FzsdwsuUbyMaI_R9cfmlnOoLdHBSHQ6hWZ4j--GoJX2WfiC9XaAOU4qpk59JooOA',
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
_postData(AlertDialog alert,BuildContext context) async{
  var TenantName="tecnmsaltillo";
  var SiteName="PruebaTsm";
  var ListName="Test";
  Map<String,String> headers = {'Content-Type':'application/json;odata=verbose','authorization':"Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6ImpTMVhvMU9XRGpfNTJ2YndHTmd2UU8yVnpNYyIsImtpZCI6ImpTMVhvMU9XRGpfNTJ2YndHTmd2UU8yVnpNYyJ9.eyJhdWQiOiIwMDAwMDAwMy0wMDAwLTBmZjEtY2UwMC0wMDAwMDAwMDAwMDAvdGVjbm1zYWx0aWxsby5zaGFyZXBvaW50LmNvbUAxZTcxY2M3NC1jODJmLTRmMTItYTEyMy1kM2UzN2YzOGY5NmIiLCJpc3MiOiIwMDAwMDAwMS0wMDAwLTAwMDAtYzAwMC0wMDAwMDAwMDAwMDBAMWU3MWNjNzQtYzgyZi00ZjEyLWExMjMtZDNlMzdmMzhmOTZiIiwiaWF0IjoxNjUzNDg5MjMzLCJuYmYiOjE2NTM0ODkyMzMsImV4cCI6MTY1MzU3NTkzMywiaWRlbnRpdHlwcm92aWRlciI6IjAwMDAwMDAxLTAwMDAtMDAwMC1jMDAwLTAwMDAwMDAwMDAwMEAxZTcxY2M3NC1jODJmLTRmMTItYTEyMy1kM2UzN2YzOGY5NmIiLCJuYW1laWQiOiIyZmNiZTU5NC1iM2RkLTQ1ZDMtYWI3MS03ZDVjNDE0ZDIwMGFAMWU3MWNjNzQtYzgyZi00ZjEyLWExMjMtZDNlMzdmMzhmOTZiIiwib2lkIjoiMjFkZmFkMjctYWRiYy00ZTQ3LTg2M2YtYmNmNmM2NTc2YzJjIiwic3ViIjoiMjFkZmFkMjctYWRiYy00ZTQ3LTg2M2YtYmNmNmM2NTc2YzJjIiwidHJ1c3RlZGZvcmRlbGVnYXRpb24iOiJmYWxzZSJ9.Nd5-Haf9EB1-YsR3372nAvvKh6HeaMF_OjloaaAkX97WNFwNF1w0X2OtdMH8Tl-8S2X56qtr6g0_Acmt0C_FWUQUm0p7CUsCB1fjtqxjoEw5uGakEB2cIxDFeV7Q9Dqtp-wsQELsZsIpBd6vpAypeeIXMdsGrOGSoJ3eW8DWVQk3AEI_xqtAO60u7fVV_OHNoriT7C487B5N4ASraCuadxUGXg8QYi31ApGnUVMdt8f7WHx9jXVZkrCJUHxEzQcUejdVzd2KuJDfbwkVKMbQ5rsSDng582Kdl8zlS4UYRtlqSEpDYkQOvEvO8CI3z2nnqw8RyppFn84JE0JIdDyGkw",};
  final msg = jsonEncode({
    "__metadata": {
    "type": "SP.Data.TestListItem"
  },
    "Title": "Flutter"
  });
  //https://{{TenantName}}.sharepoint.com/sites/{{SiteName}}/_api/web/lists/GetByTitle('{{ListName}}')/ite
  try{
    var respone = await http.post(
        Uri.parse(
            "https://tecnmsaltillo.sharepoint.com/sites/PruebaTsm/_api/web/lists/GetByTitle('Test')/items"),
        body:msg,
        headers: headers);
    print(respone.body);
  }
  catch (e){
    print(e);

  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:()=>_uploadNew(context,),


        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
