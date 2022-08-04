import 'package:firebase_basic_auth/pages/register_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import '../../services/auth.dart';
import '../widgets/form.dart';

class LoginsPage extends StatelessWidget {
  const LoginsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = AuthService.instance();

    return Scaffold(
      body: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Hero(
            tag: 'logo',
            child: Image(
                image: const AssetImage(
                  'assets/firebase_auth_logo.png',
                ),
                width: MediaQuery.of(context).size.width * 0.8),
          )),
          const SizedBox(
            height: 16.0,
          ),
          const FormWidget(),
          const SizedBox(
            height: 8.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Not a member?',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              const SizedBox(
                width: 16.0,
              ),
              RichText(
                  text: TextSpan(
                      text: 'Sign up',
                      style: const TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const RegisterPage(),
                            ),
                          );
                        })),
            ],
          ),
          const SizedBox(
            height: 16.0,
          ),
          SignInButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            Buttons.GoogleDark,
            onPressed: () async {
              await auth.signInWithGoogle();
            },
          ),
          const SizedBox(
            height: 16.0,
          ),
          SignInButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            Buttons.Facebook,
            onPressed: () async {
              await auth.signInWithFacebook();
            },
          ),
          const SizedBox(
            height: 16.0,
          ),
          SignInButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            Buttons.Twitter,
            onPressed: () async {
              await auth.signInWithTwitter();
            },
          ),
        ],
      ),
    );
  }
}
