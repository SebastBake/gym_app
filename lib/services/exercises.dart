import 'package:flutter/material.dart';

enum ExerciseMeasurable { repsAndSets, weight }

@immutable
class ExerciseData {
  final List<ExerciseMeasurable> measurables;
  final String name;

  factory ExerciseData.fromJson(Map<String, dynamic> json) {
    return ExerciseData(name: json['name'], measurables: []);
  }

  const ExerciseData({
    @required this.name,
    @required this.measurables,
  });

  Map<String, dynamic> toJson() => ({
        'name': this.name,
        'measurables': [],
      });
}
