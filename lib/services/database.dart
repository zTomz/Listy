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
    });

    debugPrint("Add document: $name; $entry");

    return entry;
  }

  Future deleteEntry(String entry) async {
    QuerySnapshot<Map<String, dynamic>> lists =
        await FirebaseFirestore.instance.collection("Lists").get();

    for (var item in lists.docs) {
      if (item.get("entry") == entry) {
        String id = item.id;
        FirebaseFirestore.instance.collection("Lists").doc(id).delete();
      }
    }
  }
}
