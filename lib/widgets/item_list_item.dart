import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:listy/data.dart';
import 'package:listy/services/database.dart';

class ItemListItem extends StatelessWidget {
  final Database database;
  final QueryDocumentSnapshot<Object?> object;
  final int index;
  final ThemeData theme;
  const ItemListItem({
    super.key,
    required this.database,
    required this.object,
    required this.index, required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final String entry = object.get("entry");

    return SizedBox(
      height: 42.5,
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              database.cycleItemDoneStateByEntryAndIndex(
                entry,
                index,
              );
            },
            icon: Icon(
              object.get("items")[index]["done"]
                  ? Icons.task_alt_rounded
                  : Icons.circle_outlined,
            ),
          ),
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Center(
                  child: Text(
                    object.get("items")[index]["text"],
                    style: theme.textTheme.bodyText1!.copyWith(
                      fontWeight: FontWeight.w700,
                      color:
                          object.get("items")[index]["done"] ? cGrey : cBlack,
                      decoration: object.get("items")[index]["done"]
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      inherit: object.get("items")[index]["done"],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            onPressed: () async {
              await database.deleteItemByEntryAndIndex(
                entry,
                index,
              );
            },
            icon: const Icon(Icons.remove_circle_outline_rounded),
          ),
        ],
      ),
    );
  }
}
