import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

const cBackground = Color(0xFFFFEFEB);
const cPrimary = Color(0xFFFF6955);
const cBlack = Color(0xFF000000);
const cWhite = Color(0xFFFFFFFF);

class Boxes {
  static Box<String> getEntrances() => Hive.box("entrances");
}


/* Compare Databases code:
void compareDatabases() async {
    List<String> firestoreEntrances = [];
    List<String> _entrances = entrances.values.toList();

    await FirebaseFirestore.instance.collection("Lists").get().then(
          (value) => value.docs.forEach(
            (list) {
              firestoreEntrances.add(list.get("entry"));
            },
          ),
        );

    List<String> entrancesToDelete = [];

    for (String entry in _entrances) {
      if (!firestoreEntrances.contains(entry)) {
        entrancesToDelete.add(entry);
      }
    }

    List<String> cleanEntrances = _entrances;
    entrancesToDelete.forEach((entry) {
      cleanEntrances.remove(entry);
    });

    print(cleanEntrances);

    entrances.clear();
    cleanEntrances.forEach((entry) {
      entrances.add(entry);
    });

    List<String> idsToDelete = [];

    await FirebaseFirestore.instance.collection("Lists").get().then(
          (value) => value.docs.forEach(
            (list) {
              if (entrancesToDelete.contains(list.get("entry"))) {
                idsToDelete.add(list.id);
              }
            },
          ),
        );

    for (String id in idsToDelete) {
      await FirebaseFirestore.instance.collection("Lists").doc(id).delete();
    }

    debugPrint("Deleted old data");
  }
*/