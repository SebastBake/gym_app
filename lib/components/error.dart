import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ErrorScreen extends StatelessWidget {
  final String debugMessage;

  ErrorScreen({this.debugMessage = ''});

  @override
  build(context) {
    var theme = Theme.of(context);

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'Oops, an error occurred.',
            style: theme.textTheme.display1,
          ),
          Text(
            this.debugMessage,
            style: theme.textTheme.body1,
          )
        ],
      ),
    );
  }
}
