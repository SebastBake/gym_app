import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gym_app/components/fab.dart';
import 'package:gym_app/components/page_template.dart';
import 'package:gym_app/routes.dart';
import 'package:gym_app/services/auth.dart';

import 'menu_modal.dart';

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
              // SessionList()
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
