import 'package:cached_network_image/cached_network_image.dart';
import 'package:drinks_app/features/home/data/models/category_model.dart';
import 'package:drinks_app/utils/colors/app_colors.dart';
import 'package:flutter/material.dart';

class CategoryItem extends StatefulWidget {
  const CategoryItem({super.key, required this.category,required this.onTap});
  final CategoryModel category;
  final VoidCallback onTap;

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _borderColorAnimation;


  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _borderColorAnimation = ColorTween(
      begin: AppColors.mainColor.withAlpha(100),
      end: AppColors.mainColor,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() {
    });
    _animationController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
    });
    _animationController.reverse();
    widget.onTap.call();
  }

  void _handleTapCancel() {
    setState(() {
    });
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(
                    color:
                        _borderColorAnimation.value ??
                        AppColors.mainColor.withAlpha(100),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withAlpha(22),
                      blurRadius: 5,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                width: 150,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: CachedNetworkImage(
                        imageUrl: widget.category.image,
                        height: 100,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.category.name,
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.black.withAlpha(230),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    // Text(
                    //   "50 mixes",
                    //   style: TextStyle(
                    //     color: Color(0xffFB7D8A),
                    //     fontWeight: FontWeight.w600,
                    //   ),
                    // ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
