import 'package:flutter/material.dart';

class SearchBoxDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Column(
      children: [
        Text("Other posts"),
        Divider(height: 1, thickness: 1),
      ],
    );
  }

  @override
  double get maxExtent => 40.0; // Height of the search box

  @override
  double get minExtent => 40.0; // Ensures it disappears fully

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}
