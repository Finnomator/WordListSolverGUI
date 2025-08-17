import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guess_the_build_solver/dictionaries.dart';
import 'package:guess_the_build_solver/storage.dart';

class SuggestionsList extends StatefulWidget {
  final List<String> matches;

  const SuggestionsList({super.key, required this.matches});

  @override
  State<SuggestionsList> createState() => _SuggestionsListState();
}

class _SuggestionsListState extends State<SuggestionsList> {
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    if (widget.matches.isEmpty) {
      return const Center(child: Text("No matches"));
    }

    if (widget.matches.length == 1 && AppStorage.autoCopyToClipboard) {
      Clipboard.setData(ClipboardData(text: widget.matches[0]));
    }

    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Scrollbar(
        thumbVisibility: true,
        controller: scrollController,
        child: ListView.builder(
          controller: scrollController,
          itemCount: widget.matches.length,
          prototypeItem: const MatchTile(word: "Prototype", number: 0),
          itemBuilder: (BuildContext context, int index) {
            return MatchTile(word: widget.matches[index], number: index);
          },
        ),
      ),
    );
  }
}

class MatchTile extends StatefulWidget {
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
  State<MatchTile> createState() => _MatchTileState();
}

class _MatchTileState extends State<MatchTile> {
  late bool isCopied = widget.isCopied;

  @override
  Widget build(BuildContext context) {
    final word = AppStorage.everythingLowerCase ? widget.word.toLowerCase() : widget.word;

    return Row(
      spacing: 8,
      children: [
        Text(
          "${widget.number + 1}",
          style: const TextStyle(fontFamily: "RobotoMono", color: Colors.white70),
        ),
        SelectableText(
          word,
          style: TextStyle(
            fontFamily: "RobotoMono",
            color: !Dictionaries.onlyHypixelWords && Dictionaries.isHypixelWord(widget.word) ? const Color(0xffffee8c) : null,
          ),
        ),
        IconButton(
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: word));

            setState(() => isCopied = true);

            await Future.delayed(const Duration(seconds: 2));

            setState(() => isCopied = false);
          },
          icon: Icon(isCopied ? Icons.check : Icons.copy, size: 20),
        )
      ],
    );
  }
}
