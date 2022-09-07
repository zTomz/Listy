import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Database {
  String generateNewEntry() {
    String entry = "#";

    for (int i = 1; i <= 6; i++) {
      entry += Random.secure().nextInt(9).toString();
    }

    return entry;
  }

  Future<String> createNewList(String name) async {
    if (name == "") {
      return "Name is empty";
    }

    String entry = generateNewEntry();

    QuerySnapshot<Map<String, dynamic>> lists =
        await FirebaseFirestore.instance.collection("Lists").get();

    while (true) {
      bool isClean = true;

      for (var element in lists.docs) {
        if (element.get("entry") == entry) {
          isClean = false;
        }
      }

      if (isClean) {
        break;
      }

      entry = generateNewEntry();
    }

    await FirebaseFirestore.instance.collection("Lists").add({
      "title": name,
      "entry": entry,
      "lastEdit": Timestamp.fromDate(DateTime.now()),
      "items": [],
    });

    debugPrint("Add document: $name; $entry");

    return entry;
  }

  Future deleteDocByEntry(String entry) async {
    QuerySnapshot<Map<String, dynamic>> lists =
        await FirebaseFirestore.instance.collection("Lists").get();

    for (var item in lists.docs) {
      if (item.get("entry") == entry) {
        String id = item.id;
        FirebaseFirestore.instance.collection("Lists").doc(id).delete();
      }
    }
  }

  Future addListItemByEntry(String entry, String text) async {
    String docId = "";

    await FirebaseFirestore.instance.collection("Lists").get().then(
          // ignore: avoid_function_literals_in_foreach_calls
          (value) => value.docs.forEach(
            (list) {
              if (list.get("entry") == entry) {
                docId = list.id;
              }
            },
          ),
        );

    DocumentSnapshot<Map<String, dynamic>> doc =
        await FirebaseFirestore.instance.collection("Lists").doc(docId).get();

    List<Map<String, Object>> items = [];

    for (var item in (doc.get("items") as List)) {
      items.add({
        "text": item["text"].toString(),
        "done": item["done"] as bool,
      });
    }

    items.add({
      "text": text,
      "done": false,
    });

    await FirebaseFirestore.instance.collection("Lists").doc(docId).set(
      {
        "title": doc.get("title"),
        "entry": entry,
        "lastEdit": Timestamp.fromDate(DateTime.now()),
        "items": items,
      },
    );
  }

  Future deleteItemByEntryAndIndex(String entry, int index) async {
    String docId = "";

    await FirebaseFirestore.instance.collection("Lists").get().then(
          // ignore: avoid_function_literals_in_foreach_calls
          (value) => value.docs.forEach(
            (list) {
              if (list.get("entry") == entry) {
                docId = list.id;
              }
            },
          ),
        );

    DocumentSnapshot<Map<String, dynamic>> doc =
        await FirebaseFirestore.instance.collection("Lists").doc(docId).get();

    List<Map<String, Object>> items = [];

    for (var item in (doc.get("items") as List)) {
      items.add({
        "text": item["text"].toString(),
        "done": item["done"] as bool,
      });
    }

    items.removeAt(index);

    await FirebaseFirestore.instance.collection("Lists").doc(docId).set(
      {
        "title": doc.get("title"),
        "entry": entry,
        "lastEdit": Timestamp.fromDate(DateTime.now()),
        "items": items,
      },
    );
  }

  Future cycleItemDoneStateByEntryAndIndex(String entry, int index) async {
    String docId = "";

    await FirebaseFirestore.instance.collection("Lists").get().then(
          (value) => value.docs.forEach(
            (list) {
              if (list.get("entry") == entry) {
                docId = list.id;
              }
            },
          ),
        );

    DocumentSnapshot<Map<String, dynamic>> doc =
        await FirebaseFirestore.instance.collection("Lists").doc(docId).get();

    List<Map<String, Object>> items = [];

    int loopIndex = 0;

    for (var item in (doc.get("items") as List)) {
      if (loopIndex == index) {
        items.add({
          "text": item["text"].toString(),
          "done": !(item["done"] as bool),
        });

        loopIndex += 1;
        continue;
      }

      items.add({
        "text": item["text"].toString(),
        "done": item["done"] as bool,
      });

      loopIndex += 1;
    }

    await FirebaseFirestore.instance.collection("Lists").doc(docId).set(
      {
        "title": doc.get("title"),
        "entry": entry,
        "lastEdit": Timestamp.fromDate(DateTime.now()),
        "items": items,
      },
    );
  }
}
