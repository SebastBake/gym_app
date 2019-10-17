import 'dart:collection';

import 'package:flutter/material.dart';

@immutable
abstract class Measurable {
  String get name;
  String get jsonKey;
  IconData get icon;

  static Measurable weight = _Weight();

  static Measurable repsAndSets = _RepsAndSets();

  static List<Measurable> all = [
    weight,
    repsAndSets,
  ];

  static UnmodifiableListView<Measurable> getByKeys(List<dynamic> keys) {
    List<Measurable> list = keys.map((k) => Measurable.getByKey(k)).toList();
    return UnmodifiableListView(list);
  }

  static Measurable getByKey(String key) {
    for (final measurable in Measurable.all) {
      if (measurable.jsonKey == key) {
        return measurable;
      }
    }
    throw ExerciseMeasurableDoesNotExistException();
  }
}

@immutable
abstract class Measurement {
  Measurable get measures;
}

@immutable
abstract class RepsAndSetsMeasurement extends Measurement {
  int get reps;
  int get sets;
  final Measurable measures = Measurable.repsAndSets;
}

@immutable
abstract class WeightMeasurement extends Measurement {
  num get kgs;
  final Measurable measures = Measurable.weight;
}

//.................................................................. Exceptions

@immutable
class ExerciseMeasurableDoesNotExistException implements Exception {}

//........................................................................

@immutable
class _RepsAndSets extends Measurable {
  final name = 'Reps / Sets';
  final jsonKey = 'setsAndReps';
  final icon = Icons.threesixty;
}

@immutable
class _Weight extends Measurable {
  final name = 'Weight';
  final jsonKey = 'weight';
  final icon = Icons.fitness_center;
}
