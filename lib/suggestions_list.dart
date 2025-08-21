import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guess_the_build_solver/dictionaries.dart';
import 'package:guess_the_build_solver/storage.dart';

class SuggestionsList extends StatelessWidget {
  final List<String> matches;

  const SuggestionsList({super.key, required this.matches});

  @override
  Widget build(BuildContext context) {
    if (matches.isEmpty) {
      return const Center(child: Text("No matches"));
    }

    if (matches.length == 1 && AppStorage.autoCopyToClipboard) {
      Clipboard.setData(ClipboardData(text: matches[0]));
    }

    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: ListView.builder(
        itemCount: matches.length,
        prototypeItem: const MatchTile(word: "Prototype", number: 0),
        itemBuilder: (BuildContext context, int index) {
          return MatchTile(word: matches[index], number: index);
        },
      ),
    );
  }
}

class MatchTile extends StatelessWidget {
  final String word;
  final int number;
  final bool isCopied;

  const MatchTile({
    super.key,
    required this.word,
    required this.number,
    this.isCopied = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        Text(
          "${number + 1}",
          style: const TextStyle(fontFamily: "RobotoMono", color: Colors.white70),
        ),
        SelectableText(
          word,
          style: TextStyle(
            fontFamily: "RobotoMono",
            color: !Dictionaries.onlyHypixelWords && Dictionaries.isHypixelWord(word) ? const Color(0xffffee8c) : null,
          ),
        ),
        IconButton(
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: word));
            },
          icon: Icon(isCopied ? Icons.check : Icons.copy, size: 20),
        )
      ],
    );
  }
}
