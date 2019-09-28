import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gym_app/components/fab.dart';
import 'package:gym_app/components/page_template.dart';
import 'package:gym_app/routes.dart';
import 'package:gym_app/services/auth.dart';

import 'menu_modal.dart';

/// Home Screen
/// I don't know exactly how this page will be presented.
/// Here are some things I want to be able to do:
/// * See user info and log out
/// * Button to start a new session
/// * Button to edit exercise plan (inside menu)
/// * Button to see previous sessions
class HomeScreen extends StatelessWidget {
  final AuthSignedIn authState;
  const HomeScreen({Key key, this.authState}) : super(key: key);

  @override
  build(context) => ScreenTemplate(
        fabs: <Widget>[
          ExtendedFAB(
            label: "Start New Session",
            icon: Icons.add,
            onPressed: () {
              Navigator.of(context).pushNamed(Routes.session);
            },
          ),
        ],
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                'Welcome back ${authState.displayName}!',
                style: Theme.of(context).textTheme.display2,
              ),
              SessionList()
            ],
          ),
        ),
        onMenuPressed: () => MenuModal.show(context, this.authState),
      );
}

class SessionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('exerciseSessions').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Text('Loading...');
          default:
            return Expanded(
              child: ListView(
                children:
                    snapshot.data.documents.map((DocumentSnapshot document) {
                  return ListTile(
                    title: Text(document['dateTime'].toString()),
                  );
                }).toList(),
              ),
            );
        }
      },
    );
  }
}
