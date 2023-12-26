
import 'dart:async';

import 'package:apex/api_directory/login_api.dart';
import 'package:apex/home%20page%20screens/session_popup.dart';
import 'package:apex/models/login_data.dart';
import 'package:provider/provider.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../model.dart';
BuildContext? signalRContext;
class SignalRService with ChangeNotifier {
  LoginData massage=LoginData();
  String  serverUrl ="http://192.168.1.253:8091/NotificationHub";
  var hubConnection ;

 // StreamController<LoginData> messageStreamController = StreamController.broadcast();

  void signalInit()async {
    final connectionOptions = HttpConnectionOptions(
        accessTokenFactory: () async => Future(()async => await Future.value(loginapi.token)));
     hubConnection = HubConnectionBuilder().withUrl(
        serverUrl, options: connectionOptions).withAutomaticReconnect().build();
  }
  Future<void> startConnection() async {
    if (hubConnection.state == HubConnectionState.Disconnected){
      //massage=LoginData();
      await hubConnection.start();
      listenToMessages();
      //notifyListeners();
    }
  }

  Future<void> stopConnection() async {
    if (hubConnection.state == HubConnectionState.Connected) {
      await hubConnection.stop();
    }
    //await hubConnection.stop();
  }

  void listenToMessages() {
    hubConnection.on('LogoutNotification',(args){
      massage.result = 0;
      for(var signal in args){
        print(signal["result"]);
        massage.result=signal["result"];
        massage.errorMassageEn=signal["errorMessageEn"];
        massage.errorMassageAr =signal["errorMessageAr"];
      }
     String popUpMassage=Provider.of<modelprovider>(signalRContext!,listen: false).applocal == Locale("ar") ? massage.errorMassageAr! : massage.errorMassageEn!;
      //showDialog(context: signalRContext!, builder: (_)=> SessionPopUp(massage: popUpMassage,newContext: signalRContext!, ));
      ToShowPopUpTest().toShowPopUpTest(navigatorKey.currentContext!, popUpMassage);
      // if(massage.result!=0){
      //   notifyListeners();
      // }
      //massage.result= args.result;
     // messageStreamController.add(massage);// here may make execption in return type
    });
    //print("teh argument in listen is ${massage.result}");


  }

  Future sendMessage(String message) async {
    await hubConnection.invoke('SendMessage', args: [message]);
  }
}