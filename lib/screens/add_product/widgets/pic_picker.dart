import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PicPicker extends StatefulWidget {
  const PicPicker({Key? key, required this.onPickImage}) : super(key: key);

  final void Function(File imageFile) onPickImage;

  @override
  // ignore: library_private_types_in_public_api
  _PicPickerState createState() => _PicPickerState();
}

class _PicPickerState extends State<PicPicker> {
  File? _pickedImageFile;

  void _pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage == null) {
      return;
    }
    setState(() {
      _pickedImageFile = File(pickedImage.path);
    });

    widget.onPickImage(_pickedImageFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.grey,
          foregroundImage:
              _pickedImageFile != null ? FileImage(_pickedImageFile!) : null,
        ),
        const Spacer(),
        TextButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.image),
          label: const Text('add photo'),
        ),
      ],
    );
  }
}
