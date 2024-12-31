import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shop_fire/screens/settings/widgets/body.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: const Body(),
    );
  }
}

AppBar _buildAppBar() {
  return AppBar(
    title: const Text('settings').tr(),
  );
}
