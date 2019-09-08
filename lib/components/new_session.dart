import 'package:flutter/material.dart';
import 'package:gym_app/components/fab.dart';
import 'package:gym_app/components/page_template.dart';

class SessionScreen extends StatelessWidget {
  const SessionScreen();

  @override
  build(BuildContext context) => ScreenTemplate(
        title: "New session",
        fabs: [
          ExtendedFAB(
            icon: Icons.add,
            label: "Add Exercise",
          ),
        ],
      );
}
