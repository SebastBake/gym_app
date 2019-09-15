import 'package:flutter/material.dart';

class NamedTextField extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final String Function(String) validator;
  final bool autofocus;

  const NamedTextField({
    Key key,
    @required this.controller,
    this.autofocus = false,
    this.placeholder = '',
    this.validator,
  }) : super(key: key);

  @override
  build(context) => TextFormField(
        autofocus: this.autofocus,
        controller: this.controller,
        validator: this.validator,
        decoration: InputDecoration(
          hintText: this.placeholder,
          filled: true,
          contentPadding: EdgeInsets.all(10),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
      );
}

class NamedCheckboxField extends StatelessWidget {
  final String title;
  final bool value;
  final Function(bool) onChanged;
  final IconData icon;

  const NamedCheckboxField({
    Key key,
    @required this.title,
    @required this.value,
    @required this.onChanged,
    this.icon,
  }) : super(key: key);

  @override
  build(context) => CheckboxListTile(
        title: Text(this.title),
        dense: true,
        value: this.value,
        onChanged: this.onChanged,
        secondary: Icon(this.icon),
      );
}

class FormSectionTitle extends StatelessWidget {
  final String title;

  const FormSectionTitle(this.title);

  @override
  build(context) => Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Text(
        this.title,
        style: Theme.of(context).textTheme.headline,
      ));
}

class FormButton extends StatelessWidget {
  final Function onSubmit;
  final String text;
  final Color color;

  const FormButton({
    @required this.text,
    this.onSubmit,
    this.color,
  });

  @override
  build(BuildContext context) => Padding(
        padding: EdgeInsets.all(10),
        child: RaisedButton(
          color: this.color,
          child: Text(this.text),
          onPressed: this.onSubmit,
        ),
      );
}
