import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodiepops/models/UserData.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'fireStorePath.dart';
import 'firestoreService.dart';

@immutable
class User {
  const User({
    @required this.uid,
    this.email,
    this.photoUrl,
    this.displayName,
  });

  final String uid;
  final String email;
  final String photoUrl;
  final String displayName;
}

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookLogin _facebookSignIn = FacebookLogin();
  final _database = FirestoreService.instance;

  User _toUserFromFirebaseUser(FirebaseUser user) {
    if (user == null) {
      return null;
    }
    return User(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoUrl,
    );
  }

  Stream<User> get onAuthStateChanged {
    return _firebaseAuth.onAuthStateChanged.map(_toUserFromFirebaseUser);
  }

  // Handle various sign in methods - Google, Facebook, Email and Password and anonymously (mainly for testing)

  Future<User> signInAnonymously() async {
    final AuthResult authResult = await _firebaseAuth.signInAnonymously();
    return _toUserFromFirebaseUser(authResult.user);
  }

  Future<User> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _firebaseAuth.signInWithCredential(credential);

    await _saveUserDataIfNeeded(authResult, false);

    return _toUserFromFirebaseUser(authResult.user);
}

Future<dynamic> signInWithFacebook() async {
  final FacebookLoginResult result = await _facebookSignIn.logIn(['email']);

  final facebookAuthCred = FacebookAuthProvider.getCredential(accessToken: result.accessToken.token);

  final authResult = await _firebaseAuth.signInWithCredential(facebookAuthCred);

  await _saveUserDataIfNeeded(authResult, false);

  return _toUserFromFirebaseUser(authResult.user);
}

  Future<User> signInWithEmailAndPassword(String email, String password) async {
    final AuthResult authResult = await _firebaseAuth
        .signInWithCredential(EmailAuthProvider.getCredential(
      email: email,
      password: password,
    ));
    return _toUserFromFirebaseUser(authResult.user);
  }

  Future<User> createUserWithEmailAndPassword(
      String email, String password, bool isBusinessUser) async {
    final AuthResult authResult = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    await _saveUserDataIfNeeded(authResult, isBusinessUser);
    
    return _toUserFromFirebaseUser(authResult.user);
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<User> currentUser() async {
    final FirebaseUser user = await _firebaseAuth.currentUser();
    return _toUserFromFirebaseUser(user);
  }

  Future<void> signOut() async {
    final isSignedInWithGoogle = await _googleSignIn.isSignedIn();
    final isSignedInWithFacebook = await _facebookSignIn.isLoggedIn;

    if (isSignedInWithGoogle) {
      await _googleSignIn.signOut();
    }

    if (isSignedInWithFacebook) {
      await _facebookSignIn.logOut();
    }

    await _firebaseAuth.signOut();
  }

  Future<void> _saveUserDataIfNeeded (AuthResult authResult, bool isBusinessUser) async{
    if (authResult.additionalUserInfo.isNewUser) {
      await _setUserData(UserData(id: authResult.user.uid, isBusinessUser: isBusinessUser));
    }
  }

  Future<void> _setUserData(UserData userData) async => await _database.setData(
        path: FirestorePath.userData(userData.id),
        data: userData.toMap(),
        documentId: userData.id
  );
}
