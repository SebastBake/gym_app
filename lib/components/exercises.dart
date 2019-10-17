import 'package:flutter/material.dart';
import 'package:gym_app/components/edit_exercies_form.dart';
import 'package:gym_app/components/fab.dart';
import 'package:gym_app/components/page_template.dart';
import 'package:gym_app/services/exercises.dart';
import 'package:gym_app/services/measurables.dart';

class ExercisesScreen extends StatelessWidget {
  final List<Exercise> exercises;

  const ExercisesScreen({@required this.exercises});

  @override
  build(context) => ScreenTemplate(
        title: "Exercises",
        body: exercises.length == 0
            ? Center(
                child: Text('Add an exercise :)'),
              )
            : ListView(
                children: ListTile.divideTiles(
                  context: context,
                  tiles: _getSortedExerciseItems()
                      .map((exerciseItem) =>
                          _renderListItem(context, exerciseItem))
                      .toList(),
                ).toList(),
              ),
        fabs: [
          FAB(
            icon: Icons.add,
            onPressed: () => _showAddForm(
              context,
              ExerciseFactoryBloc.of(context),
            ),
          ),
        ],
      );

  Widget _renderListItem(BuildContext context, Exercise exerciseItem) =>
      ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(exerciseItem.name),
            Row(
              children: Measurable.all
                  .map(
                    (m) => exerciseItem.measurables.contains(m)
                        ? Icon(m.icon)
                        : Padding(
                            padding: EdgeInsets.symmetric(horizontal: 13),
                          ),
                  )
                  .map(
                    (widget) => Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: widget,
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
        onTap: () => _showEditForm(context, exerciseItem),
        trailing: Icon(Icons.keyboard_arrow_right),
      );

  void _showAddForm(BuildContext context, ExerciseFactoryBloc factoryBloc) =>
      showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (context) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: ExerciseForm(
            onCreate: (data) {
              final exercise = factoryBloc.makeExercise(
                name: data.name,
                measurables: data.measurables.toList(),
              );

              exercise.save();

              Navigator.of(context).pop();
            },
          ),
        ),
      );

  void _showEditForm(BuildContext context, Exercise exerciseItem) =>
      showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (context) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: ExerciseForm(
            initialData: ExerciseFormData(
              name: exerciseItem.name,
              measurables: exerciseItem.measurables,
            ),
            onDelete: () {
              exerciseItem.delete();
              Navigator.of(context).pop();
            },
            onUpdate: (data) {
              exerciseItem
                ..name = data.name
                ..measurables = data.measurables
                ..save();
              Navigator.of(context).pop();
            },
          ),
        ),
      );

  List<Exercise> _getSortedExerciseItems() {
    final items = [...this.exercises];
    items.sort((a, b) => a.name.compareTo(b.name));
    return items;
  }
}
