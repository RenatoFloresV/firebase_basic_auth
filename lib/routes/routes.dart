import 'package:firebase_basic_auth/pages/logins_page.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
Map<String, WidgetBuilder> getAplicationRoutes(){

  return <String, WidgetBuilder>{
    '/home': (BuildContext context) => const LoginsPage(),

  };
}