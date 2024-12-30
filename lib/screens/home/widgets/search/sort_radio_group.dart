import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SortRadioGroup extends StatefulWidget {
  const SortRadioGroup({
    required this.onChange,
    super.key,
  });

  final Function(int value) onChange;

  @override
  State<SortRadioGroup> createState() => _SortRadioGroupState();
}

class _SortRadioGroupState extends State<SortRadioGroup> with RestorationMixin {
  final RestorableInt sortRadioValue = RestorableInt(0);
  _changeSortRadio(int value) {
    setState(() {
      sortRadioValue.value = value;
    });
    widget.onChange(value);
  }

  @override
  void dispose() {
    sortRadioValue.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        RadioListTile(
          value: 0,
          title: const Text('descending').tr(),
          groupValue: sortRadioValue.value,
          secondary: const Icon(Icons.arrow_drop_down_outlined),
          controlAffinity: ListTileControlAffinity.trailing,
          onChanged: (v) {
            _changeSortRadio(v!);
          },
        ),
        RadioListTile(
          value: 1,
          title: const Text('ascending').tr(),
          groupValue: sortRadioValue.value,
          secondary: const Icon(Icons.arrow_drop_up_outlined),
          controlAffinity: ListTileControlAffinity.trailing,
          onChanged: (v) {
            _changeSortRadio(v!);
          },
        ),
      ],
    );
  }

  @override
  String? get restorationId => 'sortRadio';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(sortRadioValue, 'sortRadio_value');
  }
}
