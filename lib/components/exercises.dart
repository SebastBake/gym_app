import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gym_app/components/fab.dart';
import 'package:gym_app/components/page_template.dart';
import 'package:gym_app/services/exercises.dart';

import 'new_exercies_form.dart';

class ExercisesScreen extends StatelessWidget {
  const ExercisesScreen({Key key}) : super(key: key);

  @override
  build(context) => ScreenTemplate(
        title: "Exercises",
        body: ExerciseList(),
        fabs: <Widget>[
          FAB(
            icon: Icons.add,
            onPressed: () {
              showModalBottomSheet<ExerciseData>(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                context: context,
                builder: (context) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: ExerciseForm(
                    onCreate: (data) {
                      final json = data.toJson();
                      Firestore.instance.collection('exercises').add(json);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              );
            },
          )
        ],
      );
}

class ExerciseList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('exercises').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Text('Loading...');
          default:
            return ListView(
              children: snapshot.data.documents.map(
                (DocumentSnapshot document) {
                  print(document.toString());
                  return ListTile(
                    title: Text(document['name'].toString()),
                    onTap: () {
                      showModalBottomSheet<ExerciseData>(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        context: context,
                        builder: (context) => Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: ExerciseForm(
                            initialData: ExerciseData.fromJson(document.data),
                            onCreate: (data) {
                              final json = data.toJson();
                              Firestore.instance
                                  .collection('exercises')
                                  .add(json);
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ).toList(),
            );
        }
      },
    );
  }
}
