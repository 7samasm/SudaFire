import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_fire/constans.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AuthScreenState createState() => _AuthScreenState();
}

final fireAuth = FirebaseAuth.instance;

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();
  bool _isLogin = true;
  bool _isAuthenticating = false;

  // input values
  var _enteredEmail = '';
  var _enteredUsername = '';
  var _enteredPassword = '';

  void _submit() async {
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
      if (_isLogin) {
        await fireAuth.signInWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );
      } else {
        final userCredential = await fireAuth.createUserWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'email': _enteredEmail,
          'username': _enteredUsername,
        });
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isAuthenticating = false;
      });
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'faild to authenticate'),
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
            padding: const EdgeInsets.all(kDefaultPaddin),
            child: Column(
              children: [
                Icon(
                  Icons.shopping_cart_sharp,
                  size: 150,
                  color: Theme.of(context).colorScheme.primary,
                ),
                Padding(
                  padding: const EdgeInsets.all(kDefaultPaddin),
                  child: Form(
                    key: _form,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          key: UniqueKey(),
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(kDefaultPaddin * 2),
                              ),
                            ),
                          ),
                          onSaved: (value) {
                            _enteredEmail = value!;
                          },
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                !value.contains('@')) {
                              return 'please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        if (!_isLogin) ...[
                          const SizedBox(height: kDefaultPaddin - 5),
                          TextFormField(
                            key: UniqueKey(),
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'username',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(kDefaultPaddin * 2),
                                ),
                              ),
                            ),
                            onSaved: (value) {
                              _enteredUsername = value!;
                            },
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'please enter username';
                              }
                              return null;
                            },
                          ),
                        ],
                        const SizedBox(height: kDefaultPaddin - 5),
                        TextFormField(
                          key: UniqueKey(),
                          decoration: const InputDecoration(
                            labelText: 'password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(kDefaultPaddin * 2),
                              ),
                            ),
                          ),
                          obscureText: true,
                          onSaved: (value) {
                            _enteredPassword = value!;
                          },
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'please enter a password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: kDefaultPaddin - 5),
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            disabledBackgroundColor: Colors.grey,
                            disabledForegroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            fixedSize: const Size(
                                double.maxFinite, kDefaultPaddin * 2.8),
                          ),
                          onPressed: _isAuthenticating ? null : _submit,
                          icon: const Icon(Icons.login),
                          label: Text(_isLogin ? 'login' : 'signup'),
                        ),
                        const SizedBox(height: kDefaultPaddin - 5),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isLogin = !_isLogin;
                            });
                            _form.currentState!.reset();
                          },
                          child: Text(
                            _isLogin
                                ? 'sign up if you don\'t have account'
                                : 'login up if you\'ve account',
                          ),
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
