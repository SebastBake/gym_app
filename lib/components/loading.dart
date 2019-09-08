import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final String text;
  Loading({this.text = ''});

  @override
  build(context) => Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    this.text,
                    style: Theme.of(context).textTheme.display1,
                  ),
                ),
                CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      );
}
