import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmptyWeightList extends StatelessWidget {
  EmptyWeightList({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Spacer(flex: 2),
        Icon(
          CupertinoIcons.rectangle_stack_badge_plus,
          color: Theme.of(context).primaryColor,
          size: 88,
        ),
        SizedBox(height: 34),
        Text(
          'It\'s pretty quite in here\ndon\'t you think?',
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        SizedBox(height: 5),
        Text(
          'Add your weight to track afterwards',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 14),
        ),
        SizedBox(height: 34),
        CupertinoButton.filled(
          child: Text('Add'),
          onPressed: onPressed,
        ),
        Spacer(flex: 4),
      ],
    );
  }
}
