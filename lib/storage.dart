import 'package:shared_preferences/shared_preferences.dart';

class AppStorage {
  static late final SharedPreferences prefs;

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static const _autoCopyToClipboardKey = "autoCopyToClipboard";
  static bool get autoCopyToClipboard => prefs.getBool(_autoCopyToClipboardKey) ?? true;
  static set autoCopyToClipboard(bool val) => prefs.setBool(_autoCopyToClipboardKey, val);

  static const _useHypixelDictionaryKey = "useHypixelDictionary";
  static bool get useHypixelDictionary => prefs.getBool(_useHypixelDictionaryKey) ?? true;
  static set useHypixelDictionary(bool val) => prefs.setBool(_useHypixelDictionaryKey, val);

  static const _useSingleWordDictionaryKey = "useSingleWordDictionary";
  static bool get useSingleWordDictionary => prefs.getBool(_useSingleWordDictionaryKey) ?? false;
  static set useSingleWordDictionary(bool val) => prefs.setBool(_useSingleWordDictionaryKey, val);

  static const _useCompoundWordDictionaryKey = "useCompoundWordDictionary";
  static bool get useCompoundWordDictionary => prefs.getBool(_useCompoundWordDictionaryKey) ?? false;
  static set useCompoundWordDictionary(bool val) => prefs.setBool(_useCompoundWordDictionaryKey, val);

  static const _useCommonWordsDictionaryKey = "useCommonWordsDictionary";
  static bool get useCommonWordsDictionary => prefs.getBool(_useCommonWordsDictionaryKey) ?? false;
  static set useCommonWordsDictionary(bool val) => prefs.setBool(_useCommonWordsDictionaryKey, val);

  static const _everythingLowerCaseKey = "everythingLowerCase";
  static bool get everythingLowerCase => prefs.getBool(_everythingLowerCaseKey) ?? false;
  static set everythingLowerCase(bool val) => prefs.setBool(_everythingLowerCaseKey, val);
}
