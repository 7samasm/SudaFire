import 'package:flutter/material.dart';
import 'package:shop_fire/models/category.dart';

import '../../../constans.dart';

class CategoriesList extends StatefulWidget {
  const CategoriesList({
    super.key,
  });

  @override
  State<CategoriesList> createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  var _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
      child: SizedBox(
        height: 25,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: Categories.values.length,
          itemBuilder: (ctx, i) => _buildCategoryItem(i),
        ),
      ),
    );
  }

  _buildCategoryItem(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: Column(
          children: [
            Text(Categories.values[index].name),
            Container(
              margin: const EdgeInsets.only(top: kDefaultPadding / 4),
              height: 2,
              width: 30,
              color:
                  _selectedIndex == index ? Colors.black : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}
