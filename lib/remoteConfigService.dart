import 'package:flutter/material.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info/package_info.dart';
import 'package:moengage/updateAlert.dart';

class remoteConfigService{
   String splashScreenUrl,splashScreenDate;

  final RemoteConfig _remoteConfig;
  remoteConfigService({RemoteConfig remoteConfig}): _remoteConfig = remoteConfig;

  final defaults = <String,dynamic>{
  'SplashScreenUrl':'',
  'SplashScreenDate':'',
  'UpdateMandatory':'',
  'Version':''
  };

  static remoteConfigService _instance;
  static Future<remoteConfigService> getInstance() async{
    if(_instance == null){
      _instance = remoteConfigService(
      remoteConfig: await RemoteConfig.instance,
      );
  }
    return _instance;
  }

  String get getRemoteUrl => _remoteConfig.getString('SplashScreenUrl');
  String get getRemoteDate => _remoteConfig.getString('SplashScreenDate');
  String get getRemoteVersion =>_remoteConfig.getString('Version');
  bool get getRemoteMandatory =>_remoteConfig.getBool('UpdateMandatory');

  Future initialize(context) async{
    try{
       await _remoteConfig.setDefaults(defaults);
       await _fetchAndActivate(context);
   } on FetchThrottledException catch(e){
      print("Remote config fetch throttle: $e");
    } catch(e){
      print("Unable to fetch remote config. Default value will be used");
    }
   }

   Future _fetchAndActivate(context) async{
    await _remoteConfig.fetch(expiration: Duration(milliseconds: 100));
    await _remoteConfig.activateFetched();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    utility _utility = new utility();

    var splashUrl = sharedPreferences.getString('splashUrl') ?? ' ';
    var splashDate = sharedPreferences.getString('splashDate') ?? ' ';

    print("Remote URL $getRemoteUrl");
    print("Remote Date $getRemoteDate");
    print("Remote Version $getRemoteVersion");

    String appVersion = getRemoteVersion;

    var AppBuild = getRemoteVersion.split('+');
    print("appBundle : ${AppBuild[1]}");
    print("App Bundle: ${packageInfo.buildNumber}");

    print("Remote Mandatory $getRemoteMandatory");
    print("Splash URL $splashUrl");

    if(getRemoteMandatory){
      if(int.parse(AppBuild[1]) > int.parse(packageInfo.buildNumber)){
        print("Version is different");
        _utility.showUpdateAlertAndroid(context);
      }
    }

    if(splashUrl.isEmpty){
      sharedPreferences.setString('splashUrl', getRemoteUrl);
      sharedPreferences.setString('splashDate', getRemoteDate);
      print("splashUrl is empty");
    }
    else{
        if(getRemoteDate != splashDate){
          /*if(getRemoteDate == splashDate){
            //Do Nothing
            print("Dates are same");
          }*/
          // else{
            print("Remote Url: $getRemoteUrl");
            print("Remote Date: $getRemoteDate");
            // _videoDownload.downloadVideoOnline(getRemoteUrl, getRemoteDate);
            sharedPreferences.setString('splashDate', getRemoteDate);
          // }
        }
    }





   }


}