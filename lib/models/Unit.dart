import 'package:flutter/material.dart';

class Unit {
  String unit;
  String abbr;

  Unit({
    @required this.unit,
    @required this.abbr,
  });
}

List<Unit> unitsList = [
  Unit(unit: "Unit", abbr: "null"),
  Unit(unit: "Kilogram", abbr: "Kg"),
  Unit(unit: "Gram", abbr: "g"),
  Unit(unit: "Litre", abbr: "L"),
  Unit(unit: "Milli Litre", abbr: "ml"),
  Unit(unit: "Piece", abbr: "pc"),
];
