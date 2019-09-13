import 'package:flutter/material.dart';
import 'package:gym_app/components/forms.dart';
import 'package:gym_app/services/exercises.dart';

class ExerciseForm extends StatefulWidget {
  @override
  _ExerciseFormState createState() => _ExerciseFormState();
}

class _ExerciseFormState extends State<ExerciseForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameFieldController = TextEditingController();

  bool _measureSetsReps = false;
  bool _measureWeight = false;

  @override
  void dispose() {
    _nameFieldController.dispose();
    super.dispose();
  }

  @override
  build(context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 10),
                  child: Text(
                    'Exercise Name:',
                    style: Theme.of(context).textTheme.headline,
                  )),
              NamedTextField(
                  controller: this._nameFieldController,
                  placeholder: 'Exercise Name',
                  validator: this._validateExerciseName),
              Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 10),
                  child: Text(
                    'Measuring:',
                    style: Theme.of(context).textTheme.headline,
                  )),
              NamedCheckboxField(
                  title: 'Reps / Sets',
                  value: _measureSetsReps,
                  icon: Icons.threesixty,
                  onChanged: (value) => this.setState(() {
                        _measureSetsReps = value;
                      })),
              NamedCheckboxField(
                  title: 'Weight',
                  value: _measureWeight,
                  icon: Icons.fitness_center,
                  onChanged: (value) => this.setState(() {
                        _measureWeight = value;
                      })),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Padding(
                  //   padding: EdgeInsets.all(10),
                  //   child: RaisedButton(
                  //     color: Theme.of(context).errorColor,
                  //     child: Text('Delete'),
                  //     onPressed: form.onDelete,
                  //   ),
                  // ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: RaisedButton(
                      child: Text('Create Exercise'),
                      onPressed: () {
                        final isValid = _formKey.currentState.validate();
                        if (isValid) {
                          final name = _nameFieldController.text;
                          List<ExerciseMeasurable> measureables = [];

                          if (_measureSetsReps) {
                            measureables.add(ExerciseMeasurable.repsAndSets);
                          }

                          if (_measureWeight) {
                            measureables.add(ExerciseMeasurable.weight);
                          }

                          final data = ExerciseData(
                            name: name,
                            measurables: measureables,
                          );

                          Navigator.of(context).pop(data);
                        }
                      },
                    ),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.all(10),
                  //   child: RaisedButton(
                  //     child: Text('Update'),
                  //     onPressed: form.onUpdate,
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      );

  String _validateExerciseName(String value) {
    if (value.isEmpty) {
      return 'Exercise name is required.';
    }
    return null;
  }
}
