import 'package:drinks_app/features/home/presentation/screens/widgets/category_item.dart';
import 'package:flutter/material.dart';

class CategoreisListView extends StatelessWidget {
  const CategoreisListView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        padding: EdgeInsets.only(left: 16),
        scrollDirection: Axis.horizontal,
        itemCount: 12,
        itemBuilder: (context, index) {
          return CategoryItem();
        },
      ),
    );
  }
}
