import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guess_the_build_solver/about_page.dart';
import 'package:guess_the_build_solver/info_widget.dart';
import 'package:guess_the_build_solver/suggestions_list.dart';
import 'package:guess_the_build_solver/wordlist.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue, brightness: Brightness.dark),
        useMaterial3: true,
        fontFamily: "Cascadia Mono",
      ),
      home: const MyHomePage(),
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

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Guess the Build Solver"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AboutPage())),
              icon: const Icon(Icons.info))
        ],
      ),
      body: Row(
        children: [
          Flexible(
            child: Column(
              children: [
                Flexible(
                  child: Scaffold(
                    appBar: AppBar(title: const Text("Input")),
                    body: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          TextField(
                            controller: controller,
                            onChanged: inputChanged,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              counterText:
                                  "${controller.text.length} characters",
                              helperText:
                                  "${matches.length} matches (${sw.elapsedMicroseconds / 1000}ms)",
                              label: const Text("Hint Text"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Flexible(child: InfoWidget()),
              ],
            ),
          ),
          Flexible(
            child: Scaffold(
              appBar: AppBar(
                title: const Text("Matches"),
                forceMaterialTransparency: true,
              ),
              body: Container(
                decoration: BoxDecoration(
                  color: scheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SuggestionsList(matches: matches),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void inputChanged(String value) {
    sw.reset();
    sw.start();

    value = value.trim();
    final numMatch = numberEndExp.firstMatch(value);

    if (numMatch != null) {
      final int num = int.parse(numMatch.group(0)!);
      value = value.substring(0, numMatch.start).trim();
      matches = Matcher.findMatches(value).toList();
      if (num > 0 && num <= matches.length) {
        Clipboard.setData(ClipboardData(text: matches[num - 1]));
      }
    } else {
      matches = Matcher.findMatches(value).toList();
    }

    setState(() {});
    sw.stop();
  }
}
