import 'package:drinks_app/features/drinks/presentation/drink_details_screen.dart';
import 'package:drinks_app/features/home/data/models/drink_model.dart';
import 'package:drinks_app/features/drinks/presentation/widgets/drink_list_item.dart';
import 'package:flutter/material.dart';

class DrinkListView extends StatefulWidget {
  const DrinkListView({super.key, required this.controller});
  final ScrollController controller;

  @override
  State<DrinkListView> createState() => _DrinkListViewState();
}

class _DrinkListViewState extends State<DrinkListView> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        controller: widget.controller,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 40),
        itemCount: DrinkModel.drinks.length,
        itemBuilder: (context, index) {
          final drinkModel = DrinkModel.drinks[index];
          final listItem = DrinkListItem(drinkModel: drinkModel);
          return AnimatedBuilder(
            animation: widget.controller,
            builder: (context, child) {
              double offset = 0;
              if (widget.controller.hasClients) {
                offset = widget.controller.offset / 175 - index;
              }
              offset = offset.clamp(0, 3);
              return RepaintBoundary(
                child: Transform.scale(scale: 1 - (offset * 0.2), child: child),
              );
            },
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return DrinksDetailsScreen();
                    },
                  ),
                );
              },
              child: listItem,
            ),
          );
        },
      ),
    );
  }
}
