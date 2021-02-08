import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:moengage/remoteScreen.dart';
import 'package:moengage_flutter/app_status.dart';
import 'package:moengage_flutter/moengage_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:moengage_flutter/inapp_campaign.dart';
import 'package:moengage_flutter/push_campaign.dart';
import 'package:moengage/remoteConfigService.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:moengage/user.dart';
import 'package:moengage/Employee.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moengage',
      theme: ThemeData(
        primarySwatch: Colors.blue,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'moengage'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final MoEngageFlutter _moengagePlugin = MoEngageFlutter();
  String token = " ";
  int _counter = 0;
  remoteConfigService _remoteConfigService;
  Employee employeeList;



  initializeRemoteConfig() async{
    _remoteConfigService =  await remoteConfigService.getInstance();

    await _remoteConfigService.initialize(context);
/*     setState(() {
       isLoading = false;
     });*/
  }
  @override
  void initState(){

    super.initState();
    initializeRemoteConfig();
    _moengagePlugin.initialise();
    _moengagePlugin.setAppStatus(MoEAppStatus.install);
    _moengagePlugin.registerForPushNotification();
    getToken();
    // getHttpData();
    getdata();

    _moengagePlugin.showInApp();

  }

  // Future<List<User>> getHttpData() async{
  //   var url = 'http://jsonplaceholder.typicode.com/users';
  //
  //   // Await the http get response, then decode the json-formatted response.
  //   var response = await http.get(url);
  //   if (response.statusCode == 200) {
  //
  //     var jsonResponse = json.decode(response.body.toString());
  //     //var itemCount = jsonResponse['totalItems'];
  //     //final user = userFromJson(jsonResponse);
  //     // user = User.fromJson(jsonResponse);
  //     print("Type: $user");
  //     // List<dynamic> list = jsonResponse;
  //
  //     //print("users: ${user.name[0]}");
  //     /*for(int i = 0 ;i< u;i++){
  //       print(employeeList.data[i].employeeName);
  //     }*/
  //      //print('Number of books about http: $jsonResponse.');
  //     //print(jsonResponse[0]);
  //   } else {
  //     print('Request failed with status: ${response.statusCode}.');
  //   }
  // }

  Future<List<Datum>> getdata() async {
    final response =
    await http.get('http://dummy.restapiexample.com/api/v1/employees');

    if (response.statusCode == 200) {
      var responseList = json.decode(response.body.toString());
      //employeeList = new EmployeeList.fromJson(responseList);
      employeeList = Employee.fromJson(responseList);
      //print("users: ${employeeList.data}");
      for(int i = 0 ;i< employeeList.data.length;i++){
        print(employeeList.data[i].employeeName);
      }

      // return employeeList.data;
    } else {
      throw Exception('Failed to load ');
    }
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _onInAppClick(InAppCampaign message) {
    print("This is a inapp click callback from native to flutter. Payload " +
        message.toString());
  }

  void _onInAppShown(InAppCampaign message) {
    print("This is a callback on inapp shown from native to flutter. Payload " +
        message.toString());
  }

  void _onInAppDismiss(InAppCampaign message) {
    print("This is a callback on inapp dismiss from native to flutter. Payload " +
        message.toString());
  }

  void _onInAppCustomAction(InAppCampaign message) {
    print("This is a callback on inapp custom action from native to flutter. Payload " +
        message.toString());
  }

  void _onInAppSelfHandle(InAppCampaign message) {
    print("This is a callback on inapp self handle from native to flutter. Payload " +
        message.toString());
  }
  void _onPushClick(PushCampaign message) {
    print("This is a push click callback from native to flutter. Payload " +
        message.toString());
  }

  getToken() async {
    _moengagePlugin.setUpPushCallbacks(_onPushClick);
    _moengagePlugin.setUpInAppCallbacks(
        onInAppClick: _onInAppClick,
        onInAppShown: _onInAppShown,
        onInAppDismiss: _onInAppDismiss,
        onInAppCustomAction: _onInAppCustomAction,
        onInAppSelfHandle: _onInAppSelfHandle
    );

    if (Platform.isIOS) {
      firebaseMessaging.requestNotificationPermissions(
          IosNotificationSettings(sound: true, badge: true, alert: true));
      firebaseMessaging.onIosSettingsRegistered
          .listen((IosNotificationSettings settings) {
        print("Settings registered: $settings");
      });
    }
    firebaseMessaging.getToken().then((value) {
      token = value.toString();
      _moengagePlugin.passFCMPushToken(token);

      print("Token: $token");
    }).catchError((onError) {
      print("Exception: $onError");
    });
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("Message: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        //_navigateToItemDetail(message);
        print("Resume: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
       // _navigateToItemDetail(message);
        print("Launch: $message");
      },
    );
    // firebaseMessaging.subscribeToTopic("AartiSangraha");
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            MaterialButton(
              minWidth: 100,
              height: 40,
              elevation: 10.0,
              onPressed: ()async{
              Navigator.push(context, MaterialPageRoute(builder: (context) => remoteScreen()));
              },
              color: Colors.deepOrangeAccent,
            child: Text("Remote Page",style: TextStyle(color: Colors.white),),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
