import 'package:drinks_app/features/home/data/models/category_model.dart';
import 'package:drinks_app/features/home/logic/get_categories_cubit/get_categories_cubit.dart';
import 'package:drinks_app/features/home/presentation/screens/widgets/categoreis_list_view.dart';
import 'package:drinks_app/features/home/presentation/screens/widgets/error_widget.dart';
import 'package:drinks_app/utils/theme/theme_extensions.dart';
import 'package:flutter/material.dart' hide ErrorWidget;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Categories",
                style: context.textTheme.headlineSmall?.copyWith(
                  color: context.primaryTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                height: 3,
                width: 40,
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      context.primaryColor,
                      context.primaryColor.withOpacity(0.5),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
        BlocBuilder<GetCategoriesCubit, GetCategoriesState>(
          builder: (context, state) {
            if (state is GetCategoriesSuccess) {
              return CategoreisListView(categories: state.categories);
            } else if (state is GetCategoriesFailure) {
              return ErrorWidget(message: state.errMessage);
            }
            // Loading state with Skeletonizer
            return Skeletonizer(
              enabled: true,
              child: CategoreisListView(
                categories: List.generate(
                  4,
                  (index) => CategoryModel(
                    image: '',
                    name: '',
                  ), // Create dummy Category objects
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
