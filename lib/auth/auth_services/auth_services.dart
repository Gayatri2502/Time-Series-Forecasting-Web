import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../screens/desktop_home_screen.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool isLoading = false;

  Future<void> signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    isLoading = true;
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (userCredential.user != null) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => DesktopHomeScreen()));
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: ${e.message}')));
    } finally {
      isLoading = false;
    }
  }

  Future<void> signUpWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    isLoading = true;
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => DesktopHomeScreen()));
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: ${e.message}')));
    } finally {
      isLoading = false;
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    isLoading = true;
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final UserCredential authResult =
            await _auth.signInWithCredential(credential);
        if (authResult.user != null) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => DesktopHomeScreen()));
        }
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error signing in with Google: $error')));
    } finally {
      isLoading = false;
    }
  }

  Future<void> signUpWithGoogle(BuildContext context) async {
    isLoading = true;
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final UserCredential authResult =
            await _auth.signInWithCredential(credential);
        if (authResult.user != null) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => DesktopHomeScreen()));
        }
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error signing up with Google: $error')));
    } finally {
      isLoading = false;
    }
  }

  Future<void> signOut(BuildContext context) async {
    isLoading = true;
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error signing out: $error')));
    } finally {
      isLoading = false;
    }
  }
}
