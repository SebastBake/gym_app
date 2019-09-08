import 'package:flutter/material.dart';
import 'package:gym_app/components/fab.dart';
import 'package:gym_app/components/menu_modal.dart';
import 'package:gym_app/components/page_template.dart';
import 'package:gym_app/routes.dart';
import 'package:gym_app/services/auth.dart';
import 'package:gym_app/utils/navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SessionsScreen extends StatelessWidget {
  final AuthSignedIn authState;
  const SessionsScreen({Key key, this.authState}) : super(key: key);

  @override
  build(context) => ScreenTemplate(
        title: "Sessions",
        body: SessionList(),
        onMenuPressed: () => MenuModal.show(context, this.authState),
        fabs: [
          ExtendedFAB(
            tag: "btn1",
            icon: Icons.add,
            label: "New Session",
            onPressed: () => NavUtil.push(context, Routes.session),
          ),
        ],
      );
}

class SessionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('exerciseSessions').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            return new ListView(
              children:
                  snapshot.data.documents.map((DocumentSnapshot document) {
                return new ListTile(
                  title: new Text(document['dateTime'].toString()),
                );
              }).toList(),
            );
        }
      },
    );
  }
}
