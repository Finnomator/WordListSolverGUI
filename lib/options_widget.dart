import 'package:flutter/material.dart';
import 'package:guess_the_build_solver/dictionaries.dart';
import 'package:guess_the_build_solver/storage.dart';

class OptionsWidget extends StatefulWidget {
  const OptionsWidget({super.key});

  @override
  State<OptionsWidget> createState() => _OptionsWidgetState();
}

class _OptionsWidgetState extends State<OptionsWidget> {
  bool tempUseHypixelDictionary = AppStorage.useHypixelDictionary;
  bool tempUseCommonWordsDictionary = AppStorage.useCommonWordsDictionary;
  bool tempUseSingleWordDictionary = AppStorage.useSingleWordDictionary;
  bool tempUseCompoundWordDictionary = AppStorage.useCompoundWordDictionary;

  bool loadingDictionaries = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Options"),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text("Auto Copy to Clipboard"),
            subtitle: const Text("If there is exactly one match, copy it to the clipboard automatically."),
            value: AppStorage.autoCopyToClipboard,
            onChanged: (value) => setState(() => AppStorage.autoCopyToClipboard = value),
          ),
          SwitchListTile(
            value: AppStorage.everythingLowerCase,
            onChanged: (value) => setState(() => AppStorage.everythingLowerCase = value),
            title: const Text("Everything Lowercase"),
            subtitle: const Text("Convert all words to lowercase."),
          ),
          const SizedBox(height: 8),
          const Text("Dictionaries", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          const SizedBox(height: 8),
          CheckboxListTile(
            value: tempUseHypixelDictionary,
            onChanged: (value) => setState(() => tempUseHypixelDictionary = value ?? true),
            title: const Text("Hypixel Dictionary"),
            subtitle: const Text("Use the Hypixel dictionary for word matching."),
          ),
          CheckboxListTile(
            value: tempUseCommonWordsDictionary,
            onChanged: (value) => setState(() => tempUseCommonWordsDictionary = value ?? true),
            title: const Text("Common Words Dictionary"),
            subtitle: const Text("List of words in common with two or more dictionaries."),
          ),
          CheckboxListTile(
            value: tempUseSingleWordDictionary,
            onChanged: (value) => setState(() => tempUseSingleWordDictionary = value ?? true),
            title: const Text("Single Word Dictionary"),
            subtitle: const Text("List of single words excluding proper nouns, acronyms, compound words and phrases. This list does not exclude archaic words or significant varient spellings."),
          ),
          CheckboxListTile(
            value: tempUseCompoundWordDictionary,
            onChanged: (value) => setState(() => tempUseCompoundWordDictionary = value ?? true),
            title: const Text("Compound Word Dictionary"),
            subtitle: const Text("List of phrases, proper nouns, acronyms and other entries which are not included in common word dictionary."),
          ),
          ListTile(
            title: Text("Total words loaded: ${Dictionaries.allWords.length}"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: loadingDictionaries
                  ? null
                  : () async {
                      AppStorage.useHypixelDictionary = tempUseHypixelDictionary;
                      AppStorage.useCommonWordsDictionary = tempUseCommonWordsDictionary;
                      AppStorage.useSingleWordDictionary = tempUseSingleWordDictionary;
                      AppStorage.useCompoundWordDictionary = tempUseCompoundWordDictionary;

                      setState(() => loadingDictionaries = true);
                      await Dictionaries.loadAccordingToSettings();
                      setState(() => loadingDictionaries = false);
                    },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                spacing: 8,
                children: [
                  const Text("Apply"),
                  if (loadingDictionaries) const SizedBox(height: 24, width: 24, child: CircularProgressIndicator()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
