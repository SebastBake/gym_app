import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gym_app/services/measurables.dart';
import 'package:provider/provider.dart';

abstract class Exercise {
  /// Can be null if data is not saved
  String get id;
  String get creatorId;

  String name;
  List<Measurable> measurables;

  Future<void> delete();
  Future<void> save();
}

//................................................... Constants

final _exerciseCollection = Firestore.instance.collection('exercises');

//.................................................. Factory Bloc Implementation

@immutable
class ExerciseFactoryBloc extends StatelessWidget {
  final Widget child;
  final String userId;

  const ExerciseFactoryBloc({
    Key key,
    @required this.child,
    @required this.userId,
  }) : super(key: key);

  static ExerciseFactoryBloc of(BuildContext context) {
    return Provider.of<ExerciseFactoryBloc>(context);
  }

  @override
  Widget build(BuildContext context) => Provider<ExerciseFactoryBloc>.value(
        value: this,
        child: this.child,
      );

  Exercise makeExercise({
    @required String name,
    List<Measurable> measurables = const [],
  }) =>
      _Exercise(
        creatorId: this.userId,
        measurables: measurables,
        name: name,
      );
}

//.................................................... Query Bloc Implementation

@immutable
class ExerciseQueryBloc extends StatefulWidget {
  final Widget Function(BuildContext) loading;
  final Widget Function(BuildContext, List<Exercise>) ready;
  final String userId;

  ExerciseQueryBloc({
    Key key,
    @required this.userId,
    @required this.loading,
    @required this.ready,
  }) : super(key: key);

  _ExerciseQueryBlocState createState() => _ExerciseQueryBlocState(
        userId: userId,
        loading: loading,
        ready: ready,
      );
}

class _ExerciseQueryBlocState extends State<ExerciseQueryBloc> {
  final Widget Function(BuildContext) loading;
  final Widget Function(BuildContext, List<Exercise>) ready;
  final String userId;

  Stream<List<Exercise>> _stream;

  _ExerciseQueryBlocState({
    @required this.userId,
    @required this.loading,
    @required this.ready,
  });

  @override
  void initState() {
    this._stream = _exerciseCollection
        .where('creatorId', isEqualTo: this.userId)
        .snapshots()
        .map((snap) => snap.documents
            .map<Exercise>((doc) {
              try {
                return _Exercise.fromDocument(doc);
              } catch (e) {
                print(e);
                return null;
              }
            })
            .where((o) => o != null)
            .toList());

    super.initState();
  }

  @override
  build(context) => StreamBuilder<List<Exercise>>(
      stream: this._stream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ready(context, snapshot.data)
            : loading(context);
      });
}

//...................................................... Exercise implementation

class _Exercise extends Exercise {
  String id;
  String name;
  String creatorId;
  List<Measurable> measurables;

  _Exercise({
    this.id,
    @required this.creatorId,
    @required this.name,
    @required this.measurables,
  });

  _Exercise.fromDocument(DocumentSnapshot doc)
      : this(
          id: doc.documentID,
          name: doc.data['name'],
          creatorId: doc.data['creatorId'],
          measurables: Measurable.getByKeys(doc.data['measurables']),
        );

  @override
  Future<void> delete() async {
    if (this.id != null) {
      _exerciseCollection.document(this.id).delete();
      this.id = null;
    }
  }

  @override
  Future<void> save() async {
    if (this.id == null) {
      final doc = await _exerciseCollection.add(this._json);
      this.id = doc.documentID;
    } else {
      _exerciseCollection.document(this.id).updateData(this._json);
    }
  }

  Map<String, dynamic> get _json => ({
        'name': this.name,
        'creatorId': this.creatorId,
        'measurables': this.measurables.toList().map((m) => m.jsonKey).toList(),
      });
}
