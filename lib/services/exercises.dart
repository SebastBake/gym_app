import 'package:flutter/material.dart';

abstract class ExerciseMeasurable {
  String get name;
  String get jsonKey;

  static final weight = _ExerciseMeasurable(
    name: 'Weight',
    jsonKey: 'weight',
  );

  static final repsAndSets = _ExerciseMeasurable(
    name: 'Reps / Sets',
    jsonKey: 'setsAndReps',
  );

  static final all = [
    weight,
    repsAndSets,
  ];
}

@immutable
class ExerciseData {
  final String id;
  final String name;
  final Set<ExerciseMeasurable> measurables;

  const ExerciseData({
    this.id,
    @required this.name,
    @required this.measurables,
  });

  factory ExerciseData.fromJson(Map<String, dynamic> json) {
    final data = ExerciseData(
        name: json['name'],
        measurables: ExerciseMeasurable.all
            .where((item) => json['measurables'].contains(item.jsonKey))
            .toSet());

    return data;
  }

  factory ExerciseData.empty() => ExerciseData(name: '', measurables: Set());

  Map<String, dynamic> toJson() => ({
        'name': this.name,
        'measurables': measurables.toList().map((m) => m.jsonKey).toList(),
      });
}

@immutable
class _ExerciseMeasurable extends ExerciseMeasurable {
  final String name;
  final String jsonKey;

  _ExerciseMeasurable({@required this.name, @required this.jsonKey});
}
