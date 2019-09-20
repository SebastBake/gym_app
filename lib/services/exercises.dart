import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gym_app/components/blank.dart';

@immutable
abstract class ExerciseStateLoaded {
  List<ExerciseData> get data;

  const ExerciseStateLoaded();

  void createExercise(ExerciseData data);
  void updateExercise(ExerciseData data);
  void deleteExercise(String exerciseId);
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
}

@immutable
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

////////////////////////////////////////////////////////////////////////////////////////

class ExerciseBloc extends StatefulWidget {
  final Widget Function(BuildContext) loading;
  final Widget Function(BuildContext, ExerciseStateLoaded) ready;

  ExerciseBloc({
    Key key,
    @required this.loading,
    @required this.ready,
  }) : super(key: key);

  _ExerciseBlocState createState() => _ExerciseBlocState(
        loading: loading,
        ready: ready,
      );
}

class _ExerciseBlocState extends State<ExerciseBloc> {
  final Widget Function(BuildContext) loading;
  final Widget Function(BuildContext, ExerciseStateLoaded) ready;

  Stream<_ExerciseStateLoaded> stream;

  _ExerciseBlocState({
    @required this.loading,
    @required this.ready,
  });

  @override
  void initState() {
    stream = _makeExerciseStream();
    super.initState();
  }

  @override
  build(context) => StreamBuilder(
        stream: stream,
        builder: (BuildContext context,
                AsyncSnapshot<_ExerciseStateLoaded> snapshot) =>
            snapshot.hasData ? ready(context, snapshot.data) : BlankScreen(),
      );
}

/////////////////////////////////////////////////////////////////////////////////

Stream<_ExerciseStateLoaded> _makeExerciseStream() {
  final snapshots = Firestore.instance.collection('exercises').snapshots();

  final dataStream = snapshots
      .map((snap) => _ExerciseStateLoaded.fromDocuments(snap.documents));

  return dataStream;
}

@immutable
class _ExerciseStateLoaded extends ExerciseStateLoaded {
  final List<ExerciseData> data;

  _ExerciseStateLoaded({@required this.data});

  factory _ExerciseStateLoaded.fromDocuments(List<DocumentSnapshot> docs) {
    final exerciseList =
        docs.map((doc) => exerciseDataFromDocument(doc)).toList();

    return _ExerciseStateLoaded(data: exerciseList);
  }

  @override
  void createExercise(ExerciseData data) {
    final json = exerciseDataToJson(data);
    Firestore.instance.collection('exercises').add(json);
  }

  @override
  void deleteExercise(String exerciseId) {
    Firestore.instance.collection('exercises').document(exerciseId).delete();
  }

  @override
  void updateExercise(ExerciseData data) {
    final json = exerciseDataToJson(data);
    Firestore.instance
        .collection('exercises')
        .document(data.id)
        .updateData(json);
  }

  static ExerciseData exerciseDataFromDocument(DocumentSnapshot document) {
    final data = ExerciseData(
        id: document.documentID,
        name: document.data['name'],
        measurables: ExerciseMeasurable.all
            .where(
                (item) => document.data['measurables'].contains(item.jsonKey))
            .toSet());

    return data;
  }

  static Map<String, dynamic> exerciseDataToJson(ExerciseData data) => ({
        'name': data.name,
        'measurables': data.measurables.toList().map((m) => m.jsonKey).toList(),
      });
}

@immutable
class _ExerciseMeasurable extends ExerciseMeasurable {
  final String name;
  final String jsonKey;

  _ExerciseMeasurable({
    @required this.name,
    @required this.jsonKey,
  });
}
