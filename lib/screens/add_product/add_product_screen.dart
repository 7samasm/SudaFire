import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shop_fire/constans.dart';
import 'package:shop_fire/screens/add_product/widgets/pic_picker.dart';

final fireAuth = FirebaseAuth.instance;

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  // fields
  var _enteredTitle = '';
  var _enterdDescription = '';
  var _enterdPrice = '';
  var _categorey = 'phones';
  File? _selectedImage;

  final _form = GlobalKey<FormState>();
  bool _isSaving = false;

  void _submit() async {
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Add Product'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPaddin),
          child: Card(
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(kDefaultPaddin - 7),
              child: Form(
                key: _form,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        label: Text('title'),
                      ),
                      onSaved: (v) {
                        _enteredTitle = v!;
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        label: Text('description'),
                      ),
                      onSaved: (v) {
                        _enterdDescription = v!;
                      },
                    ),
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
                            ),
                            onSaved: (v) {
                              _enterdPrice = v!;
                            },
                          ),
                        ),
                        const Spacer(),
                        // const SizedBox(width: kDefaultPaddin * 7),
                        DropdownButton(
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
                        ),
                      ],
                    ),
                    const Gap(20),
                    PicPicker(
                      onPickImage: (imageFile) {
                        _selectedImage = imageFile;
                      },
                    ),
                    const Gap(20),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton.icon(
                        onPressed: _isSaving ? null : _submit,
                        icon: const Icon(Icons.save),
                        label: const Text('save'),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
