import 'package:flutter/material.dart';
import 'package:shop_fire/screens/details/widgets/color_radio.dart';

class ColorsGroup extends StatefulWidget {
  const ColorsGroup({
    super.key,
  });

  @override
  State<ColorsGroup> createState() => _ColorsGroupState();
}

class _ColorsGroupState extends State<ColorsGroup> with RestorationMixin {
  final RestorableInt radioValue = RestorableInt(0);
  List<Color> colors = [Colors.pink, Colors.indigo, Colors.grey];
  _changeRadio(int value) {
    setState(() {
      radioValue.value = value;
    });
  }

  @override
  void dispose() {
    radioValue.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < colors.length; i++)
          ColorRadio(
            color: colors[i],
            value: i,
            groupValue: radioValue.value,
            onTap: () {
              _changeRadio(i);
            },
          ),
        // ColorRadio(color: Colors.brown),
      ],
    );
  }

  @override
  String? get restorationId => 'radio';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(radioValue, 'radio_value');
  }
}
