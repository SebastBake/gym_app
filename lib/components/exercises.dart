import 'package:flutter/material.dart';
import 'package:gym_app/components/fab.dart';
import 'package:gym_app/components/page_template.dart';
import 'package:gym_app/services/exercises.dart';

import 'new_exercies_form.dart';

class ExercisesScreen extends StatelessWidget {
  final ExerciseStateLoaded state;

  const ExercisesScreen({@required this.state});

  @override
  build(context) => ScreenTemplate(
        title: "Exercises",
        body: ListView(
          children: state.data
              .map((exerciseItem) => ListTile(
                    title: Text(exerciseItem.name),
                    onTap: () => _showEditForm(context, exerciseItem),
                  ))
              .toList(),
        ),
        fabs: [
          FAB(
            icon: Icons.add,
            onPressed: () => _showAddForm(context),
          ),
        ],
      );

  _showAddForm(BuildContext context) => showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (context) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: ExerciseForm(
            onCreate: (data) {
              state.createExercise(data);
              Navigator.of(context).pop();
            },
          ),
        ),
      );

  _showEditForm(BuildContext context, ExerciseData exerciseItem) =>
      showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (context) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: ExerciseForm(
            initialData: exerciseItem,
            onDelete: () {
              state.deleteExercise(exerciseItem.id);
              Navigator.of(context).pop();
            },
            onUpdate: (data) {
              state.updateExercise(data);
              Navigator.of(context).pop();
            },
          ),
        ),
      );
}
