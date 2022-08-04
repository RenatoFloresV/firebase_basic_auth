import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth.dart';

class UserData extends StatelessWidget {
  const UserData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    const snackBar = SnackBar(
      content: Text('You are now signed in'),
      duration: Duration(seconds: 2),
    );
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Firebase Basic Auth',
            style: TextStyle(color: Colors.black, shadows: [
              Shadow(
                color: Colors.grey,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ])),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Text(
                  'Welcome ${authService.user.displayName}',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              Center(
                child: CircleAvatar(
                  radius: 64.0,
                  backgroundImage: authService.user.photoURL != null
                      ? NetworkImage('${authService.user.photoURL}')
                      : null,
                  child: authService.user.photoURL == null
                      ? Text(
                          authService.user.displayName!.substring(0, 1),
                          style: Theme.of(context).textTheme.headline4,
                        )
                      : null,
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              Text(
                'Name: ${authService.user.displayName}',
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(
                height: 16.0,
              ),
              const SizedBox(
                height: 16.0,
              ),
              Text(
                'email: ${authService.user.email}',
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(
                height: 16.0,
              ),
              Text(
                'uid: ${authService.user.uid}',
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(
                height: 16.0,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await authService.signOut();
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  child: const Text('Sign Out'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
