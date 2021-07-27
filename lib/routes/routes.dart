import 'package:flutter/material.dart';
import 'package:dnd_charactersheet_app/screens/LoginScreen.dart';
import 'package:dnd_charactersheet_app/screens/VerifiedScreen.dart';

class Routes {
  static const String LOGIN_SCREEN = '/login';
  static const String VERIFIED_SCREEN = '/verified';

  // routes of pages in the app
  static Map<String, Widget Function(BuildContext)> get getroutes => {
        '/': (context) => LoginScreen(),
        LOGIN_SCREEN: (context) => LoginScreen(),
        VERIFIED_SCREEN: (context) => VerifiedScreen(),
      };
}
