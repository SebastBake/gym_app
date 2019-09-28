import 'package:flutter/material.dart';
import 'package:gym_app/components/fab.dart';
import 'package:gym_app/components/page_template.dart';
import 'package:gym_app/services/auth.dart';
import 'package:gym_app/services/exercises.dart';

import 'new_exercies_form.dart';

class ExercisesScreen extends StatelessWidget {
  final ExerciseStateLoaded state;

  const ExercisesScreen({@required this.state});

  @override
  build(context) => ScreenTemplate(
        title: "Exercises",
        body: state.data.length == 0
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
            onPressed: () => _showAddForm(context),
          ),
        ],
      );

  Widget _renderListItem(BuildContext context, ExerciseData exerciseItem) =>
      ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(exerciseItem.name),
            Row(
              children: ExerciseMeasurable.all
                  .map(
                    (m) => exerciseItem.measurables.contains(m)
                        ? Icon(m.icon)
                        : Padding(
                            padding: EdgeInsets.symmetric(horizontal: 13)),
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

  void _showAddForm(BuildContext context) => showModalBottomSheet(
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

  void _showEditForm(BuildContext context, ExerciseData exerciseItem) =>
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

  List<ExerciseData> _getSortedExerciseItems() {
    final items = [...state.data];
    items.sort((a, b) => a.name.compareTo(b.name));
    return items;
  }
}
