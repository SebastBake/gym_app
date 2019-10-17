import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gym_app/services/measurables.dart';

abstract class WorkoutSessionData {
  /// nullable
  String get id;
  String get creatorId;
  UnmodifiableListView<WorkoutExercise> get exercises; // Order matters
  DateTime dateTime;
}

abstract class WorkoutExercise {
  String get exerciseId;
  String get name;
  UnmodifiableListView<Measurement> get measurements;
}

//.................................................... Constants

final _sessionCollection = Firestore.instance.collection('exerciseSessions');

//.................................................... Factory Bloc

// TODO: Write a factory bloc which creates, saves, deletes session data

//.................................................... Stream Bloc

/// Renders widget when SessionQueryBloc is ready
typedef Widget _RenderReadyFn(
  BuildContext ctx,
  UnmodifiableListView<WorkoutSessionData> list,
);

class SessionQueryBloc extends StatefulWidget {
  final Widget Function(BuildContext) loading;
  final _RenderReadyFn ready;
  final String userId;

  SessionQueryBloc({
    Key key,
    @required this.loading,
    @required this.ready,
    @required this.userId,
  }) : super(key: key);

  _SessionQueryBlocState createState() => _SessionQueryBlocState(
        loading: this.loading,
        ready: this.ready,
        userId: this.userId,
      );
}

class _SessionQueryBlocState extends State<SessionQueryBloc> {
  final Widget Function(BuildContext) loading;
  final _RenderReadyFn ready;
  final String userId;

  Stream<List<WorkoutSessionData>> _stream;

  _SessionQueryBlocState({
    @required this.loading,
    @required this.ready,
    @required this.userId,
  });

  void initState() {
    this._stream = _sessionCollection
        .where('creatorId', isEqualTo: this.userId)
        .snapshots()
        .map((snap) => snap.documents
            .map((doc) => _WorkoutSessionData.fromDocument(doc))
            .toList());

    super.initState();
  }

  @override
  Widget build(BuildContext context) => StreamBuilder(
        stream: this._stream,
        builder: (context, snapshot) =>
            snapshot.hasData ? ready(context, snapshot.data) : loading(context),
      );
}

class _WorkoutSessionData extends WorkoutSessionData {
  final String id;
  final String creatorId;
  UnmodifiableListView<WorkoutExercise> exercises; // Order matters
  DateTime dateTime;

  _WorkoutSessionData({
    @required this.id,
    @required this.creatorId,
    @required this.exercises,
    @required this.dateTime,
  });

  _WorkoutSessionData.fromDocument(DocumentSnapshot doc)
      : this(
          id: doc.documentID,
          creatorId: doc.data['creatorId'],
          // exercises: doc.data['exercisesDone'].map((exercise) => ),
          exercises: List<WorkoutExercise>(),
          dateTime: DateTime(1),
        );
}
