import 'package:flutter/material.dart';
import 'package:gym_app/components/bottom_app_bar.dart';

class ScreenTemplate extends StatelessWidget {
  final String title;
  final List<Widget> fabs;
  final Function onMenuPressed;
  final Widget body;

  const ScreenTemplate({
    Key key,
    @required this.title,
    this.fabs = const [],
    this.body = const Placeholder(),
    this.onMenuPressed,
  }) : super(key: key);

  @override
  build(context) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            this.title,
            style: Theme.of(context).textTheme.display2,
          ),
        ),
        body: this.body,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: this.fabs,
        ),
        bottomNavigationBar: MenuBottomAppBar(onPressMenu: this.onMenuPressed),
      );
}
