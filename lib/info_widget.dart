import 'package:flutter/material.dart';

class InfoWidget extends StatelessWidget {
  const InfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Info")),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Text("""\
By entering the hints given at the 90 second mark, the solver will return a list of all the possible words for that hint combination.

If there is exactly one match the word gets copied to clipboard automatically.

Enter a number behind the hint text to copy a match with its number."""),
      ),
    );
  }
}
