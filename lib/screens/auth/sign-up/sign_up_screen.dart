import 'package:flutter/material.dart';
import 'package:shop_fire/constans.dart';
import 'package:shop_fire/screens/auth/sign-up/sign_up_form_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _signUpWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // The user canceled the sign-in
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // Check if the user is new
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (!userDoc.exists) {
          // Add the user to Firestore
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            'email': user.email,
            'username': user.displayName,
          });
        }

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const SignUpFormScreen(),
          ),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to sign up with Google: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const SignUpFormScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.account_circle),
              label: const Text('Sign up with Email'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                padding: const EdgeInsets.all(kDefaultPadding),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton.icon(
              onPressed: () {
                _signUpWithGoogle(context);
              },
              icon: const Icon(Icons.account_circle),
              label: const Text('Sign up with Google'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.red,
                padding: const EdgeInsets.all(
                  kDefaultPadding,
                ), // Google button color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
