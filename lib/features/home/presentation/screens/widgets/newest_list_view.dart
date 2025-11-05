import 'dart:async';
import 'package:drinks_app/core/routing/app_router.dart';
import 'package:drinks_app/features/home/logic/get_featured_product_cubit/get_featured_products_cubit.dart';
import 'package:drinks_app/features/home/presentation/screens/widgets/newest_list_view_item.dart';
import 'package:drinks_app/features/product/data/models/product_model.dart';
import 'package:drinks_app/utils/helper/helper_functions.dart';
import 'package:drinks_app/utils/shared/loading_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class FeaturedItemsListView extends StatefulWidget {
  const FeaturedItemsListView({super.key});

  @override
  State<FeaturedItemsListView> createState() => _FeaturedItemsListViewState();
}

class _FeaturedItemsListViewState extends State<FeaturedItemsListView> {
  final PageController _pageController = PageController(viewportFraction: 0.7);
  int _currentIndex = 0;
  Timer? _autoScrollTimer;
  bool _userInteracting = false;

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
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!_userInteracting && _pageController.hasClients) {
        final state = context.read<GetFeaturedProductsCubit>().state;
        if (state is GetFeaturedProductsSuccess) {
          final nextPage = (_currentIndex + 1) % state.products.length;
          _pageController.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOutCubic,
          );
        }
      }
    });
  }

  void _onUserInteractionStart() {
    setState(() {
      _userInteracting = true;
    });
  }

  void _onUserInteractionEnd() {
    setState(() {
      _userInteracting = false;
    });
    _startAutoScroll();
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetFeaturedProductsCubit, GetFeaturedProductsState>(
      builder: (context, state) {
        if (state is GetFeaturedProductsSuccess) {
          return Column(
            children: [
              SizedBox(
                height: 410,
                child: GestureDetector(
                  onPanDown: (_) => _onUserInteractionStart(),
                  onPanEnd: (_) => _onUserInteractionEnd(),
                  onPanCancel: () => _onUserInteractionEnd(),
                  child: PageView.builder(
                    controller: _pageController,
                    padEnds: false,
                    itemCount: state.products.length,
                    itemBuilder: (context, index) {
                      final ProductModel product = state.products[index];
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOutCubic,
                        transform: Matrix4.identity()
                          ..scale(_currentIndex == index ? 1.1 : 0.9),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: GestureDetector(
                            onTap: () => context.push(
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
                ),
              ),
              const SizedBox(height: 16),
              // Page indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  state.products.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    width: _currentIndex == index ? 24 : 8,
                    decoration: BoxDecoration(
                      color: _currentIndex == index
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).primaryColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ],
          );
        } else if (state is GetFeaturedProductsFailure) {
          return Center(child: Text(state.errMessage));
        }
        return SizedBox(height: 410, child: LoadingDataWidget());
      },
    );
  }
}
