import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ErrorScreen extends StatelessWidget {
  final String debugMessage;

  ErrorScreen({this.debugMessage = ''});

  @override
  build(context) {
    var theme = Theme.of(context);

    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Oops, an error occurred.',
                style: theme.textTheme.title,
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  this.debugMessage,
                  style: theme.textTheme.subtitle,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: OutlineButton(
                  child: Text("Go Back"),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
