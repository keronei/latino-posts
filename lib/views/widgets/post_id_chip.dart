import 'package:flutter/material.dart';

Chip postIdentifierChip(int identifier, BuildContext context) {
  return Chip(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
    label: Text(
      "# $identifier",
      style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
    ),
    backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
  );
}