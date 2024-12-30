import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'widgets/body.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Add Product').tr(),
      ),
      body: const Body(),
    );
  }
}
