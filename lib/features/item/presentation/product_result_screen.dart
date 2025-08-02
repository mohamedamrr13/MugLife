import 'package:drinks_app/features/item/presentation/widgets/custom_appbar.dart';
import 'package:drinks_app/features/item/presentation/widgets/product_list_view.dart';
import 'package:drinks_app/utils/colors/app_colors.dart';
import 'package:flutter/material.dart';

class DrinksScreen extends StatefulWidget {
  const DrinksScreen({super.key});

  @override
  State<DrinksScreen> createState() => _DrinksScreenState();
}

class _DrinksScreenState extends State<DrinksScreen> {
  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgScaffoldColor,

      body: Column(
        children: [
          Container(height: 60, color: AppColors.white),
          CustomAppbar(
            color: AppColors.white,
            title: "Menu",
            subTitle: "Choose Your Favourite",

            prefixIcon: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF4A5568).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.shopping_cart_outlined,
                color: AppColors.black,
                size: 24,
              ),
            ),
          ),

          DrinkListView(controller: controller),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
