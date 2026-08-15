import 'package:flutter/material.dart';

class InstituteLogo extends StatelessWidget {
  const InstituteLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 36,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            Icons.school_outlined,
            size: 36,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Institute Login',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}