import 'package:flutter/material.dart';

import '../../../constans.dart';

class ColorRadio extends StatelessWidget {
  const ColorRadio({
    required this.onTap,
    required this.value,
    required this.groupValue,
    this.color = Colors.black,
    super.key,
  });
  final Color color;
  final int value;
  final int groupValue;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin / 12),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 24,
          height: 24,
          padding: const EdgeInsets.all(2.5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: value == groupValue ? color : Colors.transparent,
              width: 3,
            ),
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
