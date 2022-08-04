import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_basic_auth/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:twitter_login/twitter_login.dart';

enum AuthStatus {
  unInitialized,
  authenticated,
  authenticating,
  unAuthenticated,
}

class AuthService with ChangeNotifier {
  final FirebaseAuth? _auth;
  GoogleSignInAccount? _googleSignInAccount;
  UserModel _userModel = UserModel();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  AuthStatus _status = AuthStatus.unInitialized;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthService.instance() : _auth = FirebaseAuth.instance {
    _auth!.authStateChanges().listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      _status = AuthStatus.unAuthenticated;
    } else {
      DocumentSnapshot userSnap =
          await _db.collection('users').doc(firebaseUser.uid).get();
      _userModel = UserModel.fromFirestore(userSnap);

      _status = AuthStatus.authenticated;
    }
    notifyListeners();
  }

  Future<UserModel?> signInWithGoogle() async {
    _status = AuthStatus.authenticating;
    notifyListeners();

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      _googleSignInAccount = googleUser;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential authResult =
          await _auth!.signInWithCredential(credential);
      final User? user = authResult.user;
      await updateUserData(user!);
      notifyListeners();
      return _userModel;
    } catch (e) {
      _status = AuthStatus.unAuthenticated;
      notifyListeners();
      return null;
    }
  }

  Future<UserModel?> signInWithFacebook() async {
    _status = AuthStatus.authenticating;
    notifyListeners();

    try {
      final LoginResult result = await FacebookAuth.instance.login();
      final UserCredential authResult = await _auth!.signInWithCredential(
          FacebookAuthProvider.credential(result.accessToken!.token));
      final User? user = authResult.user;
      await updateUserData(user!);
      notifyListeners();
      return _userModel;
    } catch (e) {
      _status = AuthStatus.unAuthenticated;
      notifyListeners();
      return null;
    }
  }

  Future<UserModel?> signInWithEmailAndPassword(
      String email, String password) async {
    _status = AuthStatus.authenticating;
    notifyListeners();

    try {
      final UserCredential authResult = await _auth!
          .signInWithEmailAndPassword(email: email, password: password);
      final User? user = authResult.user;
      await updateUserData(user!);
      notifyListeners();
      return _userModel;
    } catch (e) {
      _status = AuthStatus.unAuthenticated;
      notifyListeners();
      return null;
    }
  }

  Future<UserModel?> signInWithTwitter() async {
    _status = AuthStatus.authenticating;
    notifyListeners();

    try {
      final twitterLogin = TwitterLogin(
        apiKey: '3uSIqmMuFpynhxkYa6Qc52YAC',
        apiSecretKey: 'fwy8vWWbo8kOioefNa7aYsba7jTCG4uIetKU8FHwUYvGVzqFfm',
        redirectURI: 'twitterauthbasics://',
      );
      final authResult = await twitterLogin.login();
      final UserCredential authResult2 = await _auth!.signInWithCredential(
          TwitterAuthProvider.credential(
              accessToken: authResult.authToken!,
              secret: authResult.authTokenSecret!));
      final User? user = authResult2.user;
      await updateUserData(user!);
      notifyListeners();
      return _userModel;
    } catch (e) {
      _status = AuthStatus.unAuthenticated;
      notifyListeners();
      return null;
    }
  }

  Future<UserModel?> createUserWithEmailAndPassword(
      String email, String password) async {
    _status = AuthStatus.authenticating;
    notifyListeners();

    try {
      final UserCredential authResult = await _auth!
          .createUserWithEmailAndPassword(email: email, password: password);
      final User? user = authResult.user;
      await updateUserData(user!);
      notifyListeners();
      return _userModel;
    } catch (e) {
      _status = AuthStatus.unAuthenticated;
      notifyListeners();
      return null;
    }
  }

  Future<DocumentSnapshot> updateUserData(User user) async {
    DocumentReference userRef = _db.collection('users').doc(user.uid);

    userRef.set({
      'uid': user.uid,
      'email': user.email,
      'lastSign': DateTime.now(),
      'photoURL': user.photoURL,
      'displayName': user.displayName ?? user.email?.split('@')[0],
    }, SetOptions(merge: true));

    DocumentSnapshot userData = await userRef.get();

    return userData;
  }

  Future<void> signOut() async {
    _auth!.signOut();
    _googleSignInAccount = null;
    _status = AuthStatus.unAuthenticated;
    notifyListeners();
  }

  AuthStatus get status => _status;
  UserModel get user => _userModel;
  GoogleSignInAccount get googleUser => _googleSignInAccount!;
}
