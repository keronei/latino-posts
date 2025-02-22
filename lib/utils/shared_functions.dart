import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
      behavior: SnackBarBehavior.floating, // Optional: Makes it float
    ),
  );
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