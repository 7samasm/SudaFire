import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_fire/providers/fire_source_provider.dart';
import 'package:shop_fire/providers/theme_mode_provider.dart';

final languages = {"ar": "عربي", "en": "english"};

class Body extends StatelessWidget {
  const Body({super.key});

  // static Route<void> _fullscreenDialogRoute(
  //   BuildContext context,
  //   Object? arguments,
  // ) {
  //   return
  // }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          dense: true,
          style: ListTileStyle.drawer,
          leading: const Icon(Icons.language),
          title: const Text('language').tr(),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return Scaffold(
                    appBar: AppBar(
                      title: const Text('language').tr(),
                    ),
                    body: ListView(
                      children: context.supportedLocales.map(
                        (local) {
                          return CheckboxListTile.adaptive(
                            value: context.locale.languageCode ==
                                local.languageCode,
                            title: Text(languages[local.languageCode]!),
                            activeColor:
                                Theme.of(context).colorScheme.secondary,
                            onChanged: (value) {
                              context.setLocale(local);
                            },
                          );
                        },
                      ).toList(),
                    ),
                  );
                },
                fullscreenDialog: true,
              ),
            );
          },
        ),
        Consumer(
          builder: (context, ref, child) {
            ref.watch(themeModeProvider);
            final themeNotifier = ref.read(themeModeProvider.notifier);
            return SwitchListTile.adaptive(
              dense: true,
              secondary: const Icon(Icons.dark_mode_outlined),
              title: const Text('dark mode').tr(),
              value: themeNotifier.isDark,
              onChanged: (v) {
                ref
                    .read(fireSourcProvider.notifier)
                    .changeSourceToCacheAndRevertAfterAwhile();
                themeNotifier.toggleMode();
              },
            );
          },
        ),
      ],
    );
  }
}
