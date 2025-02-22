import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

Future<bool?> showConfirmationDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Confirm"),
        content: Text("Delete all saved posts?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("OK"),
          ),
        ],
      );
    },
  );
}

extension StringExtension on String {
  String capitalizeFirstLetter() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  String capitalizeSentences() {
    return split(' ').map((sentence) {
      return sentence.isNotEmpty ? sentence[0].toUpperCase() + sentence.substring(1) : sentence;
    }).join(' ');
  }
}


String getErrorMessage(Exception error) {
  if (error is TimeoutException) {
    return "The request timed out. Please try again.";
  } else if (error is HttpException) {
    return "Server error. Please try again later.";
  } else if (error is FormatException) {
    return "Unexpected response format. Please contact support.";
  } else if (error is SocketException) {
    return "No internet connection. Please check your network.";
  } else {
    return "Something went wrong. Please try again.";
  }
}