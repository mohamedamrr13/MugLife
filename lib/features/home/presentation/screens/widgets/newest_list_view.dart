import 'package:drinks_app/core/routing/app_router.dart';
import 'package:drinks_app/features/home/logic/get_featured_product_cubit/get_featured_products_cubit.dart';
import 'package:drinks_app/features/home/presentation/screens/widgets/newest_list_view_item.dart';
import 'package:drinks_app/features/product/data/models/product_model.dart';
import 'package:drinks_app/utils/helper/helper_functions.dart';
import 'package:drinks_app/utils/shared/loading_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class NewestItemsListView extends StatefulWidget {
  const NewestItemsListView({super.key});

  @override
  State<NewestItemsListView> createState() => _NewestItemsListViewState();
}

class _NewestItemsListViewState extends State<NewestItemsListView> {
  final PageController _pageController = PageController(viewportFraction: 0.7);
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      int next = _pageController.page!.round();
      if (_currentIndex != next) {
        setState(() {
          _currentIndex = next;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetFeaturedProductsCubit, GetFeaturedProductsState>(
      builder: (context, state) {
        if (state is GetFeaturedProductsSuccess) {
          return SizedBox(
            height: 410,
            child: PageView.builder(
              controller: _pageController,
              padEnds: false,
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final ProductModel product = state.products[index];
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  transform:
                      Matrix4.identity()
                        ..scale(_currentIndex == index ? 1.1 : 0.9),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: GestureDetector(
                      onTap:
                          () => context.push(
                            AppRouter.itemDetailsScreen,
                            extra: {
                              'list': state.products,
                              'index': index.toDouble(),
                            },
                          ),
                      child: NewestListViewItem(
                        title: product.name.split(' ').first,
                        subtitle: product.name.split(' ').last,
                        type: HelperFunctions.capitalize(product.category),
                        duration: "30 min",
                        difficulty: "Easy",
                        likes: 534,
                        rating: 4.0,
                        imageAsset: product.image,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else if (state is GetFeaturedProductsFailure) {
          return Center(child: Text(state.errMessage));
        }
        return SizedBox(height: 410, child: LoadingDataWidget());
      },
    );
  }
}
