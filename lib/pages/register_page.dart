import 'package:firebase_basic_auth/pages/user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

import '../services/auth.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = AuthService.instance();

    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Register',
            style: TextStyle(color: Colors.black, shadows: [
              Shadow(
                color: Colors.grey,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ])),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 16.0,
          ),
          Hero(
            tag: 'logo',
            child: Image(
                image: const AssetImage(
                  'assets/firebase_auth_logo.png',
                ),
                width: MediaQuery.of(context).size.width * 0.8),
          ),
          const SizedBox(height: 24.0),
          Form(
              child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                ),
                const Divider(
                  height: 16.0,
                ),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                ),
                const Divider(
                  height: 16.0,
                ),
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                ),
                const Divider(
                  height: 16.0,
                ),
                SignInButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  Buttons.Email,
                  onPressed: () async {
                    if (passwordController.text !=
                        confirmPasswordController.text) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Error'),
                          content: const Text('Passwords do not match'),
                          actions: [
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        ),
                      );
                    } else {
                      await auth.createUserWithEmailAndPassword(
                          emailController.text, passwordController.text);
                    }
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const UserData(),
                      ),
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
