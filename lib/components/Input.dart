import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  Input(this.getInput);
  final String Function(String)getInput;
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email',
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary
          ),
        ),
        SizedBox(height: 5),
        Container(
          padding: EdgeInsets.all(13),
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.secondary
            )
          ),
          child: Row(
            children: [
              Icon(
                Icons.email,
                color: Theme.of(context).colorScheme.secondary,
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                    color: Theme.of(context).colorScheme.secondary
                  ),
                  hintText: 'Digite seu e-mail',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}