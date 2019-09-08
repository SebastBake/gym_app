import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_app/components/exercises.dart';

void main() {
  testWidgets('Exercise screen has correct title', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(child: ExercisesScreen()));

    final titleFinder = find.text("Exercises");

    expect(titleFinder, findsOneWidget);
  });
}

Widget createWidgetForTesting({Widget child}) {
  return MaterialApp(home: child);
}
