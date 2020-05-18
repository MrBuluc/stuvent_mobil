import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Category {
  final int categoryId;
  final String name;
  final IconData icon;

  Category({this.categoryId, this.name, this.icon});
}

final allCategory = Category(
  categoryId: 0,
  name: "Hepsi",
  icon: Icons.search,
);

final CSCategory = Category(
  categoryId: 1,
  name: "Computer Society",
  icon: Icons.computer,
);

final EACategory = Category(
  categoryId: 2,
  name: "Educational Activities",
  icon: Icons.school,
);

final PESCategory = Category(
  categoryId: 3,
  name: "Power and Energy",
  icon: Icons.battery_charging_full,
);

final RASCategory = Category(
  categoryId: 4,
  name: "Robotics & Automation",
  icon: Icons.android,
);

final WIECategory = Category(
  categoryId: 5,
  name: "Women in Engineering",
  icon: Icons.local_florist,
);

final categories = [
  allCategory,
  CSCategory,
  EACategory,
  PESCategory,
  RASCategory,
  WIECategory,
];