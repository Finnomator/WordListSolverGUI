import 'dictionaries.dart';

class Matcher {
  static Iterable<String> findMatches(String request) {
    final exp = RegExp("^${request.replaceAll("_", "[^\\s]")}\$", caseSensitive: false);
    return Dictionaries.allWords.where((word) => request.length == word.length && exp.hasMatch(word));
  }
}
