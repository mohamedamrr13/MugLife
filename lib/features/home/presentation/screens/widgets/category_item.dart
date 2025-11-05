import 'package:cached_network_image/cached_network_image.dart';
import 'package:drinks_app/features/home/data/models/category_model.dart';
import 'package:drinks_app/utils/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class CategoryItem extends StatefulWidget {
  const CategoryItem({super.key, required this.category, required this.onTap});

  final CategoryModel category;
  final VoidCallback onTap;

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _hoverController;
  late AnimationController _entranceController;
  late AnimationController _shimmerController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _hoverAnimation;
  late Animation<double> _entranceAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _shimmerAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _entranceController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..repeat();

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _hoverAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );

    _entranceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: Curves.elasticOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: Curves.easeOutCubic,
      ),
    );

    _shimmerAnimation = Tween<double>(begin: -2.0, end: 2.0).animate(
      _shimmerController,
    );

    _entranceController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _hoverController.dispose();
    _entranceController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
    _animationController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    _animationController.reverse();
    widget.onTap.call();
  }

  void _handleTapCancel() {
    setState(() {
      _isPressed = false;
    });
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    _hoverAnimation.value.clamp(0.0, 1.0);

    return FadeTransition(
      opacity: _entranceAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: ScaleTransition(
          scale: _entranceAnimation,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: GestureDetector(
              onTapDown: _handleTapDown,
              onTapUp: _handleTapUp,
              onTapCancel: _handleTapCancel,
              child: AnimatedBuilder(
                animation: Listenable.merge([
                  _animationController,
                  _hoverController,
                  _shimmerController,
                ]),
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Container(
                      width: 160,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            context.isDark
                                ? Colors.white.withOpacity(
                                  0.1 + (_hoverAnimation.value * 0.05),
                                )
                                : Colors.white.withOpacity(
                                  0.7 + (_hoverAnimation.value * 0.2),
                                ),
                            context.isDark
                                ? Colors.white.withOpacity(
                                  0.05 + (_hoverAnimation.value * 0.03),
                                )
                                : Colors.white.withOpacity(
                                  0.4 + (_hoverAnimation.value * 0.1),
                                ),
                            context.isDark
                                ? Colors.white.withOpacity(0.02)
                                : Colors.white.withOpacity(0.2),
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                        border: Border.all(
                          color:
                              _isPressed
                                  ? context.primaryColor.withOpacity(0.6)
                                  : context.isDark
                                  ? Colors.white.withOpacity(
                                    0.2 + (_hoverAnimation.value * 0.1),
                                  )
                                  : Colors.white.withOpacity(
                                    0.5 + (_hoverAnimation.value * 0.2),
                                  ),
                          width: 1.5 + (_glowAnimation.value * 0.5),
                        ),
                        boxShadow: [
                          // Main shadow
                          BoxShadow(
                            color:
                                context.isDark
                                    ? Colors.black.withOpacity(0.4)
                                    : context.primaryColor.withOpacity(
                                      0.08 + (_hoverAnimation.value * 0.05),
                                    ),
                            blurRadius: 10 + (_hoverAnimation.value * 10),
                          ),
                          // Glow effect when pressed
                          if (_isPressed) ...[
                            BoxShadow(
                              color: context.primaryColor.withOpacity(0.3),
                              blurRadius: 2,
                              spreadRadius: 2,
                            ),
                          ],
                          // Top highlight
                          BoxShadow(
                            color:
                                context.isDark
                                    ? Colors.white.withOpacity(0.05)
                                    : Colors.white.withOpacity(0.9),
                            blurRadius: 15,
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          // Base content
                          ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    context.isDark
                                        ? Colors.white.withOpacity(0.03)
                                        : Colors.white.withOpacity(0.2),
                                    context.isDark
                                        ? Colors.white.withOpacity(0.01)
                                        : Colors.white.withOpacity(0.1),
                                  ],
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 20),
                                  // Image container with improved stability
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          context.isDark
                                              ? Colors.white.withOpacity(0.1)
                                              : Colors.white.withOpacity(0.6),
                                          context.isDark
                                              ? Colors.white.withOpacity(0.05)
                                              : Colors.white.withOpacity(0.3),
                                        ],
                                      ),
                                      border: Border.all(
                                        color:
                                            context.isDark
                                                ? context.theme.primaryColor.withOpacity(
                                                  0.2,
                                                )
                                                : context.theme.primaryColor.withOpacity(
                                                  0.4,
                                                ),
                                        width: 1,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              context.isDark
                                                  ? Colors.black.withOpacity(0.3)
                                                  : context.primaryColor.withOpacity(0.1),
                                          blurRadius: 5,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              context.isDark
                                                  ? Colors.white.withOpacity(0.05)
                                                  : Colors.white.withOpacity(0.3),
                                              context.isDark
                                                  ? Colors.white.withOpacity(0.02)
                                                  : Colors.white.withOpacity(0.1),
                                            ],
                                          ),
                                        ),
                                        padding: const EdgeInsets.all(12),
                                        child: CachedNetworkImage(
                                          imageUrl: widget.category.image,
                                          fit: BoxFit.contain,
                                          errorWidget:
                                              (context, url, error) => Container(
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Colors.red.withOpacity(0.2),
                                                      Colors.red.withOpacity(0.1),
                                                    ],
                                                  ),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  Icons.error_outline_rounded,
                                                  color: Colors.red,
                                                  size: 28,
                                                ),
                                              ),
                                          fadeInDuration: const Duration(
                                            milliseconds: 300,
                                          ),
                                          fadeOutDuration: const Duration(
                                            milliseconds: 300,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  // Category name with stable positioning
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    margin: const EdgeInsets.symmetric(horizontal: 12),
                                    constraints: const BoxConstraints(
                                      minHeight: 36,
                                      maxWidth: 136,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          context.isDark
                                              ? Colors.white.withOpacity(0.08)
                                              : Colors.white.withOpacity(0.5),
                                          context.isDark
                                              ? Colors.white.withOpacity(0.03)
                                              : Colors.white.withOpacity(0.2),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color:
                                            context.isDark
                                                ? Colors.white.withOpacity(0.15)
                                                : Colors.white.withOpacity(0.6),
                                        width: 1,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Center(
                                        child: Text(
                                          widget.category.name,
                                          style: context.textTheme.titleMedium?.copyWith(
                                            color: context.primaryTextColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),

                          // Shimmer overlay effect
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Transform.translate(
                                offset: Offset(
                                  _shimmerAnimation.value * 200,
                                  0,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Colors.transparent,
                                        context.isDark
                                            ? Colors.white.withOpacity(0.05)
                                            : Colors.white.withOpacity(0.3),
                                        Colors.transparent,
                                      ],
                                      stops: const [0.0, 0.5, 1.0],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
