import 'package:flutter/material.dart';
import 'package:shop_fire/constans.dart';

class MaterialDialog extends StatelessWidget {
  const MaterialDialog({
    required this.title,
    required this.content,
    this.showDivider = false,
    required this.action,
    this.leadingTextActions = const Text(''),
    super.key,
  });

  final String title;
  final Widget content;
  final bool showDivider;
  final TextButton action;
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
                SizedBox(
                  width: double.maxFinite,
                  height: 50,
                  // padding: const EdgeInsets.only(left: kDefaultPaddin),
                  // decoration: BoxDecoration(
                  //   borderRadius: const BorderRadius.only(
                  //     topLeft: Radius.circular(12),
                  //     topRight: Radius.circular(12),
                  //   ),
                  //   color: Theme.of(context).colorScheme.primary,
                  // ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          // textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    height: 2.5,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inverseSurface,
                                  ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.close_outlined),
                        ),
                      ),
                    ],
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
                      action,
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
