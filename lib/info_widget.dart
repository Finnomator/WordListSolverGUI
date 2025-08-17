import 'package:flutter/material.dart';

class InfoWidget extends StatelessWidget {
  const InfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Text("""\
By entering the hints given at the 90 second mark, the solver will return a list of all the possible words for that hint combination.

Enter a number behind the hint text to copy a match with its number.

If there are dictionaries enabled other than the Hypixel dictionary, words that are in the Hypixel dictionary will be highlighted.
"""),
    );
  }
}
