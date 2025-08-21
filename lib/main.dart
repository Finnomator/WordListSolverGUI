import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guess_the_build_solver/about_page.dart';
import 'package:guess_the_build_solver/dictionaries.dart';
import 'package:guess_the_build_solver/options_widget.dart';
import 'package:guess_the_build_solver/storage.dart';
import 'package:guess_the_build_solver/suggestions_list.dart';
import 'package:guess_the_build_solver/wordlist.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool dictionariesLoaded = false;

  @override
  void initState() {
    super.initState();
    Dictionaries.loadAccordingToSettings().then((_) {
      if (!mounted) return;

      setState(() {
        dictionariesLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guess the Build Solver',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: dictionariesLoaded ? const MyHomePage() : LoadingDictionariesPage(),
    );
  }
}

class LoadingDictionariesPage extends StatelessWidget {
  const LoadingDictionariesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Loading Dictionaries...")),
      body: const Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16,
          children: [
            CircularProgressIndicator(),
            Text("Loading dictionaries, please wait..."),
          ],
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final controller = TextEditingController();
  final sw = Stopwatch();
  List<String> matches = [];
  final numberEndExp = RegExp(r"\d+$");
  int inputLength = 0;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Guess the Build Solver"),
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        actionsPadding: const EdgeInsets.symmetric(horizontal: 8.0),
        actions: [
          IconButton(onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AboutPage())), icon: const Icon(Icons.info)),
          IconButton(
            onPressed: () async {
              await Navigator.of(context).push(MaterialPageRoute(builder: (context) => const OptionsWidget()));
              setState(() {});
              inputChanged(controller.text);
            },
            icon: const Icon(Icons.settings),
          ),
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                CheckedPopupMenuItem(
                  checked: AppStorage.useHypixelDictionary,
                  child: const Text("Hypixel Dictionary"),
                  onTap: () {
                    setState(() => AppStorage.useHypixelDictionary = !AppStorage.useHypixelDictionary);
                    reloadDictionaries();
                  },
                ),
                CheckedPopupMenuItem(
                  checked: AppStorage.useCommonWordsDictionary,
                  child: const Text("Common Words Dictionary"),
                  onTap: () {
                    setState(() => AppStorage.useCommonWordsDictionary = !AppStorage.useCommonWordsDictionary);
                    reloadDictionaries();
                  },
                ),
                CheckedPopupMenuItem(
                  checked: AppStorage.useSingleWordDictionary,
                  child: const Text("Single Word Dictionary"),
                  onTap: () {
                    setState(() => AppStorage.useSingleWordDictionary = !AppStorage.useSingleWordDictionary);
                    reloadDictionaries();
                  },
                ),
                CheckedPopupMenuItem(
                  checked: AppStorage.useCompoundWordDictionary,
                  child: const Text("Compound Word Dictionary"),
                  onTap: () {
                    setState(() => AppStorage.useCompoundWordDictionary = !AppStorage.useCompoundWordDictionary);
                    reloadDictionaries();
                  },
                ),

              ];
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 8,
          children: [
            TextField(
              controller: controller,
              onChanged: inputChanged,
              style: const TextStyle(fontFamily: "RobotoMono"),
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                helperText: "$inputLength characters",
                counterText: "${matches.length} matches (${(sw.elapsedMicroseconds / 1000).toStringAsFixed(2)} ms)",
                label: const Text("Hint Text"),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: scheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SuggestionsList(matches: matches),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void inputChanged(String value) {
    sw.reset();
    sw.start();

    value = value.trim();

    if (value.length < 3) {
      matches = [];
      sw.stop();
      setState(() {});
      inputLength = value.length;
      return;
    }

    final numMatch = numberEndExp.firstMatch(value);

    if (numMatch != null) {
      final int num = int.parse(numMatch.group(0)!);

      value = value.substring(0, numMatch.start).trim();

      if (num > 0 && num <= matches.length) {
        final selectedMatch = matches[num - 1];
        final copyText = AppStorage.everythingLowerCase ? selectedMatch.toLowerCase() : selectedMatch;
        Clipboard.setData(ClipboardData(text: copyText));
      }
    } else {
      Iterable<String> foundMatches = Matcher.findMatches(value);
      if (AppStorage.everythingLowerCase) {
        foundMatches = foundMatches.map((e) => e.toLowerCase());
      }
      matches = foundMatches.toList();
    }

    inputLength = value.length;

    setState(() {});
    sw.stop();
  }

  void reloadDictionaries() async {
    await Dictionaries.loadAccordingToSettings();
    inputChanged(controller.text);
    setState(() {});
  }
}
