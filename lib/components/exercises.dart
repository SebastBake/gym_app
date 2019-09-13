import 'package:flutter/material.dart';
import 'package:gym_app/components/page_template.dart';

import 'new_exercies_form.dart';

class ExercisesScreen extends StatelessWidget {
  const ExercisesScreen({Key key}) : super(key: key);

  @override
  build(context) => ScreenTemplate(
        title: "Exercises",
        body: NewExerciseForm(),
      );
}
