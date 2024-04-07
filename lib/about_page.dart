import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("About")),
      body: ListView(
        children: [
          ListTile(
            title: const Text("Report a bug"),
            leading: const Icon(Icons.bug_report),
            trailing: const Icon(Icons.link),
            onTap: () => launchUrlString(
                "https://github.com/Finnomator/WordListSolverGUI/issues/new"),
          ),
          ListTile(
            title: const Text("GitHub"),
            leading: const Icon(Icons.info),
            trailing: const Icon(Icons.link),
            onTap: () => launchUrlString(
                "https://github.com/Finnomator/WordListSolverGUI"),
          ),
          const ListTile(
            title: Text("Finn Drünert 2024"),
            leading: Icon(Icons.copyright),
          )
        ],
      ),
    );
  }
}
