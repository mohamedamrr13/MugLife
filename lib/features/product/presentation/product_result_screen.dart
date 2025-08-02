import 'package:drinks_app/features/product/logic/get_products_by_category_cubit/get_products_by_category_cubit.dart';
import 'package:drinks_app/features/product/presentation/widgets/custom_appbar.dart';
import 'package:drinks_app/features/product/presentation/widgets/product_list_view.dart';
import 'package:drinks_app/utils/colors/app_colors.dart';
import 'package:drinks_app/utils/helper/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductResultScreen extends StatefulWidget {
  const ProductResultScreen({super.key, required this.category});
  final String category;
  @override
  State<ProductResultScreen> createState() => _ProductResultScreenState();
}

class _ProductResultScreenState extends State<ProductResultScreen> {
  ScrollController controller = ScrollController();
  @override
  void initState() {
    BlocProvider.of<GetProductsByCategoryCubit>(
      context,
    ).getProductsByCategory(widget.category);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgScaffoldColor,

      body: Column(
        children: [
          Container(height: 60, color: AppColors.white),
          CustomAppbar(
            color: AppColors.white,
            title: HelperFunctions.capitalize(widget.category),
            subTitle: "Choose Your Favourite",

            prefixIcon: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.mainColor.withAlpha(50),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.shopping_cart_outlined,
                color: AppColors.black,
                size: 24,
              ),
            ),
          ),

          BlocBuilder<GetProductsByCategoryCubit, GetProductsByCategoryState>(
            builder: (context, state) {
              if (state is GetProductsByCategorySuccess) {
                return ProductListView(
                  controller: controller,
                  products: state.products,
                );
              } else if (state is GetProductsByCategoryFailure) {
                return Center(child: Text(state.errMessage));
              }
              return Center(
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: AppColors.mainColor,
                ),
              );
            },
          ),
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
