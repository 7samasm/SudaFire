import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_fire/constans.dart';
import 'package:shop_fire/screens/auth/auth_screen.dart';

class SignUpFormScreen extends StatefulWidget {
  const SignUpFormScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignUpFormScreenState createState() => _SignUpFormScreenState();
}

final fireAuth = FirebaseAuth.instance;

class _SignUpFormScreenState extends State<SignUpFormScreen> {
  final _form = GlobalKey<FormState>();
  bool _isAuthenticating = false;

  // input values
  var _enteredEmail = '';
  var _enteredPassword = '';
  var _enteredUsername = '';

  _signUp() async {
    if (_form.currentState!.validate()) {
      _form.currentState!.save();
      try {
        setState(() {
          _isAuthenticating = true;
        });
        final emailExists = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: _enteredEmail)
            .get();

        if (emailExists.docs.isNotEmpty) {
          throw FirebaseAuthException(
            code: 'email-already-in-use',
            message: 'err_msg_email_exist'.tr(),
          );
        }

        // Check if username already exists
        final usernameExists = await FirebaseFirestore.instance
            .collection('users')
            .where('username', isEqualTo: _enteredUsername)
            .get();

        if (usernameExists.docs.isNotEmpty) {
          throw FirebaseAuthException(
            code: 'username-already-in-use',
            message: 'err_msg_un_exist'.tr(),
          );
        }

        final userCredential = await fireAuth.createUserWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );
        await userCredential.user!.updateDisplayName(_enteredUsername);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'email': _enteredEmail,
          'username': _enteredUsername,
        });
      } on FirebaseAuthException catch (e) {
        setState(() {
          _isAuthenticating = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message ?? 'An error occurred. Please try again.'),
          ),
        );
      } catch (e) {
        setState(() {
          _isAuthenticating = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred while signing up.'),
          ),
        );
      }
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
                            labelText: 'username'.tr(),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(kDefaultPadding * 2),
                              ),
                            ),
                          ),
                          onSaved: (value) {
                            _enteredUsername = value!;
                          },
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'err_msg_un'.tr();
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: kDefaultPadding - 5),
                        TextFormField(
                          key: UniqueKey(),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'email'.tr(),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(kDefaultPadding * 2),
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
                          onPressed: _isAuthenticating ? null : _signUp,
                          icon: const Icon(Icons.login),
                          label: const Text('sign up').tr(),
                        ),
                        const SizedBox(height: kDefaultPadding - 5),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const AuthScreen()),
                            );
                            _form.currentState!.reset();
                          },
                          child: const Text('login hint').tr(),
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
