import 'package:flutter/material.dart';

/// UI-only model for a home category tile.
/// TODO: replace icon with real asset (Assets.icons.*) once provided.
class CategoryItem {
  const CategoryItem({required this.label, required this.icon});

  final String label;
  final IconData icon;
}
