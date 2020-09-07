import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:gustolact/src/providers/login_provider.dart';
import 'package:gustolact/src/shared_preferences/user_preferences.dart';

class PushNotificationProvider {

  static UserPreferences _userPreferences = new UserPreferences();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  final StreamController<Map<String,dynamic>> _messagesStreamController =
      new StreamController<Map<String,dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get messagesStream => _messagesStreamController.stream;

  final StreamController<Map<String,dynamic>> _bgSteamController =
      new StreamController<Map<String,dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get bgStream => _bgSteamController.stream;

  dispose() {
    _messagesStreamController?.close();
    _bgSteamController?.close();
  }

  clearMessage(){
    _messagesStreamController.sink.add(null);
  }

  static Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  }

  initNotifications() async {

    await _firebaseMessaging.requestNotificationPermissions();
    final token = await _firebaseMessaging.getToken();

    print("FCMT : ");
    print(token);
    _userPreferences.fcmtToken = token;

    _firebaseMessaging.configure(
      onMessage: onMessage,
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: onLaunch,
      onResume: onResume,
    );
  }

  Future<dynamic> onMessage(Map<String, dynamic> message) async {
    print("on - message");
    final data = message['data'];
    _messagesStreamController.sink.add({"type": "message", "data": data});
  }

  Future<dynamic> onResume(Map<String, dynamic> message) async {
    print("on - resume");
//    final data = message['data'];
    _messagesStreamController.sink.add({
      "type": "resume",
      "data": message
    });
  }

  Future<dynamic> onLaunch(Map<String, dynamic> message) async {

    final data = message['data'];
    _bgSteamController.sink.add({
      "type": "launch",
      "data": data
    });
  }

}
