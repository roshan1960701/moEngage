import 'package:flutter/material.dart';
import 'package:moengage/remoteConfigService.dart';
import 'package:package_info/package_info.dart';
class remoteScreen extends StatefulWidget {
  @override
  _remoteScreenState createState() => _remoteScreenState();
}

class _remoteScreenState extends State<remoteScreen> {

  remoteConfigService _remoteConfigService;


  initializeRemoteConfig() async{
    _remoteConfigService =  await remoteConfigService.getInstance();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    print("App Name: ${packageInfo.appName}");
    print("Package Name: ${packageInfo.packageName}");
    print("Version: ${packageInfo.version}");
    print("Build Number: ${packageInfo.buildNumber}");

     /*packageInfo = await PackageInfo.fromPlatform();
      AppName = packageInfo.appName;
      packageName = packageInfo.packageName;
      version = packageInfo.version;
      buildNumber = packageInfo.buildNumber;*/
    await _remoteConfigService.initialize(context);
/*     setState(() {
       isLoading = false;
     });*/
  }

  @override
  void initState() {
    // TODO: implement initState
    initializeRemoteConfig();
   // getAppInfo();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
        ],
      ),
    );
  }
}
