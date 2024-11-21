import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PicPicker extends StatefulWidget {
  const PicPicker({super.key, required this.onPickImage});

  final void Function(File imageFile) onPickImage;

  @override
  // ignore: library_private_types_in_public_api
  _PicPickerState createState() => _PicPickerState();
}

class _PicPickerState extends State<PicPicker> {
  File? _pickedImageFile;

  void _pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
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
        TextButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.add_a_photo_outlined),
          label: const Text('add a photo'),
        ),
        const Spacer(),
        CircleAvatar(
          backgroundColor: Colors.grey,
          foregroundImage:
              _pickedImageFile != null ? FileImage(_pickedImageFile!) : null,
        ),
      ],
    );
  }
}
