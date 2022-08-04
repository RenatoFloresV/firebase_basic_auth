import 'package:firebase_basic_auth/pages/user_data.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/logins_page.dart';
import 'services/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthService.instance(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Material App',
          home: Consumer(
            builder: (context, AuthService authService, _) {
              switch (authService.status) {
                case AuthStatus.unAuthenticated:
                  return const LoginsPage();
                case AuthStatus.authenticating:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case AuthStatus.authenticated:
                  return const UserData();
                  
                default:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
              }
            },
          )),
    );
  }
}
