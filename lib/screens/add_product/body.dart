import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shop_fire/constans.dart';
import 'package:shop_fire/screens/add_product/widgets/pic_picker.dart';

final fireAuth = FirebaseAuth.instance;

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  // fields
  var _enteredTitle = '';
  var _enterdDescription = '';
  var _enterdPrice = '';
  var _categorey = 'phones';
  File? _selectedImage;

  final _form = GlobalKey<FormState>();
  bool _isSaving = false;

  void _submit() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    _form.currentState!.reset();

    final uid = fireAuth.currentUser!.uid;

    setState(() {
      _isSaving = true;
    });

    try {
      final storeRef = FirebaseStorage.instance
          .ref()
          .child('products')
          .child('${DateTime.now().toIso8601String()}.jpg');

      await storeRef.putFile(_selectedImage!);

      final imageUrl = await storeRef.getDownloadURL();

      await FirebaseFirestore.instance.collection('products').add(
        {
          'title': _enteredTitle,
          'description': _enterdDescription,
          'price': double.parse(_enterdPrice),
          'category': _categorey,
          'imageUrl': imageUrl,
          'userId': uid,
          'comments': [],
          'createdAt': Timestamp.now(),
        },
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('added succsefuly'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('something goes wrong'),
        ),
      );
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = ['phones', 'clothes', 'laptops', 'sport'];
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Form(
          key: _form,
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  label: Text('title'),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'title must not be empty';
                  }
                  return null;
                },
                onSaved: (v) {
                  _enteredTitle = v!;
                },
              ),
              const Gap(kDefaultPadding),
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  label: Text('description'),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'description must not be empty';
                  }
                  return null;
                },
                onSaved: (v) {
                  _enterdDescription = v!;
                },
              ),
              const Gap(kDefaultPadding),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.ideographic,
                children: [
                  Flexible(
                    flex: 1,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        label: Text('price'),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'price must not be empty';
                        }
                        return null;
                      },
                      onSaved: (v) {
                        _enterdPrice = v!;
                      },
                    ),
                  ),
                  const Spacer(),
                  // const SizedBox(width: kDefaultPaddin * 7),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _categorey,
                      onChanged: (val) {
                        setState(() {
                          _categorey = val!;
                        });
                      },
                      items: categories
                          .map(
                            (category) => DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            ),
                          )
                          .toList(),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(kDefaultPadding),
              PicPicker(
                onPickImage: (imageFile) {
                  _selectedImage = imageFile;
                },
              ),
              const Gap(kDefaultPadding),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: _isSaving ? null : _submit,
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('save'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
