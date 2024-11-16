import 'package:flutter/material.dart';

import '../../constans.dart';

class SeeAllButton extends StatelessWidget {
  const SeeAllButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: kDefaultPadding,
        left: kDefaultPadding / 4,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.arrow_forward_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            Text(
              'see all',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            )
          ],
        ),
      ),
    );
  }
}
