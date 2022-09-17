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

  TextEditingController newItemController = TextEditingController();
  TextEditingController newListNameController = TextEditingController();

  int selectedList = -1;

  final _listStream =
      FirebaseFirestore.instance.collection('Lists').snapshots();

  @override
  void dispose() {
    newListController.dispose();
    newItemController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const SettingsPage(),
            ),
          );
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
                      cursorColor: theme.primaryColor,
                      cursorWidth: 3,
                      cursorRadius: const Radius.circular(15),
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
                        selectedList = -1;
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
            const SizedBox(height: 10),
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
                        String entry = buildLists[index].get("entry");

                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              height: 50,
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: selectedList == index
                                    ? theme.primaryColor
                                    : theme.accentColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: MaterialButton(
                                  onPressed: () {
                                    if (selectedList == index) {
                                      setState(() {
                                        selectedList = -1;
                                      });
                                      return;
                                    }
                                    setState(() {
                                      selectedList = index;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: Row(
                                      children: [
                                        if (selectedList == index)
                                          Expanded(
                                            child: ListView(
                                              scrollDirection: Axis.horizontal,
                                              children: [
                                                Center(
                                                  child: Text(
                                                    buildLists[index]
                                                        .get("title"),
                                                    style: theme
                                                        .textTheme.bodyText1!
                                                        .copyWith(
                                                      color: theme.accentColor,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        if (selectedList != index)
                                          Expanded(
                                            child: Text(
                                              buildLists[index].get("title"),
                                              style: theme.textTheme.bodyText1!
                                                  .copyWith(
                                                color: selectedList == index
                                                    ? theme.accentColor
                                                    : cBlack,
                                                fontWeight: FontWeight.w700,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        const SizedBox(width: 3),
                                        Text(
                                          buildLists[index].get("entry"),
                                          style: theme.textTheme.bodyText1!
                                              .copyWith(
                                            color: cGrey,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        PopupMenuButton(
                                          tooltip: "Settings",
                                          icon: selectedList == index
                                              ? const Icon(
                                                  Icons.more_horiz_rounded,
                                                  color: Colors.white,
                                                )
                                              : const Icon(
                                                  Icons.more_horiz_rounded),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          position: PopupMenuPosition.under,
                                          color: theme.primaryColor,
                                          onSelected: (int value) {
                                            if (value == 0) {
                                              // Rename list
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    SimpleDialog(
                                                  title: Text(
                                                    "Rename list",
                                                    style: theme
                                                        .textTheme.headline1!
                                                        .copyWith(fontSize: 20),
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  children: [
                                                    Container(
                                                      height: 50,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 30,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: TextField(
                                                              cursorColor: theme
                                                                  .primaryColor,
                                                              cursorWidth: 3,
                                                              cursorRadius:
                                                                  const Radius
                                                                      .circular(15),
                                                              controller:
                                                                  newListNameController,
                                                              decoration:
                                                                  const InputDecoration(
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                                hintText:
                                                                    "New name",
                                                                hintStyle:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontSize: 18,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          IconButton(
                                                            onPressed:
                                                                () async {
                                                              if (newListNameController
                                                                      .text ==
                                                                  "") {
                                                                return;
                                                              }

                                                              await database
                                                                  .renameListByEntry(
                                                                      newListNameController
                                                                          .text,
                                                                      entry);

                                                              setState(() {
                                                                newListNameController
                                                                    .text = "";
                                                              });
                                                              // ignore: use_build_context_synchronously
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            icon: const Icon(
                                                              Icons
                                                                  .drive_file_rename_outline_rounded,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }

                                            if (value == 1) {
                                              database.deleteDocByEntry(entry);
                                            }
                                          },
                                          itemBuilder: (BuildContext context) =>
                                              <PopupMenuEntry<int>>[
                                            PopupMenuItem(
                                              value: 0,
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Icon(
                                                    Icons
                                                        .drive_file_rename_outline,
                                                    color: Colors.white,
                                                  ),
                                                  const SizedBox(width: 7.5),
                                                  Text(
                                                    'Rename',
                                                    style: theme
                                                        .textTheme.headline1!
                                                        .copyWith(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            PopupMenuItem(
                                              value: 1,
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Icon(
                                                    Icons.delete,
                                                    color: Colors.white,
                                                  ),
                                                  const SizedBox(width: 7.5),
                                                  Text(
                                                    'Delete',
                                                    style: theme
                                                        .textTheme.headline1!
                                                        .copyWith(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        // IconButton(
                                        //   onPressed: () {
                                        //     database.deleteDocByEntry(entry);
                                        //   },
                                        //   icon: const Icon(
                                        //       Icons.more_horiz_rounded),
                                        //   color: selectedList == index
                                        //       ? theme.accentColor
                                        //       : cBlack,
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            if (selectedList == index)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Container(
                                  height: ((buildLists[index]["items"] as List)
                                              .length *
                                          40) +
                                      82.5,
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: (buildLists[index]
                                                  .get("items") as List)
                                              .length,
                                          itemBuilder: (context, secondIndex) {
                                            return SizedBox(
                                              height: 42.5,
                                              child: Row(
                                                children: [
                                                  IconButton(
                                                    onPressed: () {
                                                      database
                                                          .cycleItemDoneStateByEntryAndIndex(
                                                        entry,
                                                        secondIndex,
                                                      );
                                                    },
                                                    icon: Icon(buildLists[index]
                                                                .get("items")[
                                                            secondIndex]["done"]
                                                        ? Icons.task_alt_rounded
                                                        : Icons
                                                            .circle_outlined),
                                                  ),
                                                  Expanded(
                                                    child: ListView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      children: [
                                                        Center(
                                                          child: Text(
                                                            buildLists[index].get(
                                                                        "items")[
                                                                    secondIndex]
                                                                ["text"],
                                                            style: theme
                                                                .textTheme
                                                                .bodyText1!
                                                                .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color: buildLists[
                                                                              index]
                                                                          .get(
                                                                              "items")[
                                                                      secondIndex]["done"]
                                                                  ? cGrey
                                                                  : cBlack,
                                                              decoration: buildLists[
                                                                              index]
                                                                          .get(
                                                                              "items")[secondIndex]
                                                                      ["done"]
                                                                  ? TextDecoration
                                                                      .lineThrough
                                                                  : TextDecoration
                                                                      .none,
                                                              inherit: buildLists[
                                                                          index]
                                                                      .get(
                                                                          "items")[
                                                                  secondIndex]["done"],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  IconButton(
                                                    onPressed: () async {
                                                      await database
                                                          .deleteItemByEntryAndIndex(
                                                        entry,
                                                        secondIndex,
                                                      );
                                                    },
                                                    icon: const Icon(Icons
                                                        .remove_circle_outline_rounded),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () async {
                                              await database.addListItemByEntry(
                                                entry,
                                                newItemController.text,
                                              );

                                              setState(() {
                                                newItemController.text = "";
                                              });
                                            },
                                            icon: const Icon(Icons.add_rounded),
                                            color: cGrey,
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: TextField(
                                              style: theme.textTheme.headline1!
                                                  .copyWith(
                                                fontSize: 18,
                                              ),
                                              cursorColor: theme.primaryColor,
                                              cursorWidth: 3,
                                              cursorRadius:
                                                  const Radius.circular(15),
                                              controller: newItemController,
                                              decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                hintText: "New item",
                                                hintStyle: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
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
