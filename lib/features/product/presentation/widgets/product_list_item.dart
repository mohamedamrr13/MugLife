import 'package:cached_network_image/cached_network_image.dart';
import 'package:drinks_app/features/product/data/models/product_model.dart';
import 'package:drinks_app/utils/colors/app_colors.dart';
import 'package:flutter/material.dart';

class ProductListItem extends StatelessWidget {
  const ProductListItem({super.key, required this.productModel});
  final ProductModel productModel;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 30),
          child: Card(
            elevation: 3,
            color: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 80, horizontal: 3),
              child: Row(),
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 5,
          bottom: 80,
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
              SizedBox(
                width: 100,
                child: Image(
                  height: 100,
                  image: CachedNetworkImageProvider(productModel.image),
                  fit: BoxFit.cover,
                ),
              ),
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
                productModel.name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              Text(
                productModel.description,
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
              color: AppColors.mainColor.withAlpha(50),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '£${productModel.price}', // Replace with actual price
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
            ),
          ),
        ),

        Positioned(
          right: 20,
          bottom: 50,

          child: Icon(
            Icons.arrow_forward_ios_outlined,
            color: Colors.black87.withAlpha(180),
            size: 14,
          ),
        ),
      ],
    );
  }
}
