import 'package:drinks_app/core/routing/app_router.dart';
import 'package:drinks_app/features/home/presentation/screens/widgets/newest_list_view_item.dart';
import 'package:flutter/cupertino.dart';
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
    return SizedBox(
      height: 410,
      child: PageView.builder(
        controller: _pageController,
        padEnds: false,
        itemCount: 12,
        itemBuilder: (context, index) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            transform:
                Matrix4.identity()..scale(_currentIndex == index ? 1.1 : 0.9),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: GestureDetector(
                onTap: () => context.push(AppRouter.itemDetailsScreen),
                child: NewestListViewItem(
                  title: "Blue",
                  subtitle: "Moon",
                  type: "Mocktail",
                  duration: "30 min",
                  difficulty: "Easy",
                  likes: 534,
                  rating: 4.0,
                  imageAsset: "assets/images/blue_moon.png",
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
