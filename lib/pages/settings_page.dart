import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:listy/data.dart';
import 'package:listy/services/database.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Box<String> entrances = Boxes.getEntrances();
  Database database = Database();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Center(
        child: TextButton(
          child: const Text("Delete Data"),
          onPressed: () async {
            for (String entry in entrances.values.toList()) {
              await database.deleteDocByEntry(entry);
            }

            await entrances.clear();
          },
        ),
      ),
    );
  }
}
