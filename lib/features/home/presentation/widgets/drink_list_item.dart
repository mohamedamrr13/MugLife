import 'package:drinks_app/features/home/data/models/drink_model.dart';
import 'package:flutter/material.dart';

class DrinkListItem extends StatelessWidget {
  const DrinkListItem({super.key, required this.drinkModel});
  final DrinkModel drinkModel;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
          child: Card(
            elevation: 3,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 70, horizontal: 3),
              child: Row(),
            ),
          ),
        ),
        Positioned(
          top: -15,
          left: 10,
          bottom: 45,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                height: 10,
                width: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black45,
                      blurRadius: 20,
                      spreadRadius: 15,
                    ),
                  ],
                ),
              ),
              Image(image: AssetImage(drinkModel.image), fit: BoxFit.cover),
            ],
          ),
        ),
        Positioned(
          left: 115,
          right: 0,
          bottom: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                drinkModel.name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              Text(
                drinkModel.title,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
        Positioned(
          left: 110,
          bottom: 50,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF4A5568).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '£${drinkModel.price}', // Replace with actual price
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
        ),

        Positioned(
          right: 50,
          bottom: 50,
          child: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.black87.withAlpha(180),
                width: 1.5,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Icon(
                Icons.arrow_forward_ios_outlined,
                color: Colors.black87.withAlpha(180),
                size: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
