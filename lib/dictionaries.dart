import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:guess_the_build_solver/storage.dart';

const _dictionariesPath = "assets/dictionaries";
const _hypixelDictionaryPath = "$_dictionariesPath/HYPIXEL.TXT";
const _singleWordDictionaryPath = "$_dictionariesPath/SINGLE.TXT";
const _commonWordsDictionaryPath = "$_dictionariesPath/COMMON.TXT";
const _compoundWordDictionaryPath = "$_dictionariesPath/COMPOUND.TXT";

class Dictionaries {
  static List<String> allWords = [];

  static List<String>? hypixelWords;
  static List<String>? filteredSingleWords;
  static List<String>? filteredCommonWords;
  static List<String>? filteredCompoundWords;

  static Set<String>? hypixelWordsSet;

  static final _numberRegex = RegExp(r"\d");

  static bool get onlyHypixelWords {
    return AppStorage.useHypixelDictionary && !AppStorage.useSingleWordDictionary && !AppStorage.useCommonWordsDictionary && !AppStorage.useCompoundWordDictionary;
  }

  static Future<void> loadAll({
    required bool containHypixelWords,
    required bool containSingleWords,
    required bool containCommonWords,
    required bool containCompoundWords,
  }) async {
    late final List<String> singleWords;
    late final List<String> commonWords;
    late final List<String> compoundWords;

    if (filteredSingleWords == null && containSingleWords) {
      singleWords = (await rootBundle.loadString(_singleWordDictionaryPath)).split('\n');
    }

    if (filteredCommonWords == null && containCommonWords) {
      commonWords = (await rootBundle.loadString(_commonWordsDictionaryPath)).split('\n');
    }

    if (filteredCompoundWords == null && containCompoundWords) {
      final compoundWordsData = await rootBundle.load(_compoundWordDictionaryPath);
      compoundWords = latin1.decode(compoundWordsData.buffer.asUint8List()).split('\n').map((w) => w.trim()).where((w) => w.isNotEmpty).toList();
    }

    final allUnfilteredWords = [
      if (containSingleWords) ...singleWords,
      if (containCommonWords) ...commonWords,
      if (containCompoundWords) ...compoundWords,
    ];

    allWords = [];

    if (containHypixelWords) {
      hypixelWords ??= (await rootBundle.loadString(_hypixelDictionaryPath)).split('\n');
      hypixelWordsSet ??= hypixelWords!.map((e) => e.toLowerCase()).toSet();
      allWords.addAll(hypixelWords!);
    }

    for (int i = 0; i < allUnfilteredWords.length; i++) {
      final word = allUnfilteredWords[i];

      if (word.length < 3) continue;
      if (word.startsWith("-")) continue;
      if (word.endsWith("-")) continue;
      if (word.contains("'")) continue;
      if (word.contains(".")) continue;
      if (_numberRegex.hasMatch(word)) continue;

      allWords.add(word);
    }

    allWords = allWords.toSet().toList(growable: false)..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
  }

  static Future<void> loadAccordingToSettings() async {
    await loadAll(
      containHypixelWords: AppStorage.useHypixelDictionary,
      containSingleWords: AppStorage.useSingleWordDictionary,
      containCommonWords: AppStorage.useCommonWordsDictionary,
      containCompoundWords: AppStorage.useCompoundWordDictionary,
    );
  }

  static bool isHypixelWord(String word) {
    if (hypixelWordsSet == null) return false;
    return hypixelWordsSet!.contains(word.toLowerCase());
  }
}
