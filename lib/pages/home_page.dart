import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:listy/data.dart';
import 'package:listy/pages/settings_page.dart';
import 'package:listy/services/database.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Box<String> entrances = Boxes.getEntrances();
  TextEditingController newListController = TextEditingController();
  Database database = Database();

  final Stream<QuerySnapshot> _listStream =
      FirebaseFirestore.instance.collection('Lists').snapshots();

  @override
  void dispose() {
    newListController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const SettingsPage()));
        },
        backgroundColor: theme.primaryColor,
        child: const Icon(Icons.settings),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Listy",
                  style: theme.textTheme.headline1,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.filter_list_outlined),
                  iconSize: 30,
                )
              ],
            ),
            const SizedBox(height: 20),
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: newListController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "New list",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      // debugPrint(entrances.values.toString());

                      if (newListController.text.startsWith("#")) {
                        await entrances.add(newListController.text);
                        setState(() {
                          newListController.text = "";
                        });
                        return;
                      }

                      String result = await database.createNewList(
                        newListController.text,
                      );

                      if (result == "Name is empty") {
                        return;
                      }

                      await entrances.add(result);

                      setState(() {
                        newListController.text = "";
                      });
                    },
                    icon: const Icon(
                      Icons.add_rounded,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            if (entrances.isNotEmpty)
              StreamBuilder<QuerySnapshot>(
                stream: _listStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    debugPrint("Error: ${snapshot.error}");

                    return const CircularProgressIndicator();
                  }

                  if (snapshot.connectionState != ConnectionState.active) {
                    return const CircularProgressIndicator();
                  }

                  if (!snapshot.hasData) {
                    debugPrint("No data");
                    return const CircularProgressIndicator();
                  }

                  List<QueryDocumentSnapshot<Object?>> buildLists = [];

                  for (var item in snapshot.data!.docs) {
                    String entry = item.get("entry");

                    if (entrances.values.toList().contains(entry)) {
                      buildLists.add(item);
                    }
                  }

                  return Expanded(
                    child: ListView.builder(
                      itemCount: buildLists.length,
                      itemBuilder: (context, index) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(buildLists[index].get("title")),
                            Text(buildLists[index].get("entry"))
                          ],
                        );
                      },
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
