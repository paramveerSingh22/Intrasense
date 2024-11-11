import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'dart:convert';

class Utils {
  static toastMessage(String message) {
    Fluttertoast.showToast(msg: message);
  }

  static void flushBarErrorMessage(String message, BuildContext context) {
    showFlushbar(
        context: context,
        flushbar: Flushbar(
          message: message,
          duration: Duration(seconds: 3),
        )..show(context));
  }

  static snackbar(String message, BuildContext context) {
    return ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  static void fieldFocus(
      BuildContext context, FocusNode current, FocusNode nextFocus) {
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static void showConfirmationDialog(
      BuildContext context, {
        required String message,
        required VoidCallback onConfirm,
      }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmation"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                onConfirm(); // Call the passed callback
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  static void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false, // Prevent closing by back button
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }

  static void hideLoadingDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop(); // Close the dialog
  }

  String extractErrorMessage(String error) {
    int jsonStartIndex = error.indexOf('{');
    if (jsonStartIndex != -1) {
      try {
        String jsonPart = error.substring(jsonStartIndex);
        var errorResponse = json.decode(jsonPart);
        return errorResponse['message'] ?? 'An unexpected error occurred';
      } catch (e) {
        return 'An error occurred while processing the error response';
      }
    }
    return 'An unknown error occurred';
  }


static void errorMessage(Object? error){
  try {
    String errorString = error.toString();
    int jsonStartIndex = errorString.indexOf("{");
    if (jsonStartIndex != -1) {
      String jsonPart = errorString.substring(jsonStartIndex);
      Map<String, dynamic> errorResponse = jsonDecode(jsonPart);
      Utils.toastMessage(errorResponse['message']);
    } else {
      Utils.toastMessage(errorString);
    }
  } catch (e) {
    Utils.toastMessage(e.toString());
  }
}
}
