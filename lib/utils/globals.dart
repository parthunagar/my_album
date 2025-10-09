import 'package:flutter/material.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBar(
    BuildContext context, String msg) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}
