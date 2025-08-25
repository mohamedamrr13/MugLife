import 'package:drinks_app/features/home/logic/get_categories_cubit/get_categories_cubit.dart';
import 'package:drinks_app/features/home/logic/get_featured_product_cubit/get_featured_products_cubit.dart';
import 'package:drinks_app/features/home/presentation/screens/widgets/categoreis_list_view.dart';
import 'package:drinks_app/features/home/presentation/screens/widgets/newest_list_view.dart';
import 'package:drinks_app/utils/theme/app_theme.dart';
import 'package:drinks_app/utils/theme/theme_extensions.dart';
import 'package:drinks_app/utils/shared/loading_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreenBody extends StatefulWidget {
  const HomeScreenBody({super.key});

  @override
  State<HomeScreenBody> createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<HomeScreenBody> {
  @override
  void initState() {
    BlocProvider.of<GetCategoriesCubit>(context).getCategories();
    BlocProvider.of<GetFeaturedProductsCubit>(context).getFeaturedProducts();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).primaryColor,
                boxShadow: [
                  BoxShadow(
                    color: context.primaryColor.withOpacity(0.7),
                    blurRadius: 1,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppTheme.primaryColor,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              "Categories",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: theme.primaryTextColor,
              ),
            ),
          ),
          SizedBox(height: 16),
          BlocBuilder<GetCategoriesCubit, GetCategoriesState>(
            builder: (context, state) {
              if (state is GetCategoriesSuccess) {
                return CategoreisListView(categories: state.categories);
              } else if (state is GetCategoriesFailure) {
                return Center(child: Text(state.errMessage));
              }
              return SizedBox(height: 200, child: LoadingDataWidget());
            },
          ),
          SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              "Check Out Our New Recipes",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: theme.primaryTextColor,
              ),
            ),
          ),
          SizedBox(height: 16),

          NewestItemsListView(),
        ],
      ),
    );
  }
}
