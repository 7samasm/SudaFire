import 'package:flutter/material.dart';
import 'package:shop_fire/constans.dart';

class MaterialDialog extends StatelessWidget {
  const MaterialDialog({
    required this.title,
    required this.content,
    this.showDivider = false,
    required this.passButton,
    this.leadingTextActions = const Text(''),
    super.key,
  });

  final String title;
  final Widget content;
  final bool showDivider;
  final TextButton passButton;
  final Widget leadingTextActions;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          width: double.maxFinite,
          height: 380,
          child: Card(
            child: Column(
              children: [
                Container(
                  width: double.maxFinite,
                  height: 80,
                  // padding: const EdgeInsets.only(left: kDefaultPaddin),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    // textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          height: 2.5,
                          color: Theme.of(context).colorScheme.surface,
                        ),
                  ),
                ),
                Expanded(child: content),
                if (showDivider) const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kDefaultPadding,
                    vertical: kDefaultPadding / 3.5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    textBaseline: TextBaseline.ideographic,
                    children: [
                      leadingTextActions,
                      const Spacer(),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        label: const Text('cancel'),
                        icon: const Icon(Icons.clear_outlined),
                        // style: TextButton.styleFrom(
                        //   foregroundColor:
                        //       Theme.of(context).colorScheme.secondary,
                        // ),
                      ),
                      passButton,
                    ],
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
