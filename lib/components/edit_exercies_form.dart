import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:gym_app/components/forms.dart';
import 'package:gym_app/services/measurables.dart';

@immutable
class ExerciseFormData {
  final String name;
  final List<Measurable> measurables;

  const ExerciseFormData({
    @required this.name,
    @required this.measurables,
  });
}

class ExerciseForm extends StatefulWidget {
  final Function(ExerciseFormData) onCreate;
  final Function(ExerciseFormData) onUpdate;
  final Function onDelete;
  final ExerciseFormData initialData;

  const ExerciseForm({
    this.initialData,
    this.onDelete,
    this.onUpdate,
    this.onCreate,
  });

  @override
  _ExerciseFormState createState() => _ExerciseFormState(
        initialData: initialData,
        onDelete: onDelete,
        onUpdate: onUpdate,
        onCreate: onCreate,
      );
}

class _ExerciseFormState extends State<ExerciseForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameFieldController = TextEditingController();
  final List<Measurable> _measurables = List();

  final String userId;
  final Function(ExerciseFormData) onCreate;
  final Function(ExerciseFormData) onUpdate;
  final Function onDelete;
  final ExerciseFormData initialData;

  _ExerciseFormState({
    this.userId,
    this.initialData,
    this.onDelete,
    this.onUpdate,
    this.onCreate,
  });

  @override
  void dispose() {
    _nameFieldController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (initialData != null) {
      _nameFieldController.text = initialData.name;
      _measurables.addAll(initialData.measurables);
    } else {
      _nameFieldController.text = '';
    }

    super.initState();
  }

  @override
  build(context) => Form(
        key: _formKey,
        child: _ExerciseFormTemplate(
          nameFieldController: _nameFieldController,
          onCreate: onCreate != null ? _onPressCreate : null,
          onDelete: onDelete != null ? _onPressDelete : null,
          onUpdate: onUpdate != null ? _onPressUpdate : null,
          addMeasurable: (m) => setState(() {
            _measurables.add(m);
          }),
          removeMeasurable: (m) => setState(() {
            _measurables.remove(m);
          }),
          hasMeasurable: (m) => _measurables.contains(m),
        ),
      );

  void _onPressDelete() {
    onDelete();
  }

  void _onPressUpdate() {
    final data = _createFormData();
    if (data == null) {
      return;
    }
    onUpdate(data);
  }

  void _onPressCreate() {
    final data = _createFormData();
    if (data == null) {
      return;
    }
    onCreate(data);
  }

  /// Returns null if form invalid
  ExerciseFormData _createFormData() {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return null;
    }

    final name = _nameFieldController.text;
    final data = ExerciseFormData(
      measurables: _measurables,
      name: name,
    );
    return data;
  }
}

/// Stateless widget which renders the form
class _ExerciseFormTemplate extends StatelessWidget {
  final TextEditingController nameFieldController;
  final Function onCreate;
  final Function onUpdate;
  final Function onDelete;
  final Function(Measurable) removeMeasurable;
  final Function(Measurable) addMeasurable;
  final Function(Measurable) hasMeasurable;

  _ExerciseFormTemplate({
    @required this.nameFieldController,
    @required this.addMeasurable,
    @required this.removeMeasurable,
    @required this.hasMeasurable,
    this.onDelete,
    this.onUpdate,
    this.onCreate,
  });

  @override
  build(context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const FormSectionTitle('Exercise Name:'),
            NamedTextField(
              placeholder: 'Exercise Name',
              controller: nameFieldController,
              validator: _validateExerciseName,
            ),
            const FormSectionTitle('Measuring:'),
            ...Measurable.all.map((measurable) => _buildCheckbox(measurable)),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              // Delete BUtton
              if (onDelete != null)
                FormButton(
                    text: "Delete",
                    onSubmit: onDelete,
                    color: Theme.of(context).errorColor),

              // Add update button
              if (onUpdate != null)
                FormButton(text: "Update", onSubmit: onUpdate),

              // Create button
              if (onCreate != null)
                FormButton(text: "Create", onSubmit: onCreate)
            ]),
          ],
        ),
      );

  /// Creates a checkbox to add or remove a measurable
  _buildCheckbox(Measurable measurable) => NamedCheckboxField(
        title: measurable.name,
        icon: measurable.icon,
        value: hasMeasurable(measurable),
        onChanged: (value) {
          if (value) {
            addMeasurable(measurable);
          } else {
            removeMeasurable(measurable);
          }
        },
      );

  /// Validates Exercise Name
  String _validateExerciseName(String value) {
    if (value.isEmpty) {
      return 'Exercise name is required.';
    }
    return null;
  }
}
