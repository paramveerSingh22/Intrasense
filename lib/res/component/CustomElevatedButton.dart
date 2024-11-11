import 'package:flutter/material.dart';

import '../../utils/Images.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final bool loading;

  const CustomElevatedButton({
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
              image: AssetImage(Images.buttonBg),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Container(
            constraints: const BoxConstraints(minHeight: 40.0),
            alignment: Alignment.center,
            child: Center(
                child: loading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Text(
                        buttonText,
                        style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontFamily: 'PoppinsMedium'),
                      )),
          )),
    );
  }
}
