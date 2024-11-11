import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intrasense/utils/AppColors.dart';

import '../../utils/Images.dart';

class ButtonOrangeBorder extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final bool loading;

  const ButtonOrangeBorder({
    Key? key,
    required this.onPressed,
    required this.buttonText,
    this.loading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      child: Ink(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Images.buttonOrangeBorder),
              fit: BoxFit.cover,
            ),
              border: Border.all(color: AppColors.secondaryOrange, width: 1.0),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Container(
            constraints: const BoxConstraints(minHeight: 40.0),
            alignment: Alignment.center,
            child: Center(
                child: loading
                    ?  CircularProgressIndicator(
                  color: AppColors.secondaryOrange,
                )
                    : Text(
                  buttonText,
                  style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.secondaryOrange,
                      fontFamily: 'PoppinsMedium'),
                )),
          )),
    );
  }
}
