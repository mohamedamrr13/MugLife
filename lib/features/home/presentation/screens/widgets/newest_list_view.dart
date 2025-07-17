import 'package:drinks_app/core/routing/app_router.dart';
import 'package:drinks_app/features/home/presentation/screens/widgets/newest_list_view_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class NewestItemsListView extends StatelessWidget {
  const NewestItemsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 370,
      child: ListView.builder(
        padding: EdgeInsets.only(left: 16),
        scrollDirection: Axis.horizontal,
        itemCount: 12,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => context.push(AppRouter.itemDetailsScreen),
            child: NewestListViewItem(
              title: "Blue",
              subtitle: "Moon",
              type: "Mocktail",
              duration: "30 min",
              difficulty: "Easy",
              likes: 534,
              rating: 4.0,
              imageAsset:
                  "assets/images/blue_moon.png", // Replace with your asset
            ),
          );
        },
      ),
    );
  }
}
