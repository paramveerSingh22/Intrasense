import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomRatingBar extends StatefulWidget {
  final double initialRating;
  final ValueChanged<double> onRatingUpdate;

  CustomRatingBar({required this.initialRating, required this.onRatingUpdate});

  @override
  _CustomRatingBarState createState() => _CustomRatingBarState();
}

class _CustomRatingBarState extends State<CustomRatingBar> {
  late double _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        int starIndex = index + 1;
        return GestureDetector(
          onTap: () {
            setState(() {
              _currentRating = starIndex.toDouble();
            });
            widget.onRatingUpdate(_currentRating);
          },
          child: Icon(
            starIndex <= _currentRating
                ? Icons.star
                : Icons.star_border,
            color: Colors.amber,
            size: 20.0,
          ),
        );
      }),
    );
  }
}