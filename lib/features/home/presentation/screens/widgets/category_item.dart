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
  late AnimationController _entranceController;
  late AnimationController _shimmerController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _entranceAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _shimmerAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
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

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.94).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutBack,
        reverseCurve: Curves.easeOutBack,
      ),
    );

    _entranceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.elasticOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.easeOutCubic),
    );

    _shimmerAnimation = Tween<double>(
      begin: -2.0,
      end: 2.0,
    ).animate(_shimmerController);

    _entranceController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
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
                          colors: context.isDark
                              ? [
                                  Colors.white.withOpacity(0.12),
                                  Colors.white.withOpacity(0.06),
                                  Colors.white.withOpacity(0.03),
                                ]
                              : [
                                  Colors.white.withOpacity(0.95),
                                  Colors.white.withOpacity(0.75),
                                  Colors.white.withOpacity(0.55),
                                ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                        border: Border.all(
                          color: _isPressed
                              ? context.primaryColor.withOpacity(0.7)
                              : context.isDark
                                  ? Colors.white.withOpacity(0.25)
                                  : Colors.white.withOpacity(0.8),
                          width: _isPressed ? 2.0 : 1.5,
                        ),
                        boxShadow: [
                          // Main shadow
                          BoxShadow(
                            color: context.isDark
                                ? Colors.black.withOpacity(0.5)
                                : context.primaryColor.withOpacity(0.12),
                            blurRadius: _isPressed ? 8 : 16,
                            offset: Offset(0, _isPressed ? 2 : 8),
                            spreadRadius: _isPressed ? 0 : 2,
                          ),
                          // Glow effect when pressed
                          if (_isPressed)
                            BoxShadow(
                              color: context.primaryColor.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          // Top highlight
                          BoxShadow(
                            color: context.isDark
                                ? Colors.white.withOpacity(0.03)
                                : Colors.white.withOpacity(0.95),
                            blurRadius: 20,
                            offset: const Offset(0, -4),
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
                                  colors: context.isDark
                                      ? [
                                          Colors.white.withOpacity(0.04),
                                          Colors.white.withOpacity(0.02),
                                        ]
                                      : [
                                          Colors.white.withOpacity(0.4),
                                          Colors.white.withOpacity(0.15),
                                        ],
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 24),

                                  // Image container with elevation effect
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeInOutBack,
                                    transform: Matrix4.translationValues(
                                      0,
                                      _isPressed ? 2 : 0,
                                      0,
                                    ),
                                    child: Container(
                                      width: 110,
                                      height: 110,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: RadialGradient(
                                          colors: context.isDark
                                              ? [
                                                  context.primaryColor
                                                      .withOpacity(0.15),
                                                  context.primaryColor
                                                      .withOpacity(0.05),
                                                  Colors.transparent,
                                                ]
                                              : [
                                                  Colors.white.withOpacity(0.9),
                                                  context.primaryColor
                                                      .withOpacity(0.1),
                                                  Colors.transparent,
                                                ],
                                          stops: const [0.0, 0.7, 1.0],
                                        ),
                                        border: Border.all(
                                          color: context.isDark
                                              ? context.primaryColor
                                                  .withOpacity(0.3)
                                              : context.primaryColor
                                                  .withOpacity(0.2),
                                          width: 1.5,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: context.isDark
                                                ? Colors.black.withOpacity(0.4)
                                                : context.primaryColor
                                                    .withOpacity(0.15),
                                            blurRadius: _isPressed ? 8 : 12,
                                            offset: Offset(
                                              0,
                                              _isPressed ? 4 : 8,
                                            ),
                                          ),
                                          if (!context.isDark)
                                            BoxShadow(
                                              color: Colors.white
                                                  .withOpacity(0.6),
                                              blurRadius: 8,
                                              offset: const Offset(0, -2),
                                            ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(55),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: context.isDark
                                                  ? [
                                                      Colors.white
                                                          .withOpacity(0.12),
                                                      Colors.white
                                                          .withOpacity(0.06),
                                                    ]
                                                  : [
                                                      Colors.white
                                                          .withOpacity(0.8),
                                                      Colors.white
                                                          .withOpacity(0.4),
                                                    ],
                                            ),
                                          ),
                                          padding: const EdgeInsets.all(12),
                                          child: CachedNetworkImage(
                                            imageUrl: widget.category.image,
                                            fit: BoxFit.contain,
                                            errorWidget: (
                                              context,
                                              url,
                                              error,
                                            ) =>
                                                Container(
                                              decoration: BoxDecoration(
                                                gradient: RadialGradient(
                                                  colors: [
                                                    Colors.red
                                                        .withOpacity(0.3),
                                                    Colors.red
                                                        .withOpacity(0.1),
                                                  ],
                                                ),
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.error_outline_rounded,
                                                color: Colors.red,
                                                size: 32,
                                              ),
                                            ),
                                            fadeInDuration: const Duration(
                                              milliseconds: 400,
                                            ),
                                            fadeOutDuration: const Duration(
                                              milliseconds: 200,
                                            ),
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
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    constraints: const BoxConstraints(
                                      minHeight: 36,
                                      maxWidth: 136,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: context.isDark
                                            ? [
                                                Colors.white.withOpacity(0.1),
                                                Colors.white.withOpacity(0.05),
                                              ]
                                            : [
                                                Colors.white.withOpacity(0.9),
                                                Colors.white.withOpacity(0.6),
                                              ],
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: context.isDark
                                            ? Colors.white.withOpacity(0.2)
                                            : Colors.white.withOpacity(0.9),
                                        width: 1.5,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: context.isDark
                                              ? Colors.black.withOpacity(0.3)
                                              : context.primaryColor
                                                  .withOpacity(0.08),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        widget.category.name,
                                        style: context.textTheme.titleMedium
                                            ?.copyWith(
                                          color: context.primaryTextColor,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                          letterSpacing: 0.3,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
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