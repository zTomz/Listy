import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future singInWithEmailAndPassword(String email, String password) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return "Signed In";
  } catch (e) {
    return e.toString();
  }
}

Future<String> singUpWithEmailAndPassword(
    String email, String password, String repeatPassword) async {
  if (password != repeatPassword) {
    return "Passwords dont match";
  }

  try {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return "Signed In";
  } catch (e) {
    return e.toString();
  }
}

Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  debugPrint("Signed in with Google");
  // Once signed in, return the user credential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}
