import 'package:flutter/material.dart';
import 'package:gym_app/components/page_template.dart';
import 'package:gym_app/services/auth.dart';

import 'menu_modal.dart';

class HomeScreen extends StatelessWidget {
  final AuthSignedIn authState;
  const HomeScreen({Key key, this.authState}) : super(key: key);

  @override
  build(context) => ScreenTemplate(
        title: "Home",
        body: Container(),
        onMenuPressed: () => MenuModal.show(context, this.authState),
      );
}
