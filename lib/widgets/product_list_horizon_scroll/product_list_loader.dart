import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductListLoader extends StatelessWidget {
  const ProductListLoader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'mmmmm',
            style: TextStyle(height: 3),
          ),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (context, index) {
                return Card(
                  child: SizedBox(
                    height: 50,
                    width: 120,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Image.asset('assets/images/bag_6.png'),
                        const Text('mmm'),
                        const Text('mmmmmmmmm'),
                        const Text('mmmmmmmm'),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
