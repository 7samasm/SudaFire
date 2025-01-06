import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_fire/constans.dart';
import 'package:shop_fire/screens/auth/sign-up/sign_up_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AuthScreenState createState() => _AuthScreenState();
}

final fireAuth = FirebaseAuth.instance;

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();
  bool _isAuthenticating = false;

  // input values
  var _enteredPassword = '';
  var _enteredUsernameOrEmail = '';

  void _logIn() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    // _form.currentState!.reset();
    try {
      setState(() {
        _isAuthenticating = true;
      });

      String email = _enteredUsernameOrEmail;
      // Check if the input is a username
      if (!_enteredUsernameOrEmail.contains('@')) {
        // Query Firestore to get the email associated with the username
        final usernameQuery = await FirebaseFirestore.instance
            .collection('users')
            .where('username', isEqualTo: _enteredUsernameOrEmail)
            .get();
        if (usernameQuery.docs.isEmpty) {
          throw FirebaseAuthException(
            code: 'user-not-found',
            message: 'err_msg_un_not_exist'.tr(),
          );
        }
        email = usernameQuery.docs.first['email'];
      }
      await fireAuth.signInWithEmailAndPassword(
        email: email,
        password: _enteredPassword,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isAuthenticating = false;
      });
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'An error occurred. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: Column(
              children: [
                Icon(
                  Icons.shopping_cart_sharp,
                  size: 150,
                  color: Theme.of(context).colorScheme.primary,
                ),
                Padding(
                  padding: const EdgeInsets.all(kDefaultPadding),
                  child: Form(
                    key: _form,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          key: UniqueKey(),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'un_or_email'.tr(),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(kDefaultPadding * 2),
                              ),
                            ),
                          ),
                          onSaved: (value) {
                            _enteredUsernameOrEmail = value!;
                          },
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'err_msg_email'.tr();
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: kDefaultPadding - 5),
                        TextFormField(
                          key: UniqueKey(),
                          decoration: InputDecoration(
                            labelText: 'password'.tr(),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(kDefaultPadding * 2),
                              ),
                            ),
                          ),
                          obscureText: true,
                          onSaved: (value) {
                            _enteredPassword = value!;
                          },
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'err_msg_pw'.tr();
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: kDefaultPadding - 5),
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            disabledBackgroundColor: Colors.grey,
                            disabledForegroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            fixedSize: const Size(
                                double.maxFinite, kDefaultPadding * 2.8),
                          ),
                          onPressed: _isAuthenticating ? null : _logIn,
                          icon: const Icon(Icons.login),
                          label: const Text('login').tr(),
                        ),
                        const SizedBox(height: kDefaultPadding - 5),
                        TextButton(
                          onPressed: () {
                            // setState(() {
                            //   _isLogin = !_isLogin;
                            // });
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => SignUpScreen(),
                                fullscreenDialog: true,
                              ),
                            );
                            _form.currentState!.reset();
                          },
                          child: const Text('sign up hint').tr(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
