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
  IconData get icon;

  static final weight = _ExerciseMeasurable(
    icon: Icons.fitness_center,
    name: 'Weight',
    jsonKey: 'weight',
  );

  static final repsAndSets = _ExerciseMeasurable(
    icon: Icons.threesixty,
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
  final String userId;

  ExerciseBloc({
    Key key,
    @required this.userId,
    @required this.loading,
    @required this.ready,
  }) : super(key: key);

  _ExerciseBlocState createState() => _ExerciseBlocState(
        userId: userId,
        loading: loading,
        ready: ready,
      );
}

class _ExerciseBlocState extends State<ExerciseBloc> {
  final Widget Function(BuildContext) loading;
  final Widget Function(BuildContext, ExerciseStateLoaded) ready;
  final String userId;

  Stream<_ExerciseStateLoaded> stream;

  _ExerciseBlocState({
    @required this.userId,
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

  Stream<_ExerciseStateLoaded> _makeExerciseStream() {
    final snapshots = Firestore.instance
        .collection('exercises')
        .where('creatorId', isEqualTo: userId)
        .snapshots();

    final dataStream = snapshots.map(
        (snap) => _ExerciseStateLoaded.fromDocuments(userId, snap.documents));

    return dataStream;
  }
}

/////////////////////////////////////////////////////////////////////////////////

@immutable
class _ExerciseStateLoaded extends ExerciseStateLoaded {
  final List<ExerciseData> data;
  final String userId;

  _ExerciseStateLoaded({@required this.data, @required this.userId});

  factory _ExerciseStateLoaded.fromDocuments(
    String userId,
    List<DocumentSnapshot> docs,
  ) {
    final exerciseList = docs
        .map((doc) => ExerciseData(
            id: doc.documentID,
            name: doc.data['name'],
            measurables: ExerciseMeasurable.all
                .where((item) => doc.data['measurables'].contains(item.jsonKey))
                .toSet()))
        .toList();

    return _ExerciseStateLoaded(data: exerciseList, userId: userId);
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

  Map<String, dynamic> exerciseDataToJson(ExerciseData data) => ({
        'name': data.name,
        'creatorId': userId,
        'measurables': data.measurables.toList().map((m) => m.jsonKey).toList(),
      });
}

@immutable
class _ExerciseMeasurable extends ExerciseMeasurable {
  final String name;
  final String jsonKey;
  final IconData icon;

  _ExerciseMeasurable({
    @required this.icon,
    @required this.name,
    @required this.jsonKey,
  });
}
