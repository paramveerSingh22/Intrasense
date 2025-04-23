import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViewRatingsBar extends StatelessWidget {
  final double rating; // read-only rating

  ViewRatingsBar({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        int starIndex = index + 1;
        return Icon(
          starIndex <= rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 20.0,
        );
      }),
    );
  }
}