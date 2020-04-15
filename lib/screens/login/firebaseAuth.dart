import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
final FacebookLogin facebookSignIn = FacebookLogin();

Future<dynamic> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final AuthResult authResult = await _firebaseAuth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await _firebaseAuth.currentUser();
  assert(user.uid == currentUser.uid);

  return user;
}

void signOutGoogle() async{
  await googleSignIn.signOut();

  print("User Sign Out");
}

Future<dynamic> signInWithFacebook() async {
  final FacebookLoginResult result = await facebookSignIn.logIn(['email']);

  final facebookAuthCred = FacebookAuthProvider.getCredential(accessToken: result.accessToken.token);

  final authResult = await _firebaseAuth.signInWithCredential(facebookAuthCred);

  final FirebaseUser user = authResult.user;

  final FirebaseUser currentUser = await _firebaseAuth.currentUser();
  assert(user.uid == currentUser.uid);

  return user;
}

void signOutFacebook() async {
    await facebookSignIn.logOut();
    print('Signed out');
}