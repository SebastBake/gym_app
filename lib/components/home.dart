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
/// * Button to edit exercise plan
/// * Button to see previous sessions
class HomeScreen extends StatelessWidget {
  final AuthSignedIn authState;
  const HomeScreen({Key key, this.authState}) : super(key: key);

  @override
  build(context) => ScreenTemplate(
        title: "Home",
        fabs: <Widget>[
          ExtendedFAB(
            label: "Start New Session",
            icon: Icons.add,
            onPressed: () {},
          ),
        ],
        body: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                children: [
                  RaisedButton(
                    child: Text("Edit Exercise Plan"),
                    onPressed: () {},
                  ),
                  RaisedButton(
                    child: Text("View Previous Exercise Sessions"),
                    onPressed: () => Navigator.of(context).pushNamed(
                        Routes.sessionList,
                        arguments: this.authState),
                  ),
                ],
              ),
            ),
          ],
        ),
        onMenuPressed: () => MenuModal.show(context, this.authState),
      );
}
